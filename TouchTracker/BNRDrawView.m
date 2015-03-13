//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by 朱正晶 on 15/3/11.
//  Copyright (c) 2015年 China. All rights reserved.
//

#import "BNRDrawView.h"

@interface BNRDrawView()
@property (nonatomic, strong) NSMutableDictionary *pointsInProgress;
@property (nonatomic, strong) NSMutableDictionary *pointsFinished;
@property (nonatomic, strong) NSValue *firstPointKey;
@property (nonatomic, strong) NSValue *secondPointKey;
@end

@implementation BNRDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pointsFinished = [NSMutableDictionary dictionary];
        self.pointsInProgress = [NSMutableDictionary dictionary];
        self.backgroundColor = [UIColor whiteColor];
        self.multipleTouchEnabled = YES;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // 正在绘图中，颜色为绿色
    if (self.pointsInProgress.count >= 2) {
        [[UIColor greenColor] set];
        
        [self circleDrawWithFirstPoint:self.pointsInProgress[_firstPointKey]
                           secondPoint:self.pointsInProgress[_secondPointKey]];
    }
    
    // 完成绘图，显示为红色
    if (self.pointsFinished.count >= 2) {
        [[UIColor redColor] set];
        
        [self circleDrawWithFirstPoint:self.pointsFinished[_firstPointKey]
                           secondPoint:self.pointsFinished[_secondPointKey]];
    }
    
}

- (void)circleDrawWithFirstPoint:(BNRLine *)firstPoint secondPoint:(BNRLine *)secondPoint
{
    CGFloat x, y;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    x = (firstPoint.current.x + secondPoint.current.x) / 2.0;
    y = (firstPoint.current.y + secondPoint.current.y) / 2.0;
    CGFloat currentRadius = sqrt(pow(firstPoint.current.x - secondPoint.current.x, 2) + pow(firstPoint.current.y - secondPoint.current.y, 2)) / 2.0;
    [path moveToPoint:CGPointMake(x + currentRadius, y)];
    [path addArcWithCenter:CGPointMake(x, y)
                    radius:currentRadius
                startAngle:0.0
                  endAngle:M_PI * 2.0
                 clockwise:YES];
    
    path.lineWidth = 10.0;
    [path stroke];
}

// 手指触摸屏幕时触发，只触发一次
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    int i = 0;
    NSLog(@"%@", NSStringFromSelector(_cmd));
    // 清除所有已显示的圆
    [self.pointsFinished removeAllObjects];
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        BNRLine *line = [[BNRLine alloc] init];
        line.current = location;
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        if (i == 0) {
            _firstPointKey = key;
        } else if (i == 1) {
            _secondPointKey = key;
        }
        self.pointsInProgress[key] = line;
        i++;
    }
    
    [self setNeedsDisplay];
}

// 手指在屏幕上移动时，一直触发
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.pointsInProgress[key];
        line.current = [t locationInView:self];
    }
    [self setNeedsDisplay];
}

// 手指离开屏幕触发
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        
        BNRLine *line = self.pointsInProgress[key];
        self.pointsFinished[key] = line;
        [self.pointsInProgress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}

// 触摸事件被取消，比如在画线的过程中有电话进来，那么就会收到touchesCancelled事件
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.pointsInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}

@end
