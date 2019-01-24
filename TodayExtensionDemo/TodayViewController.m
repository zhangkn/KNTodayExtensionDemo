//
//  TodayViewController.m
//  TodayExtensionDemo
//
//  Created by mac on 2019/1/24.
//  Copyright © 2019 kunnan. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //
    //扩展Widget高度：     // 将小部件展现模型设置为可展开
    //系统默认的高度为110
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;//使用3DTouch唤出的弹窗依旧是110，上面代码只是改变了通知中心的高度
    //完成下面代理 widgetActiveDisplayModeDidChange：withMaximumSize

    
}


- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeExpanded) {
        // 设置展开的新高度
        self.preferredContentSize = CGSizeMake(0, 400);
    }else{
        self.preferredContentSize = maxSize;
    }
}


- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

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

@end
