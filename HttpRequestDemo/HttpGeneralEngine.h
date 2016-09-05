//
//  HttpGeneralEngine.h
//  HttpRequestDemo
//
//  Created by Y杨定甲 on 16/5/31.
//  Copyright © 2016年 damai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

//#define SEVERURL @"http://192.168.66.58"
#define SEVERURL_USER_ME @"https://buyerapp1.piao.cn"//线上环境
typedef enum {
    kHttpTimeOutErrorCode = -1001,//超时
    //
    RequestErrorCodeConnectError = -1,//网络错误
    RequestErrorCodeNull = 32000,//返回的不是字典类型
    RequestErrorCodeException = 32100,//返回的字典是空
    //
    HTTP_200 = 200,//成功
    HTTP_400 = 400,//错误请求，请求参数错误
    HTTP_401 = 401,// 未授权、未登录
    HTTP_404 = 404,// 未找到资源
    HTTP_405 = 405,// 请求方法错误
    HTTP_500 = 500,//服务器内容错误
}RequestStatus;

typedef void(^RequestBlock)(NSDictionary *sourceDic, NSInteger status, NSString *message);


@interface HttpGeneralEngine : NSObject

#pragma mark -- 设置网络单例
+ (HttpGeneralEngine *) sharedInstance;

- (NSMutableURLRequest *)requestGETWithUrl:(NSString*)urlName
                                     param:(NSDictionary*)param
                            errorOperation:(RequestBlock)error;

- (AFHTTPSessionManager *)requestPostWithUrl:(NSString*)urlName
                                    param:(NSDictionary*)param
                           OnComplete:(RequestBlock)block;

///封装回调
- (void)requestGetWithUrl:(NSString*)urlName
                    param:(NSDictionary*)param
               OnComplete:(RequestBlock)block;
//           errorOperation:(void (^)(NSError *))failure;


@end
