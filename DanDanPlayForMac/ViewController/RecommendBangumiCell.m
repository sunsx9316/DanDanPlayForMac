//
//  RecommendBangumiCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/12.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RecommendBangumiCell.h"
#import "BangumiModel.h"

//弹弹原来的路径
#define OLD_PATH @"http://dmhy.dandanplay.com"
//新的路径
#define NEW_PATH @"https://share.dmhy.org"

@interface RecommendBangumiCell()
@property (weak) IBOutlet NSImageView *coverImgView;
@property (weak) IBOutlet NSTextField *titleTextField;
@property (weak) IBOutlet NSPopUpButton *captionsGroupPopUpButton;
@property (strong, nonatomic) NSArray <BangumiGroupModel *>*groupModels;
@property (strong, nonatomic) NSString *keyWord;
@end

@implementation RecommendBangumiCell
- (void)setWithTitle:(NSString *)title keyWord:(NSString *)keyWord imgURL:(NSURL *)imgURL captionsGroup:(NSArray <BangumiGroupModel *>*)captionsGroup{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSImage *img = [[NSImage alloc] initWithContentsOfURL:imgURL];
       dispatch_async(dispatch_get_main_queue(), ^{
           self.coverImgView.image = img;
       });
    });
    self.titleTextField.stringValue = title.length ? title : @"";
    self.groupModels = captionsGroup;
    self.keyWord = keyWord;
    [captionsGroup enumerateObjectsUsingBlock:^(BangumiGroupModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.captionsGroupPopUpButton addItemWithTitle:obj.groupName];
    }];
}

- (IBAction)clickCaptionsPopUpButton:(NSPopUpButton *)sender {
    NSInteger selectIndex = sender.indexOfSelectedItem;
    if (selectIndex < self.groupModels.count) {
        NSString *url = self.groupModels[selectIndex].searchURL;
        NSRange range = [url rangeOfString:OLD_PATH];
        NSMutableString *tempStr = [[NSMutableString alloc] initWithString:self.groupModels[selectIndex].searchURL];
        [tempStr replaceCharactersInRange:range withString:NEW_PATH];
        if (tempStr) {
            system([[NSString stringWithFormat:@"open %@", tempStr] cStringUsingEncoding:NSUTF8StringEncoding]);
        }
    }
}


@end
