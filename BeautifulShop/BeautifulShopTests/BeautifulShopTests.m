//
//  BeautifulShopTests.m
//  BeautifulShopTests
//
//  Created by BeautyWay on 14-9-26.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BWMRequestCenter.h"

static NSString * const _userID = @"5510dc8a0003";

@interface BeautifulShopTests : XCTestCase

@end

@implementation BeautifulShopTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    [BWMRequestCenter
     GET:@"http://server.mallteem.com/json/index.ashx?aim=myprofit"
     parameters:@{@"userid":_userID, @"type":@3}
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"%@", responseObject);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];
    
    [[NSRunLoop mainRunLoop] run];
}

- (void)testMyIncomeList {
    [BWMRequestCenter GET:@"http://server.mallteem.com/json/index.ashx?aim=profitList" parameters:@{@"userid" : _userID, @"type" : @2} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [[NSRunLoop mainRunLoop] run];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        
    }];
}

@end
