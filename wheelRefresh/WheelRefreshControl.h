//
//  WheelRefreshControl.h
//  wheelRefresh
//
//  Created by zichao.xu on 15/4/22.
//  Copyright (c) 2015年 CatooDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WheelRefreshControl : UIControl

//绑定到目标视图上
- (instancetype)initHeaderRefreshToScrollView:(UIScrollView *)scrollView;
- (instancetype)initFooterRefreshToScrollView:(UIScrollView *)scrollView;

//开始刷新
- (void)startHeaderRefreshing;
- (void)startFooterRefreshing;

//结束刷新
- (void)endHeaderRefreshing;
- (void)endFooterRefreshing;
@end
