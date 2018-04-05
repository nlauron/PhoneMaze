//
//  ModelReader.h
//  Maze
//
//  Created by Matthew Taylor on 2018-04-04.
//  Copyright © 2018 Matthew Taylor. All rights reserved.
//

#ifndef ModelReader_h
#define ModelReader_h

#import "Model.h"
#import <GLKit/GLKit.h>

@interface ModelReader : NSObject

+ (Model*)readModel:(NSString*)res;
+ (void) parseVert:(NSString*)line buffer:(float**)buffer buffSize:(int*)buffSize;

@end

#endif /* ModelReader_h */
