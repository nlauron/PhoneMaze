//
//  Copyright © 2017 Borna Noureddin. All rights reserved.
//

#ifndef Renderer_h
#define Renderer_h
#import <GLKit/GLKit.h>
#import "Model.h"

@interface Renderer : NSObject

@property float rotAngle;
@property bool isRotating;
@property Model* camera;


- (void)setup:(GLKView *)view;
- (void)loadModels;
- (void)update;
- (void)draw:(CGRect)drawRect;
- (void)dayDiffuse;
- (void)nightDiffuse;
- (void)fogOn;
- (void)fogOff;
- (void)fogLinear;
- (void)fogSpecular;
- (void)flashlightOn;
- (void)flashlightOff;
- (void)addModel:(Model*)mod;

@end

#endif /* Renderer_h */
