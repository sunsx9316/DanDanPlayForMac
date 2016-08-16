//
//  RecommendHeadCell.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/3/11.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "RecommendHeadCell.h"
#import "NSString+Tools.h"

@interface RecommendHeadCell()
@property (weak) IBOutlet NSImageView *coverImg;
@property (weak) IBOutlet NSButton *titleButton;
@property (weak) IBOutlet NSTextField *infoTextField;
@property (weak) IBOutlet NSTextField *briefTextField;
@property (weak) IBOutlet NSButton *filmReviewButton;
@property (weak) IBOutlet NSTextField *todayRecommedTextField;
@property (weak) IBOutlet NSSearchField *searchField;
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
}

- (IBAction)clickFilmReviewButton:(NSButton *)sender {
    if (_model.fileReviewURL) {
        system([[NSString stringWithFormat:@"open %@", _model.fileReviewURL] cStringUsingEncoding:NSUTF8StringEncoding]);
    }
}

- (IBAction)clickSearchButton:(NSButton *)sender {
    NSString *searchKeyWord = self.searchField.stringValue;
    if (!searchKeyWord.length) return;
    searchKeyWord = [searchKeyWord stringByURLEncode];
    //破软件迟早药丸
    if ([searchKeyWord isEqualToString:@"%E9%95%BF%E8%80%85"] || [searchKeyWord isEqualToString:@"%E8%86%9C%E8%9B%A4"] || [searchKeyWord isEqualToString:@"%E8%9B%A4%E8%9B%A4"] || [searchKeyWord isEqualToString:@"%E8%B5%9B%E8%89%87"]) {
        system("open http://baike.baidu.com/view/1781.htm");
    }
    system([[NSString stringWithFormat:self.searchPath, searchKeyWord] cStringUsingEncoding:NSUTF8StringEncoding]);
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
//    self.filmReviewURL = filmReviewURL;
    if (_model.fileReviewURL) {
        [self.filmReviewButton setHidden:NO];
    }
    return 130 + self.titleButton.frame.size.height + self.infoTextField.frame.size.height + self.briefTextField.frame.size.height + self.filmReviewButton.frame.size.height + self.todayRecommedTextField.frame.size.height + self.searchField.frame.size.height;
}


#pragma mark - 懒加载
- (NSString *)searchPath {
    if(_searchPath == nil) {
        _searchPath = @"open https://share.dmhy.org/topics/list?keyword=%@&from=dandanplay";
    }
    return _searchPath;
}

@end
