//
//  MMParallaxCell.h
//  MMParallaxCell
//
//  Created by Ralph Li on 3/27/15.
//  Copyright (c) 2015 LJC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMParallaxCell : UITableViewCell

@property (nonatomic, strong) UIImageView *parallaxImage;

@property (nonatomic, assign) CGFloat parallaxRatio; //ratio of cell height, should between [1.0f, 2.0f], default is 1.5f;

@end
