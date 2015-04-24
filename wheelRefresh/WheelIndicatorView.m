//
//  WheelIndicatorView.m
//  wheelRefresh
//
//  Created by zichao.xu on 15/4/23.
//  Copyright (c) 2015年 CatooDev. All rights reserved.
//

#import "WheelIndicatorView.h"

//设计圆的静态参数
static const CGFloat lineWidth       = 1.f;
static const CGFloat height          = 15.f;
static const CGFloat width           = 15.f;
static const CGFloat leftStartAngle  = (110.0/360)*2*M_PI;
static const CGFloat rightStartAngle = (110.0/360+180.0/360)*2*M_PI;
static const CGFloat maxAngle        = (140.0/360)*2*M_PI;

@interface WheelIndicatorView ()

@property (nonatomic,strong) UIColor *pathColor;
@property (nonatomic)        CGFloat parentHeight;

@end

@implementation WheelIndicatorView



- (instancetype)initWithColor:(UIColor *)color withParentHeight:(CGFloat)parentHeight {
    
    self = [super init];
    
    if (self) {
        self.frame = CGRectMake(0, 0, height, width);
        self.backgroundColor = [UIColor clearColor];
        _pathColor = color;
        _parentHeight = parentHeight;
        
        //初始化生成一张默认图片
        _mathParam = parentHeight;
        [self drawRect:CGRectZero];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    //计算动态角度
    CGFloat angle = [self calculateAngleFromParentHeight];
    
    //启动绘画
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
    
    //设置线条颜色
    [_pathColor set];
    
    //左边圆弧
    UIBezierPath* leftPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2, height/2)
                                                              radius:width/3
                                                          startAngle:leftStartAngle
                                                            endAngle:leftStartAngle + angle
                                                           clockwise:YES];
    leftPath.lineWidth = lineWidth;
    leftPath.lineCapStyle = kCGLineCapRound;
    [leftPath stroke];
    
    
    //右边圆弧
    UIBezierPath* rightPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2, height/2)
                                                            radius:width/3
                                                        startAngle:rightStartAngle
                                                          endAngle:rightStartAngle + angle
                                                         clockwise:YES];
    rightPath.lineWidth = lineWidth;
    rightPath.lineCapStyle = kCGLineCapRound;
    [rightPath stroke];
    
    //收工生成图像
    _pathImage = UIGraphicsGetImageFromCurrentImageContext();
    
}

- (CGFloat)calculateAngleFromParentHeight {
    
    CGFloat angle ;
    if (_mathParam > _parentHeight) {
        angle = maxAngle;

    } else {
        angle = (_mathParam/_parentHeight)*maxAngle;

    }
    return angle;
}

@end
