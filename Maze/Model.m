//
//  Model.m
//  Maze
//
//  Created by Matthew Taylor on 2018-03-14.
//  Copyright © 2018 Matthew Taylor. All rights reserved.
//

#import "Model.h"

@implementation Model

@synthesize indices;
@synthesize numIndices;
@synthesize transform;
@synthesize vertices;
@synthesize texCoords;
@synthesize texIndex;
@synthesize normals;

- (id)init:(float)x y:(float)y z:(float)z {
    self = [super init];
    self.transform = GLKMatrix4Identity;
    self.transform = GLKMatrix4Translate(self.transform, x, y, z);
    self.texIndex = 0;
    return self;
}

- (void)translate:(float)x y:(float)y z:(float)z {
    self.transform = GLKMatrix4Translate(self.transform, x, y, z);
}

- (void)rotate:(float)x y:(float)y z:(float)z {
    self.transform = GLKMatrix4RotateX(self.transform, x);
    self.transform = GLKMatrix4RotateY(self.transform, y);
    self.transform = GLKMatrix4RotateZ(self.transform, z);
}

- (void)scale:(float)x y:(float)y z:(float)z {
    self.transform = GLKMatrix4Scale(self.transform, x, y, z);
}



@end
