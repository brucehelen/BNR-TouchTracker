//
//  BNRDrawViewController.m
//  TouchTracker
//
//  Created by 朱正晶 on 15/3/11.
//  Copyright (c) 2015年 China. All rights reserved.
//

#import "BNRDrawViewController.h"
#import "BNRDrawView.h"

@implementation BNRDrawViewController

- (void)loadView
{
    self.view = [[BNRDrawView alloc] initWithFrame:CGRectZero];
}

@end
