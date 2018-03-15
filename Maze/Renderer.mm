//
//  Copyright © 2017 Borna Noureddin. All rights reserved.
//

#import "Renderer.h"
#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#include <chrono>
#include "GLESRenderer.hpp"
#import "MazeFloor.h"


// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    UNIFORM_PASSTHROUGH,
    UNIFORM_SHADEINFRAG,
    UNIFORM_TEXTURE,
    UNIFORM_FOGGY,
    UNIFORM_FOGSELECTOR,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};

@interface Renderer () {
    GLKView *theView;
    GLESRenderer glesRenderer;
    GLuint programObject;
    GLuint floorTexture, crateTexture, wallTextureNone, wallTextureLeft, wallTextureRight, wallTextureBoth;
    std::chrono::time_point<std::chrono::steady_clock> lastTime;
    NSMutableArray *modelList;

    GLKMatrix4 mvp;
    GLKMatrix3 normalMatrix;
    Model *cube;
}

@end

@implementation Renderer

@synthesize isRotating;
@synthesize rotAngle;
@synthesize camera;

- (void)dealloc
{
    glDeleteProgram(programObject);
}

- (void)loadModels
{
    
    //NSLog([NSString stringWithFormat:@"vertices: %p\n normals: %p\ntexCoords: %p\nnumIndices: %d\nindices: %p", mod.vertices, mod.normals, mod.texCoords, mod.numIndices, mod.indices]);

}

- (void)setup:(GLKView *)view
{
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    if (!view.context) {
        NSLog(@"Failed to create ES context");
    }
    
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    theView = view;
    [EAGLContext setCurrentContext:view.context];
    if (![self setupShaders])
        return;
    rotAngle = 0.0f;
    isRotating = 1;

    floorTexture = [self setupTexture:@"dirt.jpg"];
    crateTexture = [self setupTexture:@"crate.jpg"];
    wallTextureNone = [self setupTexture:@"wall_none.jpg"];
    wallTextureLeft = [self setupTexture:@"wall_left.jpg"];
    wallTextureRight = [self setupTexture:@"wall_right.jpg"];
    wallTextureBoth = [self setupTexture:@"wall_both.jpg"];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, floorTexture);
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, crateTexture);
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, wallTextureNone);
    glActiveTexture(GL_TEXTURE3);
    glBindTexture(GL_TEXTURE_2D, wallTextureLeft);
    glActiveTexture(GL_TEXTURE4);
    glBindTexture(GL_TEXTURE_2D, wallTextureRight);
    glActiveTexture(GL_TEXTURE5);
    glBindTexture(GL_TEXTURE_2D, wallTextureBoth);

    glUniform1i(uniforms[UNIFORM_TEXTURE], 0);

    glClearColor ( 0.0f, 0.0f, 0.0f, 0.0f );
    glEnable(GL_DEPTH_TEST);
    lastTime = std::chrono::steady_clock::now();
    
    camera = [[Model alloc] init:0 y:0 z:0];
    
    modelList = [[NSMutableArray alloc] init];
    
    cube = [[Model alloc] init:0 y:0 z:0];

    float *vertices, *normals, *texCoords;
    int *indices;
    
    cube.numIndices = glesRenderer.GenCube(0.3f, &vertices, &normals, &texCoords, &indices);
    cube.vertices = vertices;
    cube.normals = normals;
    cube.texCoords = texCoords;
    cube.indices = indices;
    cube.texIndex = 1;
    
    [modelList addObject:cube];

}

- (void)update
{
    auto currentTime = std::chrono::steady_clock::now();
    auto elapsedTime = std::chrono::duration_cast<std::chrono::milliseconds>(currentTime - lastTime).count();
    lastTime = currentTime;
    
    [cube rotate:0.001f * elapsedTime y:0 z: 0.001f * elapsedTime];

}

