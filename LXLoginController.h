//
//  LXLoginController.h
//   一起留学
//
//  Created by will on 16/7/18.
//  Copyright © 2016年 leewei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SPLoginAutoLoginCompletion)(void);

@interface LXLoginController : UIViewController<UIActionSheetDelegate>

+ (void)getLastUserID:(NSString **)aUserID lastPassword:(NSString **)aPassword;
@end
