//
//  BNRDrawView.h
//  TouchTracker
//
//  Created by 朱正晶 on 15/3/11.
//  Copyright (c) 2015年 China. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRLine.h"

@interface BNRDrawView : UIView
@property (nonatomic, strong) BNRLine *currentLine;
@property (nonatomic, strong) NSMutableArray *finishedLines;
@end
