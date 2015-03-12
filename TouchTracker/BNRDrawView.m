//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by 朱正晶 on 15/3/11.
//  Copyright (c) 2015年 China. All rights reserved.
//

#import "BNRDrawView.h"

@interface BNRDrawView()
@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;
@end

@implementation BNRDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.linesInProgress = [NSMutableDictionary dictionary];
        self.finishedLines = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
    }
    
    return self;
}

- (void)strokeLine:(BNRLine *)line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat x;
    NSUInteger k;
    //[[UIColor blackColor] set];
    for (BNRLine *line in self.finishedLines) {
        NSLog(@"begin = (%f, %f), end = (%f, %f)", line.begin.x, line.begin.y, line.end.x, line.end.y);
        if (line.end.x == line.begin.x) {
            x = 100;
        } else {
            x = (line.end.y - line.begin.y) / (line.end.x - line.begin.x);
        }
        x *= 100;
        k = x;
        k = k % 255;
        NSLog(@"k = %d", k);
        CGFloat color[] = {0, k / 255.0, 0, 1.0f};
        CGColorRef colorRef = CGColorCreate(CGColorSpaceCreateDeviceRGB(), color);
        [[UIColor colorWithCGColor:colorRef] set];
        NSLog(@"x = %f", x);
        [self strokeLine:line];
    }
    
    [[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }
}

// 手指触摸屏幕时触发，只触发一次
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.finishedLines removeAllObjects];
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        BNRLine *line = [[BNRLine alloc] init];
        line.begin = location;
        line.end = location;
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key] = line;
    }
    
    [self setNeedsDisplay];
}

// 手指在屏幕上移动时，一直触发
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.linesInProgress[key];
        line.end = [t locationInView:self];
    }
    [self setNeedsDisplay];
}

// 手指离开屏幕触发
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        
        BNRLine *line = self.linesInProgress[key];
        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}

// 触摸事件被取消，比如在画线的过程中有电话进来，那么就会收到touchesCancelled事件
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}

@end
