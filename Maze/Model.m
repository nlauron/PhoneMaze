//
//  Model.m
//  Maze
//
//  Created by Matthew Taylor on 2018-03-14.
//  Copyright © 2018 Matthew Taylor. All rights reserved.
//

#import "Model.h"

@implementation Model

@synthesize indices;
@synthesize numIndices;
@synthesize transform;
@synthesize vertices;
@synthesize texCoords;
@synthesize texIndex;
@synthesize normals;

- (id)init:(float)x y:(float)y z:(float)z {
    self = [super init];
    self.transform = GLKMatrix4Identity;
    self.transform = GLKMatrix4Translate(self.transform, x, y, z);
    self.texIndex = 0;
    return self;
}

- (id) initWithVerts:(float*)verts numVert:(int)numVert norms:(float*)norms inds:(int*)inds numInd:(int)numInd {
    self = [self init:0 y:0 z:0];
    self.vertices = malloc(sizeof(float) * numVert * 3);
    memcpy(self.vertices, verts, sizeof(float) * numVert * 3);
    self.normals = malloc(sizeof(float) * numVert * 3);
    memcpy(self.normals, norms, sizeof(float) * numVert * 3);
    self.indices = malloc(sizeof(int) * numInd);
    memcpy(self.indices, inds, sizeof(int) * numInd);
    self.numIndices = numInd;
    
    return self;
}

- (id) initWithTex:(float*)verts numVert:(int)numVert norms:(float*)norms inds:(int*)inds numInd:(int)numInd texels:(float*)texels texInd:(int)texInd {
    self = [self initWithVerts:verts numVert:numVert norms:norms inds:inds numInd:numInd];
    self.texCoords = malloc(sizeof(float) * numVert * 2);
    memcpy(self.texCoords, texels, sizeof(float) * numVert * 2);
    self.texIndex = texInd;
    
    return self;
}

- (void)translate:(float)x y:(float)y z:(float)z {
    self.transform = GLKMatrix4Translate(self.transform, x, y, z);
}

- (void)rotate:(float)x y:(float)y z:(float)z {
    self.transform = GLKMatrix4RotateX(self.transform, x);
    self.transform = GLKMatrix4RotateY(self.transform, y);
    self.transform = GLKMatrix4RotateZ(self.transform, z);
}

- (void)scale:(float)x y:(float)y z:(float)z {
    self.transform = GLKMatrix4Scale(self.transform, x, y, z);
}



@end
