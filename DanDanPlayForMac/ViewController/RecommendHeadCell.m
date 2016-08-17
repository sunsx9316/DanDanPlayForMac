//
//  RecommendHeadCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RecommendHeadCell.h"
#import "NSString+Tools.h"
#import "RespondKeyboardSearchField.h"

@interface RecommendHeadCell()
@property (weak) IBOutlet NSImageView *coverImg;
@property (weak) IBOutlet NSButton *titleButton;
@property (weak) IBOutlet NSTextField *infoTextField;
@property (weak) IBOutlet NSTextField *briefTextField;
@property (weak) IBOutlet NSButton *filmReviewButton;
@property (weak) IBOutlet NSTextField *todayRecommedTextField;
@property (weak) IBOutlet RespondKeyboardSearchField *searchField;
@property (strong, nonatomic) NSString *searchPath;
@end

@implementation RecommendHeadCell
{
    FeaturedModel *_model;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.infoTextField.preferredMaxLayoutWidth = self.frame.size.width;
    self.briefTextField.preferredMaxLayoutWidth = self.frame.size.width;
    
    @weakify(self)
    [self.searchField setRespondBlock:^{
        @strongify(self)
        if (!self) return;
        
        if (self.clickSearchButtonCallBack) {
            self.clickSearchButtonCallBack(self.searchField.stringValue);
        }
    }];
}

- (IBAction)clickFilmReviewButton:(NSButton *)sender {
    if (self.clickFilmReviewButtonCallBack) {
        self.clickFilmReviewButtonCallBack(_model.fileReviewPath);
    }
}

- (IBAction)clickSearchButton:(NSButton *)sender {
    if (self.clickSearchButtonCallBack) {
        self.clickSearchButtonCallBack(self.searchField.stringValue);
    }
}

- (CGFloat)heightWithModel:(FeaturedModel *)model {
    _model = model;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSImage *img = [[NSImage alloc] initWithContentsOfURL:_model.imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.coverImg.image = img;
        });
    });
    self.titleButton.title = _model.title.length ? _model.title : @"";
    self.infoTextField.stringValue = _model.category.length ? _model.category : @"";
    self.briefTextField.stringValue = _model.introduction.length ? _model.introduction : @"";;
    if (_model.fileReviewPath) {
        [self.filmReviewButton setHidden:NO];
    }
    return 150 + self.titleButton.frame.size.height + self.infoTextField.frame.size.height + self.briefTextField.frame.size.height + self.filmReviewButton.frame.size.height + self.todayRecommedTextField.frame.size.height + self.searchField.frame.size.height;
}

@end
