//
//  GDataXMLElement+Tools.m
//  DanDanPlayForiOS
//
//  Created by JimHuang on 16/10/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "GDataXMLElement+Tools.h"

@implementation GDataXMLElement (Tools)
- (NSDictionary *)keysValuesForElementKeys:(NSArray <NSString *>*)keys {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *key in keys) {
        NSArray *elements = [self elementsForName:key];
        if (elements.count <= 1) {
            GDataXMLElement *element = elements.firstObject;
            dic[key] = [element stringValue];
            if (![dic[key] length]) {
                dic[key] = element;
            }
        }
        else {
            dic[key] = elements;
        }
    }
    return dic;
}

- (NSDictionary *)keysValuesForAttributeKeys:(NSArray <NSString *>*)keys {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *key in keys) {
        dic[key] = [self attributeForName:key].stringValue;
    }
    return dic;
}
@end
