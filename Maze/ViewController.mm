//
//  ViewController.m
//  Maze
//
//  Created by Matthew Taylor on 2018-02-28.
//  Copyright © 2018 Matthew Taylor. All rights reserved.
//

#import "ViewController.h"
#import "MazeObject.h"
#include "GLESRenderer.hpp"

@interface ViewController () {
    Renderer *glesRenderer;
    MazeObject *maze;
}

@property (weak, nonatomic) IBOutlet UISwitch *dayToggle;
@property (weak, nonatomic) IBOutlet UISwitch *fogToggle;
@property (weak, nonatomic) IBOutlet UISwitch *lightToggle;
@property (weak, nonatomic) IBOutlet UISwitch *fogTypeToggle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    glesRenderer = [[Renderer alloc] init];
    GLKView *view = (GLKView *)self.view;
    [glesRenderer setup:view];
    [glesRenderer loadModels];
    
    UIPanGestureRecognizer * singleDragRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(singleDragResponder:)];
    [singleDragRecognizer setMinimumNumberOfTouches:1];
    [singleDragRecognizer setMaximumNumberOfTouches:1];
    [self.view addGestureRecognizer:singleDragRecognizer];
    
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapResponder:)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    [tapRecognizer setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:tapRecognizer];
    
    UITapGestureRecognizer * doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapResponder:)];
    [doubleTapRecognizer setNumberOfTouchesRequired:2];
    [doubleTapRecognizer setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTapRecognizer];
    
    maze = [[MazeObject alloc] init:glesRenderer row:10 col:10];
    
    glesRenderer.camera.transform = GLKMatrix4Translate(maze.startLocation, 0, 0, -1.5f);
    [glesRenderer.camera rotate:0 y:M_PI z:0];
    
    [glesRenderer addCube:maze.startLocation];
    
}

- (void)singleDragResponder: (UIPanGestureRecognizer *) sender {
    CGPoint controlPoint = [sender translationInView:self.view];
    CGPoint vector = [sender velocityInView:self.view];
    if (vector.x > 0)
        [glesRenderer.camera rotate:0 y:-.035 z:0];
    if (vector.x < 0)
        [glesRenderer.camera rotate:0 y:.035 z:0];
    
    if (vector.y > 0.5)
        [glesRenderer.camera translate:0 y:0 z:.1];
    if (vector.y < -0.5) 
        [glesRenderer.camera translate:0 y:0 z:-.1];
}

- (void)tapResponder: (UITapGestureRecognizer *) sender {
    glesRenderer.camera.transform = GLKMatrix4Translate(maze.startLocation, 0, 0, -1.5f);
    [glesRenderer.camera rotate:0 y:M_PI z:0];
}

- (void)doubleTapResponder: (UITapGestureRecognizer *) sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)update {
    [glesRenderer update];
    if ([_dayToggle isOn]) {
        [glesRenderer nightDiffuse];
    } else {
        [glesRenderer dayDiffuse];
    }
    
    if ([_fogToggle isOn]) {
        [glesRenderer fogOn];
    } else {
        [glesRenderer fogOff];
    }
    
    if ([_fogTypeToggle isOn]) {
        [glesRenderer fogSpecular];
    } else {
        [glesRenderer fogLinear];
    }
    
    if ([_lightToggle isOn]) {
        [glesRenderer flashlightOn];
    } else {
        [glesRenderer flashlightOff];
    }
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [glesRenderer draw:rect];
}

- (void)resetCamera {
}

@end
