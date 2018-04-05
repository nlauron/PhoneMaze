//
//  ModelReader.m
//  Maze
//
//  Created by Matthew Taylor on 2018-04-04.
//  Copyright © 2018 Matthew Taylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelReader.h"

@implementation ModelReader

+ (Model*)readModel:(NSString *)res {
    NSString *path = [[NSBundle mainBundle] pathForResource:res ofType:@"obj"];
    NSString *fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [fileContents componentsSeparatedByString:@"\n"];
    
    if(fileContents == nil) {
        NSLog(@"MeepMerp");
    }
    
    float *startVertices = malloc(0);
    int startVertSize = 0;
    float *startNormals = malloc(0);
    int startNormSize = 0;
    float *startTexels = malloc(0);
    int startTexSize = 0;
    int *faces = malloc(0);
    int faceSize = 0;
    
    for (NSString *line in lines) {
        if([line hasPrefix:@"v "]) {
            [ModelReader parseVert:line buffer:&startVertices buffSize:&startVertSize];
        } else if([line hasPrefix:@"vt"]) {
            [ModelReader parseVert:line buffer:&startTexels buffSize:&startTexSize];
        } else if([line hasPrefix:@"vn"]) {
            [ModelReader parseVert:line buffer:&startNormals buffSize:&startNormSize];
        } else if([line hasPrefix:@"f "]) {
            [ModelReader parseFace:line buffer:&faces buffSize:&faceSize];
        }
    }
    
    
    float *vertices = malloc(sizeof(float) * faceSize * 9);
    float *normals = malloc(sizeof(float) * faceSize * 9);
    float *texels = malloc(sizeof(float) * faceSize * 6);
    int *indices = malloc(sizeof(int) * faceSize * 3);
    
    for(int i = 0; i < faceSize; i++) {
        memcpy(vertices + i * 9, startVertices + faces[i * 9] * 3, sizeof(float) * 3);
        memcpy(texels + i * 6, startTexels + faces[i * 9 + 1] * 3, sizeof(float) * 2);
        memcpy(normals + i * 9, startNormals + faces[i * 9 + 2] * 3, sizeof(float) * 3);
        indices[i * 3] = i * 3;
        memcpy(vertices + i * 9 + 3, startVertices + faces[i * 9 + 3] * 3, sizeof(float) * 3);
        memcpy(texels + i * 6 + 2, startTexels + faces[i * 9 + 4] * 3, sizeof(float) * 2);
        memcpy(normals + i * 9 + 3, startNormals + faces[i * 9 + 5] * 3, sizeof(float) * 3);
        indices[i * 3 + 1] = i * 3 + 1;
        memcpy(vertices + i * 9 + 6, startVertices + faces[i * 9 + 6] * 3, sizeof(float) * 3);
        memcpy(texels + i * 6 + 4, startTexels + faces[i * 9 + 7] * 3, sizeof(float) * 2);
        memcpy(normals + i * 9 + 6, startNormals + faces[i * 9 + 8] * 3, sizeof(float) * 3);
        indices[i * 3 + 2] = i * 3 + 2;
    }
    
    free(startNormals);
    free(startVertices);
    free(startTexels);
    free(faces);

    return [[Model alloc] initWithTex:vertices numVert:faceSize norms:normals inds:indices numInd:faceSize * 3 texels:texels texInd:6];
    
    /*for(int i = 0; i < faceSize; i++) {
        NSLog([NSString stringWithFormat:@"f %d/%d/%d %d/%d/%d %d/%d/%d",faces[i * 9],faces[i * 9 + 1],faces[i * 9 + 2],faces[i * 9 + 3],faces[i * 9 + 4],faces[i * 9 + 5],faces[i * 9 + 6],faces[i * 9 + 7],faces[i * 9 + 8]]);
    }*/
    /*for(int i = 0; i < texSize; i += 3) {
        NSLog([NSString stringWithFormat:@"%0.2f,%0.2f,%0.2f",texels[i], texels[i+1], texels[i+2]]);
    }
    NSLog([NSString stringWithFormat:@"vert:%d norm:%d tex:%d",vertSize,normSize,texSize ]);*/
    
}

+ (void) parseVert:(NSString*)line buffer:(float**)buffer buffSize:(int*)buffSize {
    NSScanner *scan = [NSScanner scannerWithString:line];
    [scan setScanLocation:2];
    
    float x,y,z;
    
    [scan scanFloat:&x];
    [scan scanFloat:&y];
    [scan scanFloat:&z];
    
    float *temp = malloc(sizeof(float) * (*buffSize + 3));
    memcpy(temp, *buffer, sizeof(float) * (*buffSize));
    temp[*buffSize] = x;
    temp[*buffSize + 1] = y;
    temp[*buffSize + 2] = z;
    *buffer = realloc(*buffer, sizeof(float) * (*buffSize + 3));
    memcpy(*buffer, temp, sizeof(float) * (*buffSize + 3));
    *buffSize += 3;
    free(temp);
}

+ (void) parseFace:(NSString*)line buffer:(int**)buffer buffSize:(int*)buffSize {
    NSScanner *scan = [NSScanner scannerWithString:line];
    [scan setScanLocation:1];
    [scan setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"/ "]];
    
    int *temp = malloc(sizeof(int) * 9 * (*buffSize + 1));
    memcpy(temp, *buffer, sizeof(int) * 9 * (*buffSize));
    
    int v,t,n;
    
    [scan scanInt:&v];
    [scan scanInt:&t];
    [scan scanInt:&n];
    
    temp[*buffSize * 9] = v - 1;
    temp[*buffSize * 9 + 1] = t - 1;
    temp[*buffSize * 9 + 2] = n - 1;
    
    [scan scanInt:&v];
    [scan scanInt:&t];
    [scan scanInt:&n];
    
    temp[*buffSize * 9 + 3] = v - 1;
    temp[*buffSize * 9 + 4] = t - 1;
    temp[*buffSize * 9 + 5] = n - 1;
    
    [scan scanInt:&v];
    [scan scanInt:&t];
    [scan scanInt:&n];
    
    temp[*buffSize * 9 + 6] = v - 1;
    temp[*buffSize * 9 + 7] = t - 1;
    temp[*buffSize * 9 + 8] = n - 1;
    
    *buffer = realloc(*buffer, sizeof(int) * 9 * (*buffSize + 1));
    memcpy(*buffer, temp, sizeof(int) * 9 * (*buffSize + 1));
    *buffSize += 1;
    free(temp);
}

@end
