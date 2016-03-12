//
//  RecommendHeadCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RecommendHeadCell.h"
#import "RespondKeyboardSearchField.h"
@interface RecommendHeadCell()
@property (weak) IBOutlet NSImageView *coverImg;
@property (weak) IBOutlet NSButton *titleButton;
@property (weak) IBOutlet NSTextField *infoTextField;
@property (weak) IBOutlet NSTextField *briefTextField;
@property (strong, nonatomic) NSString *filmReviewURL;
@property (weak) IBOutlet NSButton *filmReviewButton;
@property (assign, nonatomic) CGFloat rowHeight;
@property (weak) IBOutlet NSTextField *todayRecommedTextField;
@property (weak) IBOutlet RespondKeyboardSearchField *searchField;
@property (strong, nonatomic) NSString *searchPath;
@end

@implementation RecommendHeadCell
- (void)awakeFromNib{
    [super awakeFromNib];
    __weak typeof(self)weakSelf = self;
    [self.searchField setWithBlock:^{
        [weakSelf clickSearchButton:nil];
    }];
}

- (IBAction)clickFilmReviewButton:(NSButton *)sender {
    if (self.filmReviewURL) system([[NSString stringWithFormat:@"open %@", self.filmReviewURL] cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (IBAction)clickSearchButton:(NSButton *)sender {
    NSString *searchKeyWord = self.searchField.stringValue;
    if (!searchKeyWord || [searchKeyWord isEqualToString:@""]) return;
    
    system([[NSString stringWithFormat:self.searchPath, searchKeyWord] cStringUsingEncoding:NSUTF8StringEncoding]);
}


- (void)setWithTitle:(NSString *)title info:(NSString *)info brief:(NSString *)brief imgURL:(NSURL *)imgURL FilmReviewURL:(NSString *)filmReviewURL{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSImage *img = [[NSImage alloc] initWithContentsOfURL:imgURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.coverImg.image = img;
        });
    });
    self.titleButton.title = title?title:@"";
    self.infoTextField.stringValue = info?info:@"";
    self.briefTextField.stringValue = brief?brief:@"";
    self.filmReviewURL = filmReviewURL;
    if (imgURL) {
        [self.filmReviewButton setHidden:NO];
    }
    self.rowHeight = 130 + self.titleButton.frame.size.height + self.infoTextField.frame.size.height + self.briefTextField.frame.size.height + self.filmReviewButton.frame.size.height + self.todayRecommedTextField.frame.size.height + self.searchField.frame.size.height;
}

- (CGFloat)cellHeight{
    return self.rowHeight;
}

#pragma mark - 懒加载
- (NSString *)searchPath {
    if(_searchPath == nil) {
        _searchPath = @"open http://dmhy.dandanplay.com/topics/list?keyword=%@&from=dandanplay";
    }
    return _searchPath;
}


@end
