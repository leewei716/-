//
//  LXTabbarViewController.m
//   
//
//  Created by will on 16/7/16.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import "LXTabbarViewController.h"
#import "LXMainViewController.h"
#import "LXForumViewController.h"
#import "LXMeViewController.h"
#import "LXNavigationViewController.h"

#import "SPKitExample.h"
#import "SPContactListController.h"
#import "SPTribeListViewController.h"
#import "SPSettingController.h"
#import "SPTribeSystemConversationViewController.h"
#import "SPUtil.h"
#import <YWExtensionForCustomerServiceFMWK/YWExtensionForCustomerServiceFMWK.h>
#import "YWConversationListViewController+UIViewControllerPreviewing.h"

#define kTabbarItemCount    4
@interface LXTabbarViewController ()
@property(nonatomic,strong)YWConversationListViewController *conversationListController ;
@end

@implementation LXTabbarViewController

- (UITabBarItem *)_makeItemWithTitle:(NSString *)aTitle normalName:(NSString *)aNormal selectedName:(NSString *)aSelected tag:(NSInteger)aTag
{
    UITabBarItem *result = nil;
    
    UIImage *nor = [UIImage imageNamed:aNormal];
    UIImage *sel = [UIImage imageNamed:aSelected];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.f) {
        result = [[UITabBarItem alloc] initWithTitle:aTitle image:nor selectedImage:sel];
        [result setTag:aTag];
    } else {
        result = [[UITabBarItem alloc] initWithTitle:aTitle image:nor tag:aTag];
    }
    return result;
}
#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.translucent = NO;
    
    NSMutableArray *aryControllers = [NSMutableArray array];
    
     /// 主页面
    {
        LXMainViewController *contactListController = [[LXMainViewController alloc] init];
        
        LXNavigationViewController *naviController = [[LXNavigationViewController alloc] initWithRootViewController:contactListController];
        
        UITabBarItem *item = [self _makeItemWithTitle:@"主页" normalName:@"home" selectedName:@"home_on" tag:100];
        [naviController setTabBarItem:item];
        
        [aryControllers addObject:naviController];
    }
    
    /// 论坛页面
    {
        LXForumViewController *settingController = [[LXForumViewController alloc] init];
        LXNavigationViewController *naviControllers = [[LXNavigationViewController alloc] initWithRootViewController:settingController];
        UITabBarItem *item = [self _makeItemWithTitle:@"论坛" normalName:@"furm" selectedName:@"furm_on" tag:101];
        [naviControllers setTabBarItem:item];
        [aryControllers addObject:naviControllers];
    }
    
    /// 会话列表页面
    {
        
        YWConversationListViewController *conversationListController = [[SPKitExample sharedInstance].ywIMKit makeConversationListViewController];
        _conversationListController=conversationListController;
        [[SPKitExample sharedInstance] exampleCustomizeConversationCellWithConversationListController:conversationListController];
        __weak __typeof(conversationListController) weakConversationListController = conversationListController;
        conversationListController.didSelectItemBlock = ^(YWConversation *aConversation) {
            if ([aConversation isKindOfClass:[YWCustomConversation class]]) {
                YWCustomConversation *customConversation = (YWCustomConversation *)aConversation;
                [customConversation markConversationAsRead];
                
                if ([customConversation.conversationId isEqualToString:SPTribeSystemConversationID]) {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Tribe" bundle:nil];
                    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"SPTribeSystemConversationViewController"];
                    [weakConversationListController.navigationController pushViewController:controller animated:YES];
                }
            }
            else {
                [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithConversation:aConversation
                                                                            fromNavigationController:weakConversationListController.navigationController];
            }
        };
        
        conversationListController.didDeleteItemBlock = ^ (YWConversation *aConversation) {
            if ([aConversation.conversationId isEqualToString:SPTribeSystemConversationID]) {
                [[[SPKitExample sharedInstance].ywIMKit.IMCore getConversationService] removeConversationByConversationId:[SPKitExample sharedInstance].tribeSystemConversation.conversationId error:NULL];
            }
        };
        
        conversationListController.ywcsTrackTitle = @"会话列表";
        
