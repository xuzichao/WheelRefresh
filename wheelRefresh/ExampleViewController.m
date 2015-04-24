//
//  ExampleViewController.m
//  wheelRefresh
//
//  Created by zichao.xu on 15/4/22.
//  Copyright (c) 2015年 CatooDev. All rights reserved.
//

#import "ExampleViewController.h"
#import "WheelRefreshControl.h"

@interface ExampleViewController()

@property (nonatomic,strong) WheelRefreshControl *headerRefreshControl;
@property (nonatomic,strong) WheelRefreshControl *footerRefreshControl;
@property (nonatomic,strong) UITableView *tableView;


@end

@implementation ExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-100);
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //说明此处必须在tableView被添加到父View中之后，才能给它增加刷新组件
    [self.view addSubview:_tableView]; //  <-----------
    _headerRefreshControl = [[WheelRefreshControl alloc] initHeaderRefreshToScrollView:_tableView];
    _footerRefreshControl = [[WheelRefreshControl alloc] initFooterRefreshToScrollView:_tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) endHeaderRefreshData {
    [_tableView reloadData];
    [_headerRefreshControl endHeaderRefreshing];
}

- (void) endFooterRefreshData {
    [_tableView reloadData];
    [_footerRefreshControl endFooterRefreshing];
}

#pragma mark tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0
                                           green:(arc4random()%255)/255.0
                                            blue:(arc4random()%255)/255.0
                                           alpha:1];
    [[cell viewWithTag:100] removeFromSuperview];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    label.text = [NSString stringWithFormat:@"%d",(arc4random()%100)];
    label.tag = 100;
    [label setTextColor:[UIColor whiteColor]];
    label.center = CGPointMake(cell.frame.size.width/2, 50);
    
    [cell.contentView addSubview:label];
    
    return cell;
}

//为了检测用户手势的时候发送网络请求，这个下拉距离的逻辑是需要你自己写的，虽然就下面这几句话
//就实现一个scrollViewDidEndDragging方法即可，60这个数字随便你设定

#pragma mark scrollDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    CGFloat offSet = scrollView.contentOffset.y;
    
    if (offSet <0) {
        if (offSet >= -60) {
            
            [_headerRefreshControl endHeaderRefreshing];
            
            
        }else if(offSet < -60){
            
            [_headerRefreshControl startHeaderRefreshing];
            
            //测试用的timer,模拟网络请求时间，正是使用的时候替换为网络请求的代码
            __unused NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(endHeaderRefreshData) userInfo:nil repeats:NO];
            
            
        }
    }
    
    else {
        
        //好吧，我承认这句话是需要你自己写上的
        offSet = offSet -(_tableView.contentSize.height - _tableView.frame.size.height);
        
        if (offSet >= 60) {
            
            [_footerRefreshControl startFooterRefreshing];
            
            //测试用的timer,模拟网络请求时间，正是使用的时候去掉
            __unused NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(endFooterRefreshData) userInfo:nil repeats:NO];
            
        }else if(offSet < 60 && offSet >0){
            
            [_footerRefreshControl endFooterRefreshing];
            
            
            
            
        }
    }
    
}


@end
