//
//  AppDelegate.m
//  KNTodayExtensionDemo
//
//  Created by mac on 2019/1/24.
//  Copyright © 2019 kunnan. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    [self.window makeKeyAndVisible];
    [self setupshortcutItems];
    return YES;
}


#pragma mark - ******** 用代码创建应用图标上的3D touch快捷选项
/** 用代码创建应用图标上的3D touch快捷选项  */
- (void)setupshortcutItems{
    
    UIApplicationShortcutIcon *shareShortcutIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
    UIApplicationShortcutItem *shareShortcutItem = [[UIApplicationShortcutItem alloc] initWithType:@"share" localizedTitle:@"share" localizedSubtitle:@"share app" icon:shareShortcutIcon userInfo:nil];

    
    //系统图标
    UIApplicationShortcutIcon *searchShortcutIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
    UIApplicationShortcutItem *searchShortcutItem = [[UIApplicationShortcutItem alloc] initWithType:@"search" localizedTitle:@"搜索" localizedSubtitle:@"搜索副标题" icon:searchShortcutIcon userInfo:nil];
    // 自定义图标
    UIApplicationShortcutIcon *attentionShortcutIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"attention"];
    UIApplicationShortcutItem *attentionShortcutItem = [[UIApplicationShortcutItem alloc] initWithType:@"attention" localizedTitle:@"关注" localizedSubtitle:@"关注副标题" icon:attentionShortcutIcon userInfo:nil];
    // 系统低于9.0是没有这个属性的
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(shortcutItems)]) {
        [UIApplication sharedApplication].shortcutItems = @[searchShortcutItem, attentionShortcutItem,shareShortcutItem];
    }
    
}

/** 3D touch快捷选项触发事件 */
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
//    XMTabBarController *tabVC = (XMTabBarController *)self.window.rootViewController;
    //search
    if([shortcutItem.type isEqualToString:@"share"]){

//    if([shortcutItem.type isEqualToString:@"one"]){
        // 这个分享的3D touch快捷选项是从plist里面创建的
        NSArray *arr = @[@"Hello 3D Touch--分享"];// 分析的内容
        UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:arr applicationActivities:nil];
        [self.window.rootViewController presentViewController:vc animated:YES completion:^{
        }];
    } else if ([shortcutItem.type isEqualToString:@"save"]) {//进入珍藏界面
//        [tabVC callSave];
    }else if ([shortcutItem.type isEqualToString:@"search"]) {//进入搜索界面
//        [tabVC callSearch];
    }
    else if ([shortcutItem.type isEqualToString:@"scan"]) {//进入扫描二维码界面
//        [tabVC callScanQRCode];
    }
    else if ([shortcutItem.type isEqualToString:@"toolbox"]) {//进入工具箱
//        [tabVC callToolbox];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#warning todo
/**
 1、先判断界面顶部的当前控制器的类型，如果是登陆界面，就等登陆成功之后进行对应跳转
 2、如果顶部控制器的类型就是即将跳转的界面，就不做任何动作

 @param app <#app description#>
 @param url <#url description#>
 @param options <#options description#>
 @return <#return value description#>
 */
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    // 可以先回到应用首页，在跳转
    if ([url.absoluteString hasPrefix:@"knTodayExtensionDemo"]) {
        if ([url.host isEqualToString:@"enterApp"]) {
            //进入APP
        }else if ([url.host isEqualToString:@"feedback"]) {
            //进入反馈
            [self jumpSubVCWithNameTitle:@"反馈"];
        }else if ([url.host isEqualToString:@"userInfo"]) {
            //进入个人用户信息
            [self jumpSubVCWithNameTitle:@"个人信息"];
        }else if ([url.host isEqualToString:@"customerService"]) {
            //进入客服
            [self jumpSubVCWithNameTitle:@"客服"];
        }else if ([url.host isEqualToString:@"set"]) {
            //打印参数
            NSLog(@"%@",url.relativePath);
            //进入设置
            [self jumpSubVCWithNameTitle:@"设置"];
        }else if ([url.host isEqualToString:@"help"]) {
            //进入帮助
            [self jumpSubVCWithNameTitle:@"帮助"];
        }
    }
    return YES;
}


-(void)jumpSubVCWithNameTitle:(NSString *)nameTitle{
    UIViewController * subVC = [UIViewController new];
    subVC.title = nameTitle;
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController * nav = (UINavigationController *)self.window.rootViewController;
        [nav pushViewController:subVC animated:NO];
    }else if ([self.window.rootViewController isKindOfClass:[ViewController class]]){
        [self.window.rootViewController.navigationController pushViewController:subVC animated:NO];
    }
}


@end
