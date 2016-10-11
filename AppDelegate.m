//
//  AppDelegate.m
//  一起留学
//
//  Created by will on 16/7/16.
//  Copyright © 2016年 leewei. All rights reserved.

#import "AppDelegate.h"
#import "LXGuideViewController.h"
#import "LXMainViewController.h"
#import "LXTabbarViewController.h"
#import "LXLoginController.h"
#import "XHLaunchAd.h"

#import <UIKit/UIKit.h>

#import "SPKitExample.h"
#import "SPTribeProfileViewController.h"
#import "JLRoutes.h"
#import "SPSearchTribeViewController.h"

//静态广告
//#define ImgUrlString1 @"http://d.hiphotos.baidu.com/image/pic/item/14ce36d3d539b60071473204e150352ac75cb7f3.jpg"
//动态广告
#define ImgUrlString2 @"http://imgsrc.baidu.com/forum/pic/item/5db7bd7eca8065386f71baac97dda144ac34821e.jpg"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //延长启动页面时间
    // [NSThread sleepForTimeInterval:1.0];
    // YWSDK快速接入接口，程序启动后调用这个接口
    [[SPKitExample sharedInstance] callThisInDidFinishLaunching];
    // 从这到当前方法结束是您的业务代码
    NSLog(@"Path:%@", NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
    
    
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
//    [self example];
    LXLoginController *main=[[LXLoginController alloc] init];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:main];
    self.window.rootViewController=nav;

    [self.window makeKeyAndVisible];
    
    return YES;
}
/*
 *  启动页广告
 */
-(void)example
{
    /**
     *  1.显示启动页广告
     */
    [XHLaunchAd showWithAdFrame:CGRectMake(0, 0,self.window.bounds.size.width, self.window.bounds.size.height) setAdImage:^(XHLaunchAd *launchAd) {
        //未检测到广告数据,启动页停留时间,不设置默认为3,(设置4即表示:启动页显示了4s,还未检测到广告数据,就自动进入window根控制器)
        launchAd.noDataDuration = 2;
        //获取广告数据
        [self requestImageData:^(NSString *imgUrl, NSInteger duration, NSString *openUrl) {
            /**
             *  2.设置广告数据
             */
            [launchAd setImageUrl:imgUrl duration:duration skipType:SkipTypeTimeText options:XHWebImageDefault completed:^(UIImage *image, NSURL *url) {
                //异步加载图片完成回调(若需根据图片尺寸,刷新广告frame,可在这里操作)
//                launchAd.adFrame =[UIScreen mainScreen].bounds;
            } click:^{
                //广告点击事件
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
            }];
        }];
    } showFinish:^{
        //广告展示完成回调,设置window根控制器
//        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LXTabbarViewController alloc] init]];
            LXLoginController *main=[[LXLoginController alloc] init];
          UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:main];
        //      nav.navigationBarHidden=YES;
                self.window.rootViewController=nav;
    }];
}
/**
 *  模拟:向服务器请求广告数据
 *
 *  @param imageData 回调imageUrl,及停留时间,跳转链接
 */
-(void)requestImageData:(void(^)(NSString *imgUrl,NSInteger duration,NSString *openUrl))imageData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if(imageData)
        {
//            可以设置gif播放时间，及点击后跳转的url
            imageData(ImgUrlString2,6,@"");
        }
    });
}

/// iOS8下申请DeviceToken
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}
#endif

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if ([url.scheme isEqualToString:@"openimdemo"]) {
        [JLRoutes routeURL:url];
    }
    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /// 设置给OpenIM
    /// 现在您不需要手动设置DeviceToken，IMSDK会自动获取
    /// [[SPKitExample sharedInstance] exampleSetDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    /// 处理运行时APNS
    /// 现在您不需要手动调用，IMSDK会自动截获
    /// [[SPKitExample sharedInstance] exampleHandleRunningAPNSWithUserInfo:userInfo];
}

- (void)didReceiveMessageNotification:(NSNotification *)notification {
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//#pragma mark - Routable
//- (void)setupRote {
//    [JLRoutes addRoute:@"/searchTribe" handler:^BOOL(NSDictionary *parameters) {
//        if ([parameters[@"tribeId"] length] == 0) {
//            return NO;
//        }
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Tribe" bundle:nil];
//        SPSearchTribeViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SPSearchTribeViewController"];
//        controller.searchText = parameters[@"tribeId"];
//        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
//        [self.window.rootViewController presentViewController:navigationController
//                                                     animated:YES
//                                                   completion:NULL];
//        return YES;
//    }];
//}

@end
