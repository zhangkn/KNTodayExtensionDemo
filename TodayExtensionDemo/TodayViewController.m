//
//  TodayViewController.m
//  TodayExtensionDemo
//
//  Created by mac on 2019/1/24.
//  Copyright © 2019 kunnan. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding,UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet  UITableView *tableView;

@property (nonatomic, strong) NSMutableArray * dataArray;


@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //
    //扩展Widget高度：     // 将小部件展现模型设置为可展开
    //系统默认的高度为110
    [self setupData];
//    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;//使用3DTouch唤出的弹窗依旧是110，上面代码只是改变了通知中心的高度
    //完成下面代理 widgetActiveDisplayModeDidChange：withMaximumSize

    [self setupSubviews];

}



//- (UITableView *)tableView{
//    if (nil == _tableView) {
//
//        UITableView *tmpView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];//初始化方法
//
////        UITableView *tmp =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//        _tableView = tmpView;
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.tableFooterView = [UIView new];
//        [self.view addSubview:_tableView];
//
//        // 添加约束
////        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
////
//////            make.left.right.equalTo(self.titleLabel);
//////            make.width.mas_offset([UIScreen mainScreen].bounds.size.width);
//////            make.height.mas_offset([UIScreen mainScreen].bounds.size.height);
////
////            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
////
////            make.bottom.equalTo(self.view.mas_bottom).offset(0);
////            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
////
////
////        }];
//
//
//
//
//
//    }
//    return _tableView;
//}

-(void)setupSubviews{
    
//    self.tableView = [UITableView alloc ]initWithFrame:<#(CGRect)#> style:<#(UITableViewStyle)#>;
    


    
    self.tableView.rowHeight = 60;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TodayItemCell" bundle:nil] forCellReuseIdentifier:@"TodayItemCell"];
}



-(void)setupData{
    // 将小部件展现模型设置为可展开
    if (@available(iOS 10.0, *)) {
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    } else {
        // Fallback on earlier versions
    }
}




- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize  API_AVAILABLE(ios(10.0)){
    if (@available(iOS 10.0, *)) {
        if (activeDisplayMode == NCWidgetDisplayModeExpanded) {
            // 设置展开的新高度
            self.preferredContentSize = CGSizeMake(0, 400);
        }else{
            self.preferredContentSize = maxSize;
        }
    } else {
        
    }
}

//
//- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
//    if (activeDisplayMode == NCWidgetDisplayModeExpanded) {
//        // 设置展开的新高度
//        self.preferredContentSize = CGSizeMake(0, 400);
//    }else{
//        self.preferredContentSize = maxSize;
//    }
//}

//viewWillAppear is only called once for my widget, when it is first added to the Today view. After that, viewing the widget does not call viewWillAppear. This means that when new data is available and the user views the widget, it never gets a chance to update.
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //https://forums.developer.apple.com/thread/19172
    self.titleLabel.text = @"Đang làm mới dữ liệu ...";
    [self widgetPerformUpdateWithCompletionHandler:^(NCUpdateResult result) {
    }];
    
}
//#import "NCUpdateResultNewData"
#pragma mark - ******** NCUpdateResultNewData。 目前没发现什么时候触发call
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
// 执行block，告诉界面进行数据update
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsDidChange:)  name:NSUserDefaultsDidChangeNotification object:nil]
    NSString * myData = [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.kn.appExtension"] valueForKey:@"myShareData"];
    self.titleLabel.text = myData ? myData : @"https://kunnan.github.io";
    
    completionHandler(NCUpdateResultNewData);
}

/**
 扩展与宿主App之间共享数据有两种方式：
 
 1.通过NSUserDefaults
 2.通过一个扩展与App都可以访问的共享容器，来存放文件，数据（Core Data， Sqlite等都可以存放在这个共享的容器中）

 首先，我们需要创建一个app group,如下图，选中项目的Target -> Capabilities -> App Groups，打开，如果你以前创建过group，会自动列出来。选择+号，填入group的名称（记下这个名称，因为这个是扩展和宿主之间共享数据的标志符）

 // 存储数据
 [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.KN.appExtension"] setValue:myNote forKey:@"myShareData"];
 // 取出数据
 NSArray *myData = [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.KN.appExtension"] valueForKey:@"myShareData"];
 
3、 如果需要存储更多的数据，可以通过文件或者数据库（Core Data， Sqlite等）。这个时候共享数据的方法就是要创建一个共享的文件夹
 NSURL *groupURL = [[NSFileManager defaultManager]  containerURLForSecurityApplicationGroupIdentifier: @"group.com.KN.appExtension"];


 @param touches <#touches description#>
 @param event <#event description#>
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //点击跳转到APP：因为扩展不是一个完整的程序，所以它并没没有[UIApplication sharedApplication] 这个对象
    //Apple给每个UIViewController加了一个extensionContext属性，在我们的宿主App中，这个属性是nil，而在扩展中，我们就可以通过extensionContext来执行跳转.
    //1、我们在AppDelegate：openURL：options：里处理消息
    [self.extensionContext openURL:[NSURL URLWithString:@"knTodayExtensionDemo://enterApp"] completionHandler:nil];
}

//@end

#pragma mark- UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TodayItemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TodayItemCell"];
    KNTodayItemModel * model = self.dataArray[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:model.icon];
    cell.titleLabel.text = model.title;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KNTodayItemModel * model = self.dataArray[indexPath.row];
    //点击跳转到APP
    [self.extensionContext openURL:[NSURL URLWithString:model.handerUrl] completionHandler:nil];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        NSString *urlString = [NSString stringWithFormat:@"knTodayExtensionDemo://set/markCode=%@&code=%@&yesclose=%@&stockName=%@",@"10200",@"200",@"YES",[@"阳" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        NSArray * array = @[
                            @{@"icon":@"bangzhu",@"handerUrl":@"TodayExtensionDemo://help",@"title":@"帮助"},
                            @{@"icon":@"fankui",@"handerUrl":@"TodayExtensionDemo://feedback",@"title":@"反馈"},
                            @{@"icon":@"gerenxinxi",@"handerUrl":@"TodayExtensionDemo://userInfo",@"title":@"个人信息"},
                            @{@"icon":@"kefu",@"handerUrl":@"TodayExtensionDemo://customerService",@"title":@"客服"},
                            @{@"icon":@"shezhi",@"handerUrl":urlString,@"title":@"设置"},
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
@end
