//
//  MazeBuilder.m
//  Maze
//
//  Created by Matthew Taylor on 2018-03-14.
//  Copyright © 2018 Matthew Taylor. All rights reserved.
//

#import "MazeBuilder.h"
#include "maze.hpp"
#include "MazeFloor.h"
#include "MazeWall.h"

@interface MazeObject() {
    Maze *maze;
}
@end


@implementation MazeObject

- (id)init:(Renderer*)renderer row:(int)row col:(int)col {
    self = [super init];
    maze = new Maze(row,col);
    maze->Create();
    
    float startX = -col / 2.0f;
    float startZ = -row / 2.0f;
    
    [renderer.camera translate:startX y:0 z: startZ - 1];
    [renderer.camera rotate:0 y:M_PI z:0];
    
    for(int i = 0; i < row; i++) {
        for(int j = 0; j < col; j++) {
            int xCoord = startX + i;
            int zCoord = startZ + j;
            
            MazeFloor* floor = [[MazeFloor alloc] initWithFloor:xCoord y:0 z:zCoord];
            MazeCell cell = maze->GetCell(i,j);
            
            if(cell.northWallPresent){
                MazeWall *wall = [[MazeWall alloc] init:xCoord y:0 z:zCoord dir:0];
                wall.texIndex = 0;
                [renderer addModel:wall];
            }
            if(cell.westWallPresent){
                MazeWall *wall = [[MazeWall alloc] init:xCoord y:0 z:zCoord dir:1];
                wall.texIndex = 0;
                [renderer addModel:wall];
            }
            if(cell.southWallPresent){
                MazeWall *wall = [[MazeWall alloc] init:xCoord y:0 z:zCoord dir:2];
                wall.texIndex = 0;
                [renderer addModel:wall];
            }
            if(cell.eastWallPresent){
                MazeWall *wall = [[MazeWall alloc] init:xCoord y:0 z:zCoord dir:3];
                wall.texIndex = 0;
                [renderer addModel:wall];
            }
            
            [renderer addModel:floor];
        }
    }
    return self;
}

@end
