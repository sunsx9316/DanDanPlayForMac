//
//  RecommendBangumiCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/12.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RecommendBangumiCell.h"
@interface RecommendBangumiCell()
@property (weak) IBOutlet NSImageView *coverImgView;
@property (weak) IBOutlet NSTextField *titleTextField;
@property (weak) IBOutlet NSPopUpButton *captionsGroupPopUpButton;
@property (strong, nonatomic) NSString *keyWord;
@end

@implementation RecommendBangumiCell
{
    JHBangumi *_model;
}

- (void)setWithModel:(JHBangumi *)model {
    _model = model;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSImage *img = [[NSImage alloc] initWithContentsOfURL:model.imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.coverImgView.image = img;
        });
    });
    self.titleTextField.text = model.name;
    self.keyWord = model.keyword;
    [self.captionsGroupPopUpButton removeAllItems];
    [model.collection enumerateObjectsUsingBlock:^(JHBangumiGroup * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.captionsGroupPopUpButton addItemWithTitle:obj.name];
    }];
}

- (IBAction)clickCaptionsPopUpButton:(NSPopUpButton *)sender {
    if (self.clickGroupsButtonCallBack) {
        NSUInteger index = sender.indexOfSelectedItem;
        if (index < _model.collection.count) {
            self.clickGroupsButtonCallBack(_model.collection[index]);
        }
    }
}


@end
