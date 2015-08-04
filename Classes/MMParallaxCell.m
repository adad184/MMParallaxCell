//
//  MMParallaxCell.m
//  MMParallaxCell
//
//  Created by Ralph Li on 3/27/15.
//  Copyright (c) 2015 LJC. All rights reserved.
//

#import "MMParallaxCell.h"

@interface MMParallaxCell()

@property (nonatomic, strong) UITableView *parentTableView;

@end

@implementation MMParallaxCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib
{
	[self setup];
}

- (void) setup
{
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
	
	self.parallaxImage = [UIImageView new];
	[self.contentView addSubview:self.parallaxImage];
	[self.contentView sendSubviewToBack:self.parallaxImage];
	self.parallaxImage.backgroundColor = [UIColor whiteColor];
	self.parallaxImage.contentMode = UIViewContentModeScaleAspectFill;
	self.clipsToBounds = YES;
	
	self.parallaxRatio = 1.5f;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    UIView *v = newSuperview;
    
    while ( v )
    {
        if ( [v isKindOfClass:[UITableView class]] )
        {
            
            self.parentTableView = (UITableView*)v;
            break;
        }
        v = v.superview;
    }
    
    if ( self.parentTableView )
    {
        [self.parentTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    
    @try {
        [self.parentTableView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        self.parentTableView = nil;
    }
    
}

- (void)dealloc
{
    @try {
        [self.parentTableView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        self.parentTableView = nil;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.parallaxRatio = self.parallaxRatio;
    return;
}

- (void)setParallaxRatio:(CGFloat)parallaxRatio
{
    _parallaxRatio = MAX(parallaxRatio, 1.0f);
    _parallaxRatio = MIN(parallaxRatio, 2.0f);
    
    CGRect rect = self.bounds;
    rect.size.height = rect.size.height*parallaxRatio;
    self.parallaxImage.frame = rect;
    
    [self updateParallaxOffset];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( [keyPath isEqualToString:@"contentOffset"] )
    {
        if ( ![self.parentTableView.visibleCells containsObject:self] || (self.parallaxRatio==1.0f) )
        {
            return;
        }
        
        [self updateParallaxOffset];
    }
}

- (void)updateParallaxOffset
{
    CGFloat contentOffset = self.parentTableView.contentOffset.y;
    
    CGFloat cellOffset = self.frame.origin.y - contentOffset;
    
    CGFloat percent = (cellOffset+self.frame.size.height)/(self.parentTableView.frame.size.height+self.frame.size.height);
    
    CGFloat extraHeight = self.frame.size.height*(self.parallaxRatio-1.0f);
    
    CGRect rect = self.parallaxImage.frame;
    rect.origin.y = -extraHeight*percent;
    self.parallaxImage.frame = rect;
}

@end
