//
//  FilterNetManager.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "FilterNetManager.h"
#import <GDataXMLNode.h>

@implementation FilterNetManager
+ (id)filterWithCompletionHandler:(void(^)(id responseObj, NSError *error))complete{
    return [self getDataWithPath:@"http://api.acplay.net:8089/config/filter.xml" parameters:nil completionHandler:^(NSData *responseObj, NSError *error) {
        NSMutableArray *arr = [NSMutableArray array];
        GDataXMLDocument *document=[[GDataXMLDocument alloc] initWithData:responseObj encoding:NSUTF8StringEncoding error:nil];
        NSArray *dataArr = [document.rootElement elementsForName:@"FilterItem"];
        for (GDataXMLElement *dataElement in dataArr) {
            NSString *string = dataElement.stringValue;
            if (string) [arr addObject:@{@"text":string, @"state":@1}];
        }
        complete(arr, error);
    }];
}
@end
