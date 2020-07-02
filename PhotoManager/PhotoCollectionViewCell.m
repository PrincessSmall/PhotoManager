//
//  PhotoCollectionViewCell.m
//  PhotoManager
//
//  Created by PrinceSmall on 2020/7/2.
//  Copyright © 2020 PrincessSmall. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@interface PhotoCollectionViewCell ()



@end

@implementation PhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.photoImageView];
    }
    return self;
}
- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
    }
    return _photoImageView;
}

@end
