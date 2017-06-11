//
//  GDataXMLElement+Tools.h
//  DanDanPlayForiOS
//
//  Created by JimHuang on 16/10/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <GDataXMLNode.h>

@interface GDataXMLElement (Tools)
- (NSDictionary *)keysValuesForElementKeys:(NSArray <NSString *>*)keys;
- (NSDictionary *)keysValuesForAttributeKeys:(NSArray <NSString *>*)keys;
@end
