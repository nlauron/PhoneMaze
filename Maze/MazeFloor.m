//
//  MazeFloor.m
//  Maze
//
//  Created by Matthew Taylor on 2018-03-14.
//  Copyright © 2018 Matthew Taylor. All rights reserved.
//

#import "MazeFloor.h"

@implementation MazeFloor

- (id)initWithFloor:(float)x y:(float)y z:(float)z {
    self = [super init:x y:y z:z];
    
    float verts[] = {
        -0.5f, -0.5f, 0.5f,
        -0.5f, -0.5f, -0.5f,
        0.5f, -0.5f, -0.5f,
        0.5f, -0.5f, 0.5f
    };
    
    float norms[] = {
        0.0f, 1.0f, 0.0f,
        0.0f, 1.0f, 0.0f,
        0.0f, 1.0f, 0.0f,
        0.0f, 1.0f, 0.0f
    };
    
    float texs[] = {
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 0.0f
    };
    
    int inds[] = {
        0, 2, 1,
        0, 3, 2
    };
    
    self.vertices = malloc(sizeof(float) * 12);
    memcpy(self.vertices, verts, sizeof(float) * 12);
    self.normals = malloc(sizeof(float) * 12);
    memcpy(self.normals, norms, sizeof(float) * 12);
    self.texCoords = malloc(sizeof(float) * 12);
    memcpy(self.texCoords, texs, sizeof(float) * 12);
    self.indices = malloc(sizeof(int) * 6);
    memcpy(self.indices, inds, sizeof(int) * 6);
    self.numIndices = 6;
        
    return self;
}

@end
