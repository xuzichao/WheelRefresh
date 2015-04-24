//
//  WheelIndicatorView.h
//  wheelRefresh
//
//  Created by zichao.xu on 15/4/23.
//  Copyright (c) 2015年 CatooDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WheelIndicatorView : UIView

@property (nonatomic)        CGFloat mathParam;
@property (nonatomic,strong) UIImage *pathImage;

- (instancetype)initWithColor:(UIColor *)color withParentHeight:(CGFloat)parentHeight;

@end
