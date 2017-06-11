//
//  JHBaseCollection.h
//  BreastDoctor
//
//  Created by JimHuang on 17/3/25.
//  Copyright © 2017年 Convoy. All rights reserved.
//

#import "JHBase.h"

@interface JHBaseCollection : JHBase
@property (strong, nonatomic) NSMutableArray <__kindof JHBase *>*collection;
+ (NSString *)collectionKey;
+ (Class)entityClass;
@end
