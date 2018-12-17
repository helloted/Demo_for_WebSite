//
//  ViewController.m
//  DrawLineDemo
//
//  Created by iMac on 2017/12/4.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "ViewController.h"
#import "UIBezierPath+LxThroughPointsBezier.h"

@interface ViewController ()

@property (nonatomic, strong)CAShapeLayer *shapeLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建出CAShapeLayer
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = self.view.bounds;//设置shapeLayer的尺寸和位置
    _shapeLayer.position = self.view.center;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色为ClearColor
    
    //设置线条的宽度和颜色
    _shapeLayer.lineWidth = 1.0f;
    _shapeLayer.strokeColor = [UIColor redColor].CGColor;
    
//    [self addAnimation];
    
    //创建出圆形贝塞尔曲线
    UIBezierPath *circlePath = [self drawSmoothPath];
    //让贝塞尔曲线与CAShapeLayer产生联系
    _shapeLayer.path = circlePath.CGPath;
    
    //添加并显示
    [self.view.layer addSublayer:_shapeLayer];
}

- (void)addAnimation{
    //创建动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.duration = 3;//kDuration;
    [_shapeLayer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
}

- (UIBezierPath *)drawSmoothPath{
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    aPath.lineWidth = 5.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    [aPath moveToPoint:CGPointMake(20, 50)];
    [aPath addCurveToPoint:CGPointMake(200, 50) controlPoint1:CGPointMake(110, 0) controlPoint2:CGPointMake(110, 100)];
    return aPath;
}

- (UIBezierPath *)drawBezierPath{
    CGPoint point_1 = CGPointMake(100, 100);
    CGPoint point_2 = CGPointMake(120, 150);
    CGPoint point_3 = CGPointMake(200, 200);
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@(point_1),@(point_2),@(point_3), nil];
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:[[array firstObject] CGPointValue]];

    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, [array count] - 1)];
    [path addBezierThroughPoints:array];
    [array enumerateObjectsAtIndexes:indexSet
                                      options:0
                                   usingBlock:^(NSValue *pointValue, NSUInteger idx, BOOL *stop) {
                                       [path addLineToPoint:[pointValue CGPointValue]];
                                   }];
    path.usesEvenOddFillRule = YES;
    return path;
}

- (UIBezierPath *)quadCurvedPathWithPoints:(NSArray *)points
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    NSValue *value = points[0];
    CGPoint p1 = [value CGPointValue];
    [path moveToPoint:p1];
    
    if (points.count == 2) {
        value = points[1];
        CGPoint p2 = [value CGPointValue];
        [path addLineToPoint:p2];
        return path;
    }
    
    for (NSUInteger i = 1; i < points.count; i++) {
        value = points[i];
        CGPoint p2 = [value CGPointValue];
        
        CGPoint midPoint = midPointForPoints(p1, p2);
        [path addQuadCurveToPoint:midPoint controlPoint:controlPointForPoints(midPoint, p1)];
        [path addQuadCurveToPoint:p2 controlPoint:controlPointForPoints(midPoint, p2)];
        
        p1 = p2;
    }
    return path;
}

static CGPoint midPointForPoints(CGPoint p1, CGPoint p2) {
    return CGPointMake((p1.x + p2.x) / 2, (p1.y + p2.y) / 2);
}

static CGPoint controlPointForPoints(CGPoint p1, CGPoint p2) {
    CGPoint controlPoint = midPointForPoints(p1, p2);
    CGFloat diffY = abs(p2.y - controlPoint.y);
    
    if (p1.y < p2.y)
        controlPoint.y += diffY;
    else if (p1.y > p2.y)
        controlPoint.y -= diffY;
    
    return controlPoint;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
