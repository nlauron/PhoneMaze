//
//  Model.h
//  Maze
//
//  Created by Matthew Taylor on 2018-03-14.
//  Copyright © 2018 Matthew Taylor. All rights reserved.
//

#ifndef Model_h
#define Model_h

#import <GLKit/GLKit.h>

@interface Model : NSObject

@property int *indices;
@property float *vertices;
@property float *normals;
@property float *texCoords;
@property int numIndices;
@property int texIndex;
@property GLKMatrix4 transform;

- (id) init:(float)x y:(float)y z:(float)z;
- (void) translate:(float)x y:(float)y z:(float)z;
- (void) rotate:(float)x y:(float)y z:(float)z;
- (void) scale:(float)x y:(float)y z:(float)z;

@end

#endif /* Model_h */
