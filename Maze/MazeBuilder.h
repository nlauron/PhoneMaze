//
//  MazeBuilder.h
//  Maze
//
//  Created by Matthew Taylor on 2018-03-14.
//  Copyright © 2018 Matthew Taylor. All rights reserved.
//

#ifndef MazeBuilder_h
#define MazeBuilder_h

#import "Renderer.h"

@interface MazeObject : NSObject

- (id)init:(Renderer*)renderer row:(int)row col:(int)col;

@end

#endif /* MazeBuilder_h */
