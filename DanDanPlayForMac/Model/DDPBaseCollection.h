//
//  DDPBaseCollection.h
//  BreastDoctor
//
//  Created by JimHuang on 17/3/25.
//  Copyright © 2017年 Convoy. All rights reserved.
//

#import "DDPBase.h"

@interface DDPBaseCollection : DDPBase
@property (strong, nonatomic) NSMutableArray <__kindof DDPBase *>*collection;
+ (NSString *)collectionKey;
+ (Class)entityClass;
@end
