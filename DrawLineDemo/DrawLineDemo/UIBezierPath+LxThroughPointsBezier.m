//
//  UIBezierPath+LxThroughPointsBezier.m
//  LxThroughPointsBezierDemo
//

#import "UIBezierPath+LxThroughPointsBezier.h"
#import <objc/runtime.h>

@implementation UIBezierPath (LxThroughPointsBezier)

- (void)setContractionFactor:(CGFloat)contractionFactor
{
    objc_setAssociatedObject(self, @selector(contractionFactor), @(contractionFactor), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)contractionFactor
{
    id contractionFactorAssociatedObject = objc_getAssociatedObject(self, @selector(contractionFactor));
    if (contractionFactorAssociatedObject == nil) {
        return 0.7;
    }
    return [contractionFactorAssociatedObject floatValue];
}

- (void)addBezierThroughPoints:(NSArray *)pointArray
{
    NSAssert(pointArray.count > 0, @"You must give at least 1 point for drawing the curve.");
    
    
    CGPoint previousPoint = CGPointZero;
    
    CGPoint previousCenterPoint = CGPointZero;
    CGPoint centerPoint = CGPointZero;
    CGFloat centerPointDistance = 0;
    
    CGFloat obliqueAngle = 0;
    
    CGPoint previousControlPoint1 = CGPointZero;
    CGPoint previousControlPoint2 = CGPointZero;
    CGPoint controlPoint1 = CGPointZero;

    previousPoint = self.currentPoint;
    
    for (int i = 0; i < pointArray.count; i++) {
        
        NSValue * pointIValue = pointArray[i];
        CGPoint pointI = [pointIValue CGPointValue];
        
        if (i > 0) {

            // 上一段线的中点
            previousCenterPoint = CenterPointOf(self.currentPoint, previousPoint);
            
            // 现在要画的连线的中点位置
            centerPoint = CenterPointOf(previousPoint, pointI);
            
            // 两个中点的距离
            centerPointDistance = DistanceBetweenPoint(previousCenterPoint, centerPoint);
            
            // 两个中点的角度
            obliqueAngle = ObliqueAngleOfStraightThrough(centerPoint, previousCenterPoint);
            
            previousControlPoint2 = CGPointMake(previousPoint.x - 0.5 * self.contractionFactor * centerPointDistance * cos(obliqueAngle), previousPoint.y - 0.5 * self.contractionFactor * centerPointDistance * sin(obliqueAngle));
            controlPoint1 = CGPointMake(previousPoint.x + 0.5 * self.contractionFactor * centerPointDistance * cos(obliqueAngle), previousPoint.y + 0.5 * self.contractionFactor * centerPointDistance * sin(obliqueAngle));
        }
        
        if (i == 1) {
            
            [self addQuadCurveToPoint:previousPoint controlPoint:previousControlPoint2];
        }
        else if (i > 1 && i < pointArray.count - 1) {
        
            [self addCurveToPoint:previousPoint controlPoint1:previousControlPoint1 controlPoint2:previousControlPoint2];
        }
        else if (i == pointArray.count - 1) {
        
            [self addCurveToPoint:previousPoint controlPoint1:previousControlPoint1 controlPoint2:previousControlPoint2];
            [self addQuadCurveToPoint:pointI controlPoint:controlPoint1];
        }
        else {
        
        }
        
        previousControlPoint1 = controlPoint1;
        previousPoint = pointI;
    }
    
}

CGFloat ObliqueAngleOfStraightThrough(CGPoint point1, CGPoint point2)   //  [-π/2, 3π/2)
{
    CGFloat obliqueRatio = 0;
    CGFloat obliqueAngle = 0;
    
    if (point1.x > point2.x) {
    
        obliqueRatio = (point2.y - point1.y) / (point2.x - point1.x);
        obliqueAngle = atan(obliqueRatio);
    }
    else if (point1.x < point2.x) {
    
        obliqueRatio = (point2.y - point1.y) / (point2.x - point1.x);
        obliqueAngle = M_PI + atan(obliqueRatio);
    }
    else if (point2.y - point1.y >= 0) {
    
        obliqueAngle = M_PI/2;
    }
    else {
        obliqueAngle = -M_PI/2;
    }
    
    return obliqueAngle;
}


CGFloat DistanceBetweenPoint(CGPoint point1, CGPoint point2)
{
    return sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));
}

CGPoint CenterPointOf(CGPoint point1, CGPoint point2)
{
    return CGPointMake((point1.x + point2.x) / 2, (point1.y + point2.y) / 2);
}

@end
