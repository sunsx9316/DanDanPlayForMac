//
//  BaseModel.m
//  BaseProject
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import "JHBase.h"

@implementation JHBase

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self yy_modelInitWithCoder:aDecoder];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

//- (BOOL)isEqual:(JHBase *)object {
//    if ([object isMemberOfClass:self.class] == NO) {
//        return NO;
//    }
//    
//    if (self == object) {
//        return YES;
//    }
//    
//    return self.identity == object.identity;
//}
//
//- (NSUInteger)hash {
//    return self.identity;
//}

- (id)mutableCopy {
    return [self yy_modelCopy];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

+ (NSString *)primaryKey {
    return @"identity";
}

@end