//         会话列表空视图
//        if (conversationListController)
//        {
//            CGRect frame = CGRectMake(0, 0, 100, 100);
//            UIView *viewForNoData = [[UIView alloc] initWithFrame:frame];
//            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo"]];
//            imageView.center = CGPointMake(viewForNoData.frame.size.width/2, viewForNoData.frame.size.height/2);
//            [imageView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin];
//            [viewForNoData addSubview:imageView];
//            
//            conversationListController.viewForNoData = viewForNoData;
//        }
        
        {
            __weak typeof(conversationListController) weakController = conversationListController;
            [conversationListController setViewDidLoadBlock:^{
                
                if ([weakController respondsToSelector:@selector(traitCollection)]) {
                    UITraitCollection *traitCollection = weakController.traitCollection;
                    if ( [traitCollection respondsToSelector:@selector(forceTouchCapability)] ) {
                        if (traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                            [weakController registerForPreviewingWithDelegate:weakController sourceView:weakController.tableView];
                        }
                    }
                }
            }];
        }
        
        LXNavigationViewController *naviController = [[LXNavigationViewController alloc] initWithRootViewController:conversationListController];
        UIButton *Contact=[UIButton buttonWithType:UIButtonTypeSystem];
        [Contact setImage:[UIImage imageNamed:@"contact_nor"] forState:UIControlStateNormal];
        [Contact setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        Contact.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(0), FLEXIBLE_NUMX(35), FLEXIBLE_NUMY(35));
        [Contact addTarget:self action:@selector(Contact) forControlEvents:UIControlEventTouchUpInside];
        conversationListController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:Contact];
        
        UIButton *TribeList=[UIButton buttonWithType:UIButtonTypeSystem];
        [TribeList setImage:[UIImage imageNamed:@"group_nor"] forState:UIControlStateNormal];
        [TribeList setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        TribeList.frame=CGRectMake(FLEXIBLE_NUMX(0), FLEXIBLE_NUMY(0), FLEXIBLE_NUMX(35), FLEXIBLE_NUMY(35));
        [TribeList addTarget:self action:@selector(TribeList) forControlEvents:UIControlEventTouchUpInside];
        conversationListController.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:TribeList];
        
        UITabBarItem *item = [self _makeItemWithTitle:@"消息" normalName:@"message" selectedName:@"message_on" tag:100];
        [naviController setTabBarItem:item];
        [aryControllers addObject:naviController];
        
        
        __weak typeof(naviController) weakController = naviController;
        [[SPKitExample sharedInstance].ywIMKit setUnreadCountChangedBlock:^(NSInteger aCount) {
            NSString *badgeValue = aCount > 0 ?[ @(aCount) stringValue] : nil;
            weakController.tabBarItem.badgeValue = badgeValue;
        }];
    }
    
    /// 个人页面
    {
        LXMeViewController *settingController = [[LXMeViewController alloc] init];
        
        LXNavigationViewController *naviControllerss = [[LXNavigationViewController alloc] initWithRootViewController:settingController];
        
        UITabBarItem *item = [self _makeItemWithTitle:@"我的" normalName:@"user" selectedName:@"user_on" tag:102];
        [naviControllerss setTabBarItem:item];
        
        [aryControllers addObject:naviControllerss];
    }
        self.viewControllers = aryControllers;
    
}
-(void)Contact{
    SPContactListController *contacts=[[SPContactListController alloc]init];
    [_conversationListController.navigationController pushViewController:contacts animated:YES];
}
-(void)TribeList{
    SPTribeListViewController *tribeController = [[SPTribeListViewController alloc] init];
    [_conversationListController.navigationController pushViewController:tribeController animated:YES];
}
- (void)addCustomConversation
{
    [[SPKitExample sharedInstance] exampleAddOrUpdateCustomConversation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
