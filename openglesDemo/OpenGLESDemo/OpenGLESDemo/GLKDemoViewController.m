//
//  GLKDemoViewController.m
//  OpenGLESDemo
//
//  Created by iMac on 2018/4/4.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "GLKDemoViewController.h"
#import <OpenGLES/ES2/gl.h>

@interface GLKDemoViewController () <GLKViewDelegate>
@property(nonatomic,strong)EAGLContext *mContext;

@property(nonatomic,strong)GLKBaseEffect *mEffect;

@property(nonatomic,assign)int mCount;


@end

@implementation GLKDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //新建OpenGL ES 上下文
    self.mContext = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    GLKView *view = (GLKView *)self.view;
    
    view.context = self.mContext;
    
    //颜色缓冲区格式
    //    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    
    [EAGLContext setCurrentContext:self.mContext];
    
    
    // 顶点数据，前三个是顶点坐标，后面两个是纹理坐标
    // OpenGLES的座标系是[-1, 1]，故而点(0, 0)是在屏幕的正中间。(x,y,z)
    // 纹理座标系的取值范围是[0, 1]，原点是在左下角(x,y)
//    GLfloat squareVertexData[] =
//    {
//        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
//        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
//        -0.5, -0.5, 0.0f,   0.0f, 0.0f, //左下
//        0.5, 0.5, -0.0f,    1.0f, 1.0f, //右上
//    };
    
    //顶点数据，前三个是顶点坐标，后面两个是纹理坐标，两个三角形
    // OpenGLES的座标系是[-1, 1]，故而点(0, 0)是在屏幕的正中间。(x,y,z)
    // 纹理座标系的取值范围是[0, 1]，原点是在左下角(x,y)
    GLfloat vertexData[] =
    {
        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
        0.5, 0.5, -0.0f,    1.0f, 1.0f, //右上
        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
        
        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
        -0.5, -0.5, 0.0f,   0.0f, 0.0f, //左下
    };
    
    //顶点数据缓存
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition); //顶点数据缓存
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 0);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0); //纹理
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 3);
    
    //纹理图片
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"jpg"];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@(1),GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil ];
    
    self.mEffect = [[GLKBaseEffect alloc]init];
    self.mEffect.texture2d0.enabled = GL_TRUE;
    self.mEffect.texture2d0.name = textureInfo.name;
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // 指定刷新颜色缓冲区时所用的颜色，RGBA
    glClearColor(0.3f, 0.6f, 1.0f, 1.0f);
    
    // 刷新缓存区
    // GL_COLOR_BUFFER_BIT:    当前可写的颜色缓冲
    // GL_DEPTH_BUFFER_BIT:    深度缓冲
    // GL_ACCUM_BUFFER_BIT:    累积缓冲
    // GL_STENCIL_BUFFER_BIT:  模板缓冲
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //启动着色器
    [self.mEffect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, 6);
//    glDrawElements(GL_TRIANGLES, self.mCount, GL_UNSIGNED_INT, 0);
}


@end
