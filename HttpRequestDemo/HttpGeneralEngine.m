//
//  HttpGeneralEngine.m
//  HttpRequestDemo
//
//  Created by Y杨定甲 on 16/5/31.
//  Copyright © 2016年 damai. All rights reserved.
//

#import "HttpGeneralEngine.h"


@implementation HttpGeneralEngine


+ (HttpGeneralEngine *)sharedInstance{
    static dispatch_once_t pred;
    static HttpGeneralEngine *httpRequest = nil;
    dispatch_once(&pred, ^{
        httpRequest = [[HttpGeneralEngine alloc] init];
    });
    return httpRequest;
}
//系统自带的网络请求
- (NSMutableURLRequest *)requestGETWithUrl:(NSString *)urlName param:(NSDictionary *)param errorOperation:(RequestBlock)error{
    if (urlName == nil) {
        return nil;
    }else{
        urlName = [urlName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
//    NSString *pathStr = [NSString stringWithFormat:@"%@/%@",SEVERURL_USER_ME,urlName];
    NSString *pathStr = [NSString stringWithFormat:@"%@",urlName];
    NSURL *url = [NSURL URLWithString:pathStr];
    __block NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];//缓存模式
    [request setTimeoutInterval:8.0];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请求错误：%@", error);
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            id jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:Nil];
            NSLog(@"%@",jsonData);
            
            if ([jsonData  isKindOfClass:[NSArray  class]]) {
//                NSDictionary*  dic = jsonData[0];
                //回调  暂时没写
//                callback(dic);
                
            }else{
//                callback(jsonData);
            }
            
        });

    }];
    
    [task resume];
    
    return request;
}

//使用AFN测试网络
- (AFHTTPSessionManager *)requestPostWithUrl:(NSString *)urlName param:(NSDictionary *)param OnComplete:(RequestBlock)block{
    
    if (urlName == nil) {
        return nil;
    }else{
        urlName = [urlName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
//    NSString *pathStr = [NSString stringWithFormat:@"%@/%@",SEVERURL_USER_ME,urlName];
    AFHTTPSessionManager *requestManager = [AFHTTPSessionManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.requestSerializer.timeoutInterval = 8.0;
    [requestManager POST:urlName parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
         NSLog(@"请求成功:%@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@",error);
    }];
    
    
    return requestManager;
}


//回调网络状态
- (void)requestGetWithUrl:(NSString *)urlName param:(NSDictionary *)param OnComplete:(RequestBlock)block{
    if (urlName == nil) {
        return;
    }else{
        urlName = [urlName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSString *pathStr = [NSString stringWithFormat:@"%@/%@",SEVERURL_USER_ME,urlName];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //这种形式代表不作处理直接拿服务器返回的类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 8.0;
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    NSLog(@"%@",manager);
    [manager GET:pathStr parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"%@",dic);
        NSDictionary *data = [dic objectForKey:@"data"];
        NSInteger status = [[dic objectForKey:@"status"] integerValue];
        NSString *msg = [dic objectForKey:@"msg"];
        block(data,status,msg);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败:%@",error);
        NSDictionary *data = [dic objectForKey:@"data"];
        NSInteger status = [[dic objectForKey:@"status"] integerValue];
        NSString *msg = [dic objectForKey:@"msg"];
        block(data,status,msg);
    }];
    
}



@end
