//
//  CalendarCell.m
//  CalendarTest
//
//  Created by XFXB on 16/8/12.
//  Copyright © 2016年 CalendarTest. All rights reserved.
//

#import "CalendarCell.h"

@interface CalendarCell()


@property (nonatomic,strong) NSArray *monthArray;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) CalendarMonthModel *model;
@end

@implementation CalendarCell


-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.frame;
    
    self.dayView.frame = CGRectMake(0, ITEM_TITLE_HEIGHT, DEVICE_WIDTH, rect.size.height - ITEM_TITLE_HEIGHT);

    
    self.titleLabel.frame = CGRectMake(0, 0, DEVICE_WIDTH, ITEM_TITLE_HEIGHT);
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}



-(void)initView
{
    self.contentView.backgroundColor = [UIColor whiteColor];
}

-(void)updateWithModel:(CalendarMonthModel *)model
{
    self.model = model;

    self.titleLabel.text = [NSString stringWithFormat:@"%@月 %ld",self.monthArray[self.model.date.month],self.model.date.year];
    [self.dayView updateWithModel:self.model];
}
#pragma lazyload

-(id)monthArray
{
    if(_monthArray == nil)
    {
        _monthArray = @[@"",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二"];
    }
    
    return _monthArray;
}

-(id)dayView
{
    if(_dayView == nil)
    {
        _dayView = [DayView new];
        
        [self.contentView addSubview:_dayView];
    }
    
    return _dayView;
}
-(id)titleLabel
{
    if(_titleLabel == nil)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = HEXCOLOR(0x867866, 1);
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_titleLabel];
    }
    
    return _titleLabel;
}
@end
