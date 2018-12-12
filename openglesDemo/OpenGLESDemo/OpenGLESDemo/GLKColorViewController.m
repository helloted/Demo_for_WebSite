//
//  GLKColorViewController.m
//  OpenGLESDemo
//
//  Created by iMac on 2018/4/9.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "GLKColorViewController.h"

@interface GLKColorViewController ()

@property(nonatomic,strong)EAGLContext *mContext;

@property(nonatomic,strong)GLKBaseEffect *mEffect;

@property(nonatomic,assign)int mCount;

@end

@implementation GLKColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //新建OpenGL ES 上下文
    GLKView *glkView = (GLKView *)self.view;
    glkView.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // 将此“EAGLContext”实例设置为OpenGL的“当前激活”的“Context”。这样，以后所有“GL”的指令均作用在这个“Context”上。
    [EAGLContext setCurrentContext:glkView.context];
    
    //    drawableColorFormat
    //    你的OpenGL上下文有一个缓冲区，它用以存储将在屏幕中显示的颜色。你可以使用其属性来设置缓冲区中每个像素的颜色格式。
    //    缺省值是GLKViewDrawableColorFormatRGBA8888，即缓冲区的每个像素的最小组成部分(-个像素有四个元素组成 RGBA)使用8个bit(如R使用8个bit)（所以每个像素4个字节 既 4*8 个bit）。这非常好，因为它给了你提供了最广泛的颜色范围，让你的app看起来更好。
    //    但是如果你的app允许更小范围的颜色，你可以设置为GLKViewDrawableColorFormatRGB565，从而使你的app消耗更少的资源（内存和处理时间）。
    glkView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    
    
    //    drawableDepthFormat
    //    你的OpenGL上下文还可以（可选地）有另一个缓冲区，称为深度缓冲区。这帮助我们确保更接近观察者的对象显示在远一些的对象的前面（意思就是离观察者近一些的对象会挡住在它后面的对象）。
    //    其缺省的工作方式是：OpenGL把接近观察者的对象的所有像素存储到深度缓冲区，当开始绘制一个像素时，它（OpenGL）首先检查深度缓冲区，看是否已经绘制了更接近观察者的什么东西，如果是则忽略它（要绘制的像素，就是说，在绘制一个像素之前，看看前面有没有挡着它的东西，如果有那就不用绘制了）。否则，把它增加到深度缓冲区和颜色缓冲区。
    //    你可以设置这个属性，以选择深度缓冲区的格式。缺省值是GLKViewDrawableDepthFormatNone，意味着完全没有深度缓冲区。
    //    但是如果你要使用这个属性（一般用于3D游戏），你应该选择GLKViewDrawableDepthFormat16或GLKViewDrawableDepthFormat24。这里的差别是使用GLKViewDrawableDepthFormat16将消耗更少的资源，但是当对象非常接近彼此时，你可能存在渲染问题。
    glkView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    // 声明顶点数据
    GLfloat vertexData[] =
    {
        0.5, -0.5, 0.0f,
        0.5, 0.5, -0.0f,
        -0.5, 0.5, 0.0f,
    };
    //顶点数据缓存
    //这几行代码表示的含义是：声明一个缓冲区的标识（GLuint类型）让OpenGL自动分配一个缓冲区并且返回这个标识的值绑定这个缓冲区到当前“Context”最后，将我们前面预先定义的顶点数据“vertexData”复制进这个缓冲区中。参数“GL_STATIC_DRAW”，它表示此缓冲区内容只能被修改一次，但可以无限次读取。
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);
    
    // 激活顶点属性（默认它的关闭的）
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    // 填充顶点数据，顶点属性索引（这里是位置）、3个分量的矢量、类型是浮点（GL_FLOAT）、填充时不需要单位化（GL_FALSE）、在数据数组中每行的跨度是12个字节（4*3=12。从预定义的数组中可看出，每行有3个GL_FLOAT浮点值，而GL_FLOAT占4个字节，因此每一行的跨度是4*3），最后一个参数是一个偏移量的指针，用来确定“第一个数据”将从内存数据块的什么地方开始。
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 3, (GLfloat *)NULL + 0);

    // 着色器
    self.mEffect = [[GLKBaseEffect alloc]init];
    // 着色器的颜色
    self.mEffect.constantColor = GLKVector4Make(0.5f, 0.2f, 1.0f, 1.0f);
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // 指定刷新整个context颜色缓冲区时所用的颜色，RGBA
    glClearColor(0.3f, 0.6f, 1.0f, 1.0f);
    
    // 刷新缓存区
    // GL_COLOR_BUFFER_BIT:    当前可写的颜色缓冲
    // GL_DEPTH_BUFFER_BIT:    深度缓冲
    // GL_ACCUM_BUFFER_BIT:    累积缓冲
    // GL_STENCIL_BUFFER_BIT:  模板缓冲
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // 启动着色器
    [self.mEffect prepareToDraw];
    // 画出三角形
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
