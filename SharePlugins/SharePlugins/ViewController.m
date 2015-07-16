//
//  ViewController.m
//  SharePlugins
//
//  Created by LiGuicai on 15/7/8.
//  Copyright (c) 2015年 guicai.li.china@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import "SharePlugin.h"

@interface ViewController ()<SharePluginDelegate>

@property (nonatomic, strong) SharePlugin *sharePlugin;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)shareBtnClicked:(id)sender {
    [self.sharePlugin clickedButtonAtIndex:4];
}

- (SharePlugin *)sharePlugin {
    if (_sharePlugin == nil) {
        _sharePlugin = [[SharePlugin alloc] initWithDelegate:self ViewController:self];
    }
    return _sharePlugin;
}

#pragma mark - SharePluginDelegate

- (NSString *)getEmailTitle {
    return @"邮件测试";
}

- (NSString *)generateEmailBody {
    return @"邮件内容为：下午好！";
}

- (NSString *)generateShareContentText {
    return @"分享内容为：下午好！";
}

- (NSString *)shareURL {
    return @"https://github.com/Guicai-Li/SharePlugins";
}

- (UIImage *)imageToBeSharedInWeibo {
    return [UIImage imageNamed:@"app_icon"];
}

- (UIImage *)imageToBeSharedInWeChart {
    return [UIImage imageNamed:@"app_icon"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
