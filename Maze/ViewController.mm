//
//  ViewController.m
//  Maze
//
//  Created by Matthew Taylor on 2018-02-28.
//  Copyright © 2018 Matthew Taylor. All rights reserved.
//

#import "ViewController.h"
#import "MazeBuilder.h"

@interface ViewController () {
    Renderer *glesRenderer;
    MazeObject *maze;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    glesRenderer = [[Renderer alloc] init];
    GLKView *view = (GLKView *)self.view;
    [glesRenderer setup:view];
    [glesRenderer loadModels];
    
    maze = [[MazeObject alloc] init:glesRenderer x:10 y:10];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)update {
    [glesRenderer update];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [glesRenderer draw:rect];
}
@end
