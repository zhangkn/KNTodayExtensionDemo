//
//  ViewController.m
//  KNTodayExtensionDemo
//
//  Created by mac on 2019/1/24.
//  Copyright © 2019 kunnan. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"kn首页";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    // 2、测试扩展和宿主app的数据共享
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"切换共享数据" style:UIBarButtonItemStylePlain target:self action:@selector(clickSwitchTitleEvent)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
//切换通知栏标题
-(void)clickSwitchTitleEvent{
    NSArray * arr = @[@"生活有度，人生添寿。 —— 书摘",@"理想是人生的太阳。 —— 德莱赛",@"不是老人变坏了，而是坏人变老了",@"人生苦短，必须性感"];
    NSInteger index = arc4random_uniform(arr.count);
    // 存储数据
    self.title = arr[index];
    //kunnan.KNTodayExtensionDemo1.TodayExtensionDemo
    [[[NSUserDefaults alloc] initWithSuiteName:@"group.kunnan.KNTodayExtensionDemo1.TodayExtensionDemo"] setValue:self.title forKey:@"myShareData"];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        NSArray * array = @[
                            @{@"icon":@"bangzhu",@"handerUrl":@"knTodayExtensionDemo://help",@"title":@"帮助"},
                            @{@"icon":@"fankui",@"handerUrl":@"knTodayExtensionDemo://feedback",@"title":@"反馈"},
                            @{@"icon":@"gerenxinxi",@"handerUrl":@"knTodayExtensionDemo://userInfo",@"title":@"个人信息"},
                            @{@"icon":@"kefu",@"handerUrl":@"knTodayExtensionDemo://customerService",@"title":@"客服"},
                            @{@"icon":@"shezhi",@"handerUrl":@"knTodayExtensionDemo://set",@"title":@"设置"},
                            ];
        _dataArray = [NSMutableArray arrayWithCapacity:array.count];
        for (NSDictionary * dic in  array) {
            KNTodayItemModel * model = [[KNTodayItemModel alloc] initWithDictionary:dic error:nil];
            if (model) {
                [_dataArray addObject:model];
            }
        }
    }
    return _dataArray;
}



#pragma mark- UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    KNTodayItemModel * model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KNTodayItemModel * model = self.dataArray[indexPath.row];

//    []
    [[UIApplication sharedApplication]  openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"",model.handerUrl ? model.handerUrl :@"knTodayExtensionDemo://enterApp"]]];

//    [self.extensionContext openURL:[NSURL URLWithString:@"knTodayExtensionDemo://enterApp"] completionHandler:nil];

//
//    CYSubViewController * subVC = [CYSubViewController new];
//    subVC.title = model.title;
//    [self.navigationController pushViewController:subVC animated:YES];
}
@end

