//
//  JHBase.h
//  BaseProject
//
//  Created by JimHuang on 16/8/23.
//  Copyright © 2016年 jimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

@interface JHBase : NSObject<YYModel, NSCoding, NSCopying>
@property (assign, nonatomic) NSUInteger identity;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *desc;
@end
