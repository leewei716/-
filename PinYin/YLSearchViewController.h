//
//  SearchViewController.h
//


//
//  Created by will on 16/7/16.
//  Copyright © 2016年 leewei. All rights reserved.

#import <UIKit/UIKit.h>

@protocol SearchResultDelegate <NSObject>

- (void)searchResultData:(NSString *)value;//1.1定义协议与方法


@end


@interface YLSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate> {
    NSMutableArray *searchResults;
    UISearchBar *mySearchBar;
    UISearchDisplayController *searchDisplayController;

}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *serchArray;
@property (nonatomic,strong) id <SearchResultDelegate> delegate;
@end
