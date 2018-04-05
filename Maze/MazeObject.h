//
//  MazeBuilder.h
//  Maze
//
//  Created by Matthew Taylor on 2018-03-14.
//  Copyright © 2018 Matthew Taylor. All rights reserved.
//

#ifndef MazeObject_h
#define MazeObject_h

#import "Renderer.h"

@interface MazeObject : NSObject

@property GLKMatrix4 startLocation;

- (id)init:(Renderer*)renderer row:(int)row col:(int)col;

@end

#endif /* MazeObject_h */
