//
//  DDPBaseCollection.m
//  BreastDoctor
//
//  Created by JimHuang on 17/3/25.
//  Copyright © 2017年 Convoy. All rights reserved.
//

#import "DDPBaseCollection.h"

@implementation DDPBaseCollection

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
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
    if (className.length > 3) {
        //删掉DDP
        [className deleteCharactersInRange:NSMakeRange(0, 3)];
        //拼上s
        [className appendString:@"s"];
        return className;
    }
    return className;
}

@end
