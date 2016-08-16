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
+ (NSURLSessionDataTask *)filterWithCompletionHandler:(void(^)(id responseObj, NSError *error))complete {
    NSString *path = @"http://api.acplay.net:8089/config/filter.xml";
    
    return [self GETDataWithPath:path parameters:nil completionHandler:^(NSData *responseObj, NSError *error) {
        NSMutableArray *arr = [NSMutableArray array];
        GDataXMLDocument *document=[[GDataXMLDocument alloc] initWithData:responseObj encoding:NSUTF8StringEncoding error:nil];
        NSArray *dataArr = [document.rootElement elementsForName:@"FilterItem"];
        for (GDataXMLElement *dataElement in dataArr) {
            NSString *string = dataElement.stringValue;
            if (string.length) [arr addObject:@{@"text":string, @"state":@([[[dataElement attributeForName:@"IsRegex"] stringValue] isEqualToString:@"true"])}];
        }
        complete(arr, error);
    }];
}
@end
