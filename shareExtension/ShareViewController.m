//
//  ShareViewController.m
//  shareExtension
//
//  Created by mac on 2019/1/25.
//  Copyright © 2019 kunnan. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController



/**
 是用来判断内容是否可用的,这里可以做一些校验，比如我们分享的内容是否符合要分享的要求，如果返回false，那么在上图的Post按钮就无法点击了。因为一旦返回false，则说明分享内容不符合要求，也就无法Post了

 @return <#return value description#>
 */
- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

/**
 didSelectPost是你点击发送之后处理的事件，比如微信的点击收藏，可以调用微信的api，然后进行收藏。
 1、使用App Group的方式进行app Extension和containing app进行交互。先将内容存储到UserDefaults，然后再在containing app里面取出图片展示到containing app里面。
 */
- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

/**
 configuration是一个配置数组，它可以配置多个列表，例如微信分享的[发送给朋友，分享到朋友圈，收藏]：

 @return <#return value description#>
 */
- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    
    //SLComposeSheetConfigurationItem
    
    SLComposeSheetConfigurationItem *friendConfig = [[SLComposeSheetConfigurationItem alloc] init];
    friendConfig.title = @"发送给朋友";
    friendConfig.value = @"请选择";
    [friendConfig setTapHandler:^{
        NSLog(@"setTapHandler");
    }];
    
    
    return @[friendConfig];
}

@end
