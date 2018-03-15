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

- (id)init:(Renderer*)renderer x:(int)x y:(int)y {
    self = [super init];
    maze = new Maze(x,y);
    maze->Create();
    
    float startX = -x / 2;
    float startY = y / 2;
    
    [renderer.camera translate:startX y:0 z: startY + 1];
    [renderer.camera rotate:0 y:0 z:0];
    
    for(int i = 0; i < x; i++) {
        for(int j = 0; j < y; j++) {
            int xCoord = startX + i;
            int yCoord = startY - j;
            
            MazeFloor* floor = [[MazeFloor alloc] initWithFloor:xCoord y:0 z:yCoord];
            MazeCell cell = maze->GetCell(i,j);
            
            if(cell.northWallPresent){
                MazeWall *wall = [[MazeWall alloc] init:xCoord y:0 z:yCoord dir:0];
                wall.texIndex = 1;
                [renderer addModel:wall];
            }
            if(cell.westWallPresent){
                MazeWall *wall = [[MazeWall alloc] init:xCoord y:0 z:yCoord dir:1];
                wall.texIndex = 0;
                [renderer addModel:wall];
            }
            if(cell.southWallPresent){
                MazeWall *wall = [[MazeWall alloc] init:xCoord y:0 z:yCoord dir:2];
                wall.texIndex = 0;
                [renderer addModel:wall];
            }
            if(cell.eastWallPresent){
                MazeWall *wall = [[MazeWall alloc] init:xCoord y:0 z:yCoord dir:3];
                wall.texIndex = 0;
                [renderer addModel:wall];
            }
            
            //[floor rotate:M_PI_4 y:0 z:0];
            [renderer addModel:floor];
        }
    }
    return self;
}

@end
