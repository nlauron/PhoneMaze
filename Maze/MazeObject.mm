//
//  MazeBuilder.m
//  Maze
//
//  Created by Matthew Taylor on 2018-03-14.
//  Copyright © 2018 Matthew Taylor. All rights reserved.
//

#import "MazeObject.h"
#include "maze.hpp"
#include "MazeFloor.h"
#include "MazeWall.h"

@interface MazeObject() {
    Maze *maze;
}
@end

@implementation MazeObject

@synthesize startLocation;

- (id)init:(Renderer*)renderer row:(int)row col:(int)col {
    self = [super init];
    maze = new Maze(row,col);
    maze->Create();
    
    float startX = -col / 2.0f;
    float startZ = -row / 2.0f;
    
    startLocation = GLKMatrix4Translate(GLKMatrix4Identity, startX, 0, startZ);
    
    for(int i = 0; i < row; i++) {
        for(int j = 0; j < col; j++) {
            int xCoord = startX + j;
            int zCoord = startZ + i;
            
            MazeFloor* floor = [[MazeFloor alloc] initWithFloor:xCoord y:0 z:zCoord];
            MazeCell cell = maze->GetCell(i,j);
            
            if(cell.northWallPresent){
                MazeWall *wall = [[MazeWall alloc] init:xCoord y:0 z:zCoord dir:0];
                wall.texIndex = 2;
                if(cell.westWallPresent) wall.texIndex += 1;
                if(cell.eastWallPresent) wall.texIndex += 2;
                [renderer addModel:wall];
            }
            if(cell.westWallPresent){
                MazeWall *wall = [[MazeWall alloc] init:xCoord y:0 z:zCoord dir:1];
                wall.texIndex = 2;
                if(cell.southWallPresent) wall.texIndex += 1;
                if(cell.northWallPresent) wall.texIndex += 2;
                [renderer addModel:wall];
            }
            if(cell.southWallPresent){
                MazeWall *wall = [[MazeWall alloc] init:xCoord y:0 z:zCoord dir:2];
                wall.texIndex = 2;
                if(cell.eastWallPresent) wall.texIndex += 1;
                if(cell.westWallPresent) wall.texIndex += 2;
                [renderer addModel:wall];
            }
            if(cell.eastWallPresent){
                MazeWall *wall = [[MazeWall alloc] init:xCoord y:0 z:zCoord dir:3];
                wall.texIndex = 2;
                if(cell.northWallPresent) wall.texIndex += 1;
                if(cell.southWallPresent) wall.texIndex += 2;
                [renderer addModel:wall];
            }
            
            [renderer addModel:floor];
        }
    }
    return self;
}

@end
