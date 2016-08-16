//
//  RecommendBangumiCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/12.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RecommendBangumiCell.h"

//弹弹原来的路径
#define OLD_PATH @"http://dmhy.dandanplay.com"
//新的路径
#define NEW_PATH @"https://share.dmhy.org"

@interface RecommendBangumiCell()
@property (weak) IBOutlet NSImageView *coverImgView;
@property (weak) IBOutlet NSTextField *titleTextField;
@property (weak) IBOutlet NSPopUpButton *captionsGroupPopUpButton;
@property (strong, nonatomic) NSString *keyWord;
@end

@implementation RecommendBangumiCell
{
    BangumiDataModel *_model;
}

- (void)setWithModel:(BangumiDataModel *)model {
    _model = model;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSImage *img = [[NSImage alloc] initWithContentsOfURL:model.imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.coverImgView.image = img;
        });
    });
    self.titleTextField.stringValue = model.name.length ? model.name : @"";
    self.keyWord = model.keyWord;
    [model.groups enumerateObjectsUsingBlock:^(BangumiGroupModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.captionsGroupPopUpButton addItemWithTitle:obj.groupName];
    }];
}

- (IBAction)clickCaptionsPopUpButton:(NSPopUpButton *)sender {
    NSInteger selectIndex = sender.indexOfSelectedItem;
    if (selectIndex < _model.groups.count) {
        NSString *url = _model.groups[selectIndex].searchURL;
        NSRange range = [url rangeOfString:OLD_PATH];
        NSMutableString *tempStr = [[NSMutableString alloc] initWithString:_model.groups[selectIndex].searchURL];
        [tempStr replaceCharactersInRange:range withString:NEW_PATH];
        if (tempStr) {
            system([[NSString stringWithFormat:@"open %@", tempStr] cStringUsingEncoding:NSUTF8StringEncoding]);
        }
    }
}


@end
