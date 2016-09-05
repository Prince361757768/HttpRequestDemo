//
//  ViewController.m
//  HttpRequestDemo
//
//  Created by Y杨定甲 on 16/5/31.
//  Copyright © 2016年 damai. All rights reserved.
//

#import "ViewController.h"
#import "HttpGeneralEngine.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)request{
    NSString *url = @"https://www.baidu.com";
//    [[HttpGeneralEngine sharedInstance] requestGETWithUrl:url param:nil errorOperation:^(NSDictionary *sourceDic, NSInteger status, NSString *message) {
//        //由于未写回调。不打印
//        NSLog(@"请求结束");
//    }];
    
//    [[HttpGeneralEngine sharedInstance] requestPostWithUrl:url param:nil OnComplete:^(NSDictionary *sourceDic, NSInteger status, NSString *message) {
//        
//    }];
    
    NSString* apiName = @"scene/scene_city_list";
    [[HttpGeneralEngine sharedInstance] requestGetWithUrl:apiName param:nil OnComplete:^(NSDictionary *sourceDic, NSInteger status, NSString *message) {
        NSLog(@"Data:%@   Status:%ld   Message:%@",sourceDic,(long)status,message);
    }];
    
}
- (IBAction)requestClick:(id)sender {
    [self request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
