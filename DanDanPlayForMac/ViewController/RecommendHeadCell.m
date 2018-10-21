//
//  RecommendHeadCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RecommendHeadCell.h"
#import "NSString+Tools.h"
#import "NSButton+Tools.h"
#import "RespondKeyboardSearchField.h"
#import "AddTrackingAreaButton.h"

@interface RecommendHeadCell()
@property (weak) IBOutlet NSImageView *coverImg;
@property (weak) IBOutlet AddTrackingAreaButton *titleButton;
@property (weak) IBOutlet NSTextField *infoTextField;
@property (weak) IBOutlet NSButton *filmReviewButton;
@property (weak) IBOutlet NSTextField *todayRecommedTextField;
@property (weak) IBOutlet RespondKeyboardSearchField *searchField;
@property (strong, nonatomic) NSString *searchPath;
@property (strong) IBOutlet NSTextView *briefTextView;


@end

@implementation RecommendHeadCell
{
    JHFeatured *_model;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.infoTextField.preferredMaxLayoutWidth = self.frame.size.width;
    
    @weakify(self)
    [self.searchField setRespondBlock:^{
        @strongify(self)
        if (!self) return;
        
        if (self.clickSearchButtonCallBack) {
            self.clickSearchButtonCallBack(self.searchField.stringValue);
        }
    }];
    
    [self.titleButton setMouseEnteredCallBackBlock:^{
        @strongify(self)
        if (!self) return;
        
        [self.titleButton setTitleColor:[NSColor mainColor]];
    }];
    
    [self.titleButton setMouseExitedCallBackBlock:^{
        @strongify(self)
        if (!self) return;
        [self.titleButton setTitleColor:[NSColor textColor]];
    }];
}

- (IBAction)clickFilmReviewButton:(NSButton *)sender {
    if (self.clickFilmReviewButtonCallBack) {
        self.clickFilmReviewButtonCallBack(_model.link);
    }
}

- (IBAction)clickSearchButton:(NSButton *)sender {
    if (self.clickSearchButtonCallBack) {
        self.clickSearchButtonCallBack(self.searchField.stringValue);
    }
}

- (IBAction)clickTitleButton:(NSButton *)sender {
    if (self.clickSearchButtonCallBack) {
        self.clickSearchButtonCallBack(sender.title);
    }
}

- (void)setWithModel:(JHFeatured *)model {
    _model = model;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSImage *img = [[NSImage alloc] initWithContentsOfURL:_model.imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.coverImg.image = img;
        });
    });
    self.titleButton.text = _model.name;
    self.infoTextField.text = _model.category;
    self.briefTextView.string = _model.desc;
    if (_model.link) {
        [self.filmReviewButton setHidden:NO];
    }
}

@end
