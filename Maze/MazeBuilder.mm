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

@interface MazeObject() {
    Maze maze;
    NSMutableArray *models;
}
@end


@implementation MazeObject

- (id)init:(Renderer*)renderer x:(int)x y:(int)y {
    self = [super init];
    maze = Maze(x,y);
    
    float startX = -x / 2;
    float startY = -y / 2;
    
    for(int i = 0; i < x; i++) {
        for(int j = 0; j < y; j++) {
            MazeFloor* floor = [[MazeFloor alloc] initWithFloor:startX + i y:-1 z:startY + j];
            [floor rotate:M_PI_4 y:0 z:0];
            [models addObject:floor];
            [renderer addModel:floor];
        }
    }
    return self;
}

@end
