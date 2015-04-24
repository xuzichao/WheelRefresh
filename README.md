# WheelRefresh----上拉和下拉刷新

**介绍**：
    下拉和上拉刷新是常见的IOS界面开发功能，目前圈内比较火的组件是MJRefresh，在github上有超过1000的Star,
我也下载并阅读了他的代码，易用性高、下拉形式较多，并且开发者本人还在不断的改进和更新，很赞。目前github上
也存在很多下拉刷新的组件，开发者们的热情很浓厚。
    我个人处于学习的目的，准备自己开始造轮子，通过不断的创造来学习，从而增强自己的知识和能力。喜欢的朋友
可以下载拿去使用，请注明出处。代码写得有繁有简，注重用户体验和易用性，如果遇见使用上的Bug,或者想要给我提
提学习建议的，可以上微博“@他们都叫我草莓”，我会倾听指正。



**使用说明**：

    - 使用条件：
    
    1、被增加组件的scrollView类型对象，必须在组件被创建之前，被添加到一个父元素View中。
    2、scrollView类型对象，实现代理协议UIScrollViewDelegate的方法，判定下滑距离，从而启动刷新或停止刷新。
    
    - 创建步骤：
    
    1、引用文件：WheelRefreshControl.h 、WheelRefreshControl.m、WheelIndicatorView.h、WheelIndicatorView.m
    2、创建下拉组件：WheelRefreshControl *HeaderRefresh = [[WheelRefreshControl alloc] initHeaderRefreshToScrollView:YourTableView];
           下拉刷新：[ HeaderRefresh startHeaderRefreshing ];
           停止刷新：[ HeaderRefresh endHeaderRefreshing ];
    3、创建下拉组件：WheelRefreshControl *FooterRefresh = [[WheelRefreshControl alloc] initFooterRefreshToScrollView:YourTableView];
           下拉刷新：[ FooterRefresh startFooterRefreshing ];
           停止刷新：[ FooterRefresh endFooterRefreshing ];


**个人**

    博客：xuzichao.com
    微博：@他们都叫我草莓
    
    
    