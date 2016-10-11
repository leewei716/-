//
//  HttpTool.m
//  走呗
//
//  Created by 走呗 on 15/10/26.
//  Copyright © 2015年 ZOUBEI. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"
#import "Login.h"
#import "AFHTTPSessionManager.h"
@implementation HttpTool

+ (void)postWithBaseURL:(NSString *)urlString params:(NSDictionary *)params success:(Success)success failure:(Failure)failure {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.requestSerializer= [AFJSONRequestSerializer serializer];
    manager.responseSerializer= [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([responseObject[@"result"] intValue] == -1) {
                    [Login autoLoginSuccess:^(id result) {
                        if ([[NSString stringWithFormat:@"%@", result] isEqualToString:@"1"]) {
                            [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                success(responseObject);
                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                failure(error);
                            }];
                        } else {
                            success(@{@"result": @"-1"});
                        }
                    } failure:^(NSError *error) {
                        failure(error);
                    }];
                } else {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(error);
            }];

}
+ (void)postImgaeWithBaseURL:(NSString *)urlString params:(NSDictionary *)params data:(NSMutableArray *)dataArray success:(Success)success failure:(Failure)failure {
    
    // 上传图片
    AFHTTPSessionManager *manager=[[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSData *data in dataArray) {
            [formData appendPartWithFileData:data name:@"image" fileName:@"" mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
@end
