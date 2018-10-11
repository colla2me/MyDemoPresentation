//
//  SampleTagCell.m
//  SampleObjC
//
//  Created by samuel on 2018/10/11.
//  Copyright © 2018 Samuel. All rights reserved.
//

#import "SampleTagCell.h"
#import "Masonry.h"

@implementation SampleTagCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.borderColor = [UIColor grayColor].CGColor;
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.cornerRadius = frame.size.height * 0.5;
        
        _tagLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.backgroundColor = [UIColor clearColor];
        _tagLabel.font = [UIFont systemFontOfSize:13];
        _tagLabel.textColor = [UIColor blackColor];
        _tagLabel.clipsToBounds = YES;
        [self.contentView addSubview:_tagLabel];
        [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.insets(UIEdgeInsetsMake(8, 10, 8, 10));
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.contentView.backgroundColor = selected ? [UIColor orangeColor] : [UIColor whiteColor];
    self.tagLabel.textColor = selected ? [UIColor whiteColor] : [UIColor blackColor];
}

@end
