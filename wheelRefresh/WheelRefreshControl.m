//
//  WheelRefreshControl.m
//  wheelRefresh
//
//  Created by zichao.xu on 15/4/22.
//  Copyright (c) 2015年 CatooDev. All rights reserved.
//

#import "WheelRefreshControl.h"
#import "WheelIndicatorView.h"

//提示文字
#define pullDownRefreshText    @"下拉刷新"
#define pullUpRefreshText      @"上拉刷新"
#define loosenRefreshText      @"松开刷新"
#define loadingText            @"正在加载"

//圆圈和文字的颜色
#define circleColor        [UIColor grayColor]
#define fontColor          [UIColor grayColor]

//宽高参数
static const CGFloat   controlHeight     = 40.0;  //组件的高度
static const CGFloat   marginDistance    = 2.0;   //圆圈与文字之间的间距
static const CGFloat   fontSize          = 12.0;  //文字大小

@interface WheelRefreshControl()

@property (nonatomic,strong) WheelIndicatorView *wheelIndicatorView;
@property (nonatomic,strong) UIImageView *indicatorImageView;
@property (nonatomic,strong) UILabel *hintTextLabel;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *wrapper ;
@property (nonatomic)        BOOL  canObserve;

@end

@implementation WheelRefreshControl

- (instancetype)initHeaderRefreshToScrollView:(UIScrollView *)scrollView {
    
    self = [super initWithFrame:CGRectMake(scrollView.frame.origin.x,
                                           scrollView.frame.origin.y,
                                           scrollView.frame.size.width,
                                           controlHeight)];
    if (self) {
        
    _canObserve = YES;
    //代理关系
    _scrollView = scrollView;
    _scrollView.backgroundColor = [UIColor clearColor];

    //文字提示
    _hintTextLabel = [[UILabel alloc] init];
    CGFloat textWidth = [self setHintTextLabelText:pullDownRefreshText];
    
    //旋转的UIView和图片
    _wheelIndicatorView = [[WheelIndicatorView alloc] initWithColor:circleColor withParentHeight:controlHeight];
    _indicatorImageView = [[UIImageView alloc] initWithFrame:_wheelIndicatorView.frame];
    
    //容器居中显示
    CGFloat wrapperWidth = _indicatorImageView.frame.size.width+textWidth+marginDistance;
    CGFloat wrapperHeight = MAX(_indicatorImageView.frame.size.height, fontSize);
    _wrapper= [[UIView alloc] initWithFrame:CGRectMake(0, 0, wrapperWidth,wrapperHeight)];
    _wrapper.backgroundColor = [UIColor clearColor];
    _wrapper.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [_wrapper addSubview:_indicatorImageView];
    [_wrapper addSubview:_hintTextLabel];
    [_wrapper addSubview:_wheelIndicatorView];
    [self addSubview:_wrapper];
    
    //增加到目标视图
    [scrollView.superview addSubview:self];
    [scrollView.superview bringSubviewToFront:scrollView];
        
        
    //增加观察器
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    }
    return self;
}

- (instancetype)initFooterRefreshToScrollView:(UIScrollView *)scrollView {
    
    self = [self initHeaderRefreshToScrollView:scrollView];
    
    self.frame = CGRectMake(scrollView.frame.origin.x,
                                           scrollView.frame.origin.y+scrollView.frame.size.height-controlHeight,
                                           scrollView.frame.size.width,
                                           controlHeight);
   
    return self;
}

//文字提示
- (CGFloat)setHintTextLabelText:(NSString *)string{
    CGFloat textWidth=[string boundingRectWithSize:CGSizeMake(MAXFLOAT, fontSize)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                                           context:nil].size.width;
    
    [_hintTextLabel setText:string];
    [_hintTextLabel setFont:[UIFont systemFontOfSize:fontSize]];
    [_hintTextLabel setFrame:CGRectMake(_indicatorImageView.frame.size.width+marginDistance, 0, textWidth, MAX(_indicatorImageView.frame.size.height, fontSize))];
    [_hintTextLabel setTextColor:fontColor];
    [_hintTextLabel setTextAlignment:NSTextAlignmentCenter];
    
    return textWidth;
}

- (void)startHeaderRefreshing {
    
    _canObserve = NO;
    _wrapper.hidden = NO;
    
    //赋值
    [_indicatorImageView setImage:_wheelIndicatorView.pathImage];
    [_scrollView setContentInset:UIEdgeInsetsMake(controlHeight, 0.f, 0.f, 0.f)];
    [self setHintTextLabelText:loadingText];
    
    //旋转
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = 1;
    rotationAnimation.repeatCount = 1000;
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [_indicatorImageView.layer addAnimation:rotationAnimation forKey:@"Rotation"];
    
}

- (void)endHeaderRefreshing {
    
    [self setHintTextLabelText:pullDownRefreshText];
    [_indicatorImageView.layer removeAllAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [_scrollView setContentInset:UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f)];
    [UIView commitAnimations];
    
    _canObserve = YES;
    _wrapper.hidden = YES;
}


- (void)startFooterRefreshing {
    
    [self startHeaderRefreshing];
    [_scrollView setContentInset:UIEdgeInsetsMake(-controlHeight-(_scrollView.contentSize.height-_scrollView.frame.size.height) , 0.f, 0.f, 0.f)];
    
}

- (void)endFooterRefreshing {
    
    [self endHeaderRefreshing];
}

#pragma mark observerr

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (_canObserve) {
    
        
        CGFloat offSet = [[change objectForKey:@"new"] CGPointValue].y;
        
        //向下拉
        if (offSet < 0) {

            if (offSet >= -controlHeight && offSet <0) {
                _wrapper.hidden = NO;
                [self setHintTextLabelText:pullDownRefreshText];
                
            } else if(offSet < -controlHeight){
                
                [self setHintTextLabelText:loosenRefreshText];
                
            }
            
        }
        //向上拉
        else {
            
            offSet = offSet -(_scrollView.contentSize.height - _scrollView.frame.size.height);
            
            if (offSet >= controlHeight) {
                _wrapper.hidden = NO;
                [self setHintTextLabelText:loosenRefreshText];
                
            }else if(offSet < controlHeight && offSet >0){
                
                [self setHintTextLabelText:pullUpRefreshText];
            }
        }
        
        
        //根据offset重绘圆圈
        _wheelIndicatorView.mathParam = fabs(offSet) ;
        [_wheelIndicatorView setNeedsDisplay];
        [_indicatorImageView setImage:_wheelIndicatorView.pathImage];
        
    }
}

@end