- (void)draw:(CGRect)drawRect;
{

    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, FALSE, (const float *)mvp.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, normalMatrix.m);
    glUniform1i(uniforms[UNIFORM_PASSTHROUGH], false);
    glUniform1i(uniforms[UNIFORM_SHADEINFRAG], true);

    glViewport(0, 0, (int)theView.drawableWidth, (int)theView.drawableHeight);
    glClear ( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    glUseProgram ( programObject );
    
    GLKMatrix4 view = GLKMatrix4Invert(camera.transform, nil);
    
    for(Model *mod in modelList) {
        // Perspective
        //mvp = GLKMatrix4Translate(GLKMatrix4Identity, 0.0, 0.0, -5.0);
        //mvp = GLKMatrix4Rotate(mvp, rotAngle, 1.0, 0.0, 1.0 );
        mvp = mod.transform;
        normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(mvp), NULL);
        mvp = GLKMatrix4Multiply(view, mvp);
        
        float aspect = (float)theView.drawableWidth / (float)theView.drawableHeight;
        GLKMatrix4 perspective = GLKMatrix4MakePerspective(60.0f * M_PI / 180.0f, aspect, 0.5f, 20.0f);
        
        mvp = GLKMatrix4Multiply(perspective, mvp);

        //NSLog([NSString stringWithFormat:@"vertices: %p\n normals: %p\ntexCoords: %p\nnumIndices: %d\nindices: %p", mod.vertices, mod.normals, mod.texCoords, mod.numIndices, mod.indices]);
        glVertexAttribPointer ( 0, 3, GL_FLOAT,
                               GL_FALSE, 3 * sizeof ( GLfloat ), mod.vertices );
        glEnableVertexAttribArray ( 0 );
        
        glVertexAttribPointer ( 2, 3, GL_FLOAT,
                               GL_FALSE, 3 * sizeof ( GLfloat ), mod.normals );
        glEnableVertexAttribArray ( 2 );
        
        glVertexAttribPointer ( 3, 2, GL_FLOAT,
                               GL_FALSE, 2 * sizeof ( GLfloat ), mod.texCoords );
        glEnableVertexAttribArray ( 3 );
        
        glUniform1i(uniforms[UNIFORM_TEXTURE], mod.texIndex);
        
        glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, FALSE, (const float *)mvp.m);
        glDrawElements ( GL_TRIANGLES, mod.numIndices, GL_UNSIGNED_INT, mod.indices );
    }
}


- (bool)setupShaders
{
    // Load shaders
    char *vShaderStr = glesRenderer.LoadShaderFile([[[NSBundle mainBundle] pathForResource:[[NSString stringWithUTF8String:"Shader.vsh"] stringByDeletingPathExtension] ofType:[[NSString stringWithUTF8String:"Shader.vsh"] pathExtension]] cStringUsingEncoding:1]);
    char *fShaderStr = glesRenderer.LoadShaderFile([[[NSBundle mainBundle] pathForResource:[[NSString stringWithUTF8String:"Shader.fsh"] stringByDeletingPathExtension] ofType:[[NSString stringWithUTF8String:"Shader.fsh"] pathExtension]] cStringUsingEncoding:1]);
    programObject = glesRenderer.LoadProgram(vShaderStr, fShaderStr);
    if (programObject == 0)
        return false;
    
    // Set up uniform variables
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(programObject, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(programObject, "normalMatrix");
    uniforms[UNIFORM_PASSTHROUGH] = glGetUniformLocation(programObject, "passThrough");
    uniforms[UNIFORM_SHADEINFRAG] = glGetUniformLocation(programObject, "shadeInFrag");
    uniforms[UNIFORM_TEXTURE] = glGetUniformLocation(programObject, "texSampler");

    return true;
}

// Load in and set up texture image (adapted from Ray Wenderlich)
- (GLuint)setupTexture:(NSString *)fileName
{
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte *spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);
    return texName;
}

- (void)nightDiffuse
{
    glVertexAttrib4f ( 4, 0.3f, 0.416f, 0.6275f, 1.0f);
    glClearColor(0.0f, 0.075f, 0.188f, 1.0f);
}

- (void)dayDiffuse
{
    glVertexAttrib4f ( 4, 1.0f, 0.93f, 0.486f, 1.0f );
    glClearColor(0.26f, 0.525f, 0.957f, 1.0f);
}

- (void)fogOn
{
    glUniform1f(uniforms[UNIFORM_FOGGY], true);
}

- (void)fogOff
{
    glUniform1f(uniforms[UNIFORM_FOGGY], false);
}

- (void)fogLinear
{
    glUniform1f(uniforms[UNIFORM_FOGSELECTOR], 0);
}

- (void)fogSpecular
{
    glUniform1f(uniforms[UNIFORM_FOGSELECTOR], 1);
    
}

- (void)flashlightOn
{
    
}

- (void)flashlightOff
{
    
}

- (void)addModel:(Model*)mod {
    [modelList addObject:mod];
}

- (void)addCube:(GLKMatrix4)loc {
    cube.transform = loc;
}

@end

