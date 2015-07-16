//
//  SharePlugin.m
//  SharePlugins
//
//  Created by LiGuicai on 15/7/16.
//  Copyright (c) 2015年 guicai.li.china@gmail.com. All rights reserved.
//

#import "SharePlugin.h"
#import <MBProgressHUD.h>
#import "WXApi.h"
#import <MessageUI/MessageUI.h>


@interface SharePlugin() <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@end

@implementation SharePlugin

- (void)dealloc {
    
}

- (instancetype)init {
    self = [self initWithDelegate:nil ViewController:nil];
    return self;
}

- (instancetype)initWithDelegate:(id<SharePluginDelegate>)delegate {
    self = [self initWithDelegate:delegate ViewController:nil];
    return self;
}

- (instancetype)initWithDelegate:(id<SharePluginDelegate>)delegate ViewController:(UIViewController *)viewController {
    self = [super init];
    if(self) {
        self.shareTitle = @"SharePlugin";
        self.onViewController = viewController;
        self.delegate = delegate;
    }
    return self;
}

- (void)showShareView:(UIViewController *)viewController {
    
    //TODO:分享Custome View
//    [self.shareView showInView:viewController.view];
    self.onViewController = viewController;
}

- (void)clickedButtonAtIndex:(NSUInteger)index {
    
    switch (index) {
        case 0:
            // 复制链接
            [self copyUrl];
            break;
        case 1:
            // 邮件
            [self shareByEmail];
            break;
        case 2:
            // 短信
            [self shareByMessage];
            break;
        case 3:
            // 微信好友
            [self weChartShareWithScene:WXSceneSession];
            break;
        case 4:
            // 微信朋友圈
            [self weChartShareWithScene:WXSceneTimeline];
            break;
        case 5:
            
            break;
        case 6:
            
            break;
            
        default:
            break;
    }
}

#pragma mark - 复制链接

- (void)copyUrl {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    [pasteboard setString:[self.delegate shareURL]];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.onViewController.view animated:YES];
    [hud setMode:MBProgressHUDModeCustomView];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fav-ok"]];
    hud.labelText = @"网址已复制";
    [hud hide:YES afterDelay:1.0f];
}

#pragma mark - 邮件

- (void)shareByEmail {
    if ([MFMailComposeViewController canSendMail]) {
        [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
        [mailComposeViewController setSubject:[self.delegate getEmailTitle]];
        mailComposeViewController.mailComposeDelegate = self;
        
        NSString *bodyString = [self.delegate generateEmailBody];
        
        [mailComposeViewController setMessageBody:bodyString isHTML:YES];
        mailComposeViewController.navigationBar.tintColor = [UIColor whiteColor];
        
        [self.onViewController presentViewController:mailComposeViewController animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 短信

- (void)shareByMessage {
    if ([MFMessageComposeViewController canSendText]) {
        [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
        messageComposeViewController.body = [self.delegate generateShareContentText];
        messageComposeViewController.messageComposeDelegate = self;
        
        messageComposeViewController.navigationBar.tintColor = [UIColor whiteColor];
    
        [self.onViewController presentViewController:messageComposeViewController animated:YES completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WeChat

- (void)weChartShareWithScene:(int)scene {
    if ([WXApi isWXAppInstalled]) {
        WXMediaMessage *mediaMessage = [[WXMediaMessage alloc] init];
        if (scene == WXSceneSession) {
            mediaMessage.title = self.shareTitle;
            mediaMessage.description = [self.delegate generateShareContentText];
        } else {
            mediaMessage.title = [self.delegate generateShareContentText];
        }
        
        UIImage *sharedImage = [self.delegate imageToBeSharedInWeChart];
        
        [mediaMessage setThumbImage:sharedImage];
        
        WXWebpageObject *webPageObject = [[WXWebpageObject alloc] init];
        webPageObject.webpageUrl = [self.delegate shareURL];
        
        mediaMessage.mediaObject = webPageObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = mediaMessage;
        req.scene = scene;
        
        [WXApi sendReq:req];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"你还没有安装微信是否安装?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

@end
