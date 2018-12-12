//
//  HZCAEAGLLayer.h
//  OpenGLESDemo
//
//  Created by iMac on 2018/4/15.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@interface HZCAEAGLLayer : CAEAGLLayer

@property (nonatomic , assign) BOOL isFullYUVRange;

- (void)setupGL;
- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end
