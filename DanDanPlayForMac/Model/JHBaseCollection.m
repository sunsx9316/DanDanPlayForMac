//
//  JHBaseCollection.m
//  BreastDoctor
//
//  Created by JimHuang on 17/3/25.
//  Copyright © 2017年 Convoy. All rights reserved.
//

#import "JHBaseCollection.h"

@implementation JHBaseCollection

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"collection" : [self entityClass]};
}

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"collection" : [self collectionKey]};
}

+ (Class)entityClass {
    NSString *className = [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"Collection" withString:@""];
    return NSClassFromString(className);
}

+ (NSString *)collectionKey {
    NSMutableString *className = NSStringFromClass([self entityClass]).mutableCopy;
    if (className.length > 2) {
        //删掉JH
        [className deleteCharactersInRange:NSMakeRange(0, 2)];
        //首字母小写
//        if (className.length > 1) {
//            [className replaceCharactersInRange:NSMakeRange(0, 1) withString:[[className substringToIndex:1] lowercaseString]];
//        }
        //拼上s
        [className appendString:@"s"];
        return className;
    }
    return className;
}

@end
