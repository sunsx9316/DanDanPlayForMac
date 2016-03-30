//
//  QualityCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/28.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "QualityCell.h"
@interface QualityCell()
@property (weak) IBOutlet NSPopUpButton *qualityButton;

@end
@implementation QualityCell
- (void)awakeFromNib{
    [super awakeFromNib];
    [self.qualityButton selectItemAtIndex:[UserDefaultManager defaultQuality]];
}

- (IBAction)clickPopUpButton:(NSPopUpButton *)sender {
    [UserDefaultManager setDefaultQuality:[sender indexOfSelectedItem]];
}


@end
