//
//  SharePlugin.h
//  SharePlugins
//
//  Created by LiGuicai on 15/7/16.
//  Copyright (c) 2015年 guicai.li.china@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol SharePluginDelegate <NSObject>

- (NSString *)getEmailTitle;

- (NSString *)generateEmailBody;

- (NSString *)generateShareContentText;

- (NSString *)shareURL;

- (UIImage *)imageToBeSharedInWeibo;

- (UIImage *)imageToBeSharedInWeChart;

@end

@interface SharePlugin : NSObject

@property (nonatomic, strong)   UIViewController *onViewController;

@property (nonatomic, weak)     id<SharePluginDelegate>delegate;

@property (nonatomic, copy)     NSString *shareTitle;

- (instancetype)initWithDelegate: (id<SharePluginDelegate>)delegate ViewController:(UIViewController *)viewController;

- (void)showShareView:(UIViewController *)viewController;

- (void)clickedButtonAtIndex:(NSUInteger)index;

@end
