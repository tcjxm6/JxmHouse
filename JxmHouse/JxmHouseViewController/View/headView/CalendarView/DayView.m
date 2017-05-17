//
//  DayView.m
//  CalendarTest
//
//  Created by XFXB on 16/8/12.
//  Copyright © 2016年 CalendarTest. All rights reserved.
//

#import "DayView.h"

#import "DayModel.h"
@interface DayView()

@property (nonatomic,strong) NSMutableArray *dayItemViewArray;
@property (nonatomic,strong) NSMutableArray *selectViewArray;
@property (nonatomic,strong) NSMutableArray *lineViewArray;
@property (nonatomic,strong) CALayer *firstLineLayer;
@property (nonatomic,strong) NSArray *dateArray;
@end

@implementation DayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

-(void)initView
{
    CGFloat x = 0;
    CGFloat y = 0;
    
    CALayer *layer = [CALayer new];
    layer.frame = CGRectMake(0, 0, DEVICE_WIDTH, 1);
    layer.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1].CGColor;
    [self.layer addSublayer:layer];
    self.firstLineLayer = layer;
    for (int i = 0; i < 6; i++) {
        x = 0;
        for (int j = 0; j < 7; j++) {
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:nil];
            imageView.frame = CGRectMake(x, y, ITEM_WIDTH, ITEM_WIDTH);
            imageView.backgroundColor = HEXCOLOR(0x867866, 1);
            imageView.contentMode = UIViewContentModeCenter;
            [self addSubview:imageView];
            [self.selectViewArray addObject:imageView];
            
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.frame = CGRectMake(x, y, ITEM_WIDTH, ITEM_WIDTH);
            label.userInteractionEnabled = YES;
            label.tag = 10000 + i*7 + j;
            label.font = [UIFont systemFontOfSize:16];


            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
            [label addGestureRecognizer:tap];
            
            
            [self addSubview:label];
            [self.dayItemViewArray addObject:label];
            
            x += ITEM_WIDTH;
        }
        y += ITEM_HEIGHT;
        
        if (i < 5) {
            CALayer *layer = [CALayer new];
            layer.frame = CGRectMake(0, y, DEVICE_WIDTH, 1);
            layer.backgroundColor = [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1].CGColor;
            [self.layer addSublayer:layer];
            [self.lineViewArray addObject:layer];
        }
        
    }
    
    self.layer.masksToBounds = YES;
}

-(void)tapEvent:(UITapGestureRecognizer *)tap
{
    UILabel *label = (UILabel *)tap.view;
    NSInteger tag = label.tag - 10000;
    
    if (tag >= self.dateArray.count)
    {
        return;
    }
    else
    {
        DayModel *model =  self.dateArray[tag];
        if (model.date.year == 1991) {
            return;
        }
        
        [self.delegate dayItemClick:model.date];
//        model.isSeleted = !model.isSeleted;
//        
//        UIImageView *imageView = self.selectViewArray[tag];
//        if (model.isSeleted) {
//            [UIView animateWithDuration:0.3 animations:^{
//                imageView.alpha = 1;
//            }];
//            label.textColor = [UIColor whiteColor];
//        }
//        else{
//            
//            
//        }
        
     
        
        
    }
}

-(void)updateWithModel:(CalendarMonthModel *) calendarMonthModel
{
    int i = 0;
    self.dateArray = calendarMonthModel.dayDataArray;
    DayModel *lastModel = nil;
    for (DayModel *model in self.dateArray) {
        if ([model.date isLaterThanOrEqualTo:calendarMonthModel.seletedBeginDate] && [model.date isEarlierThanOrEqualTo:calendarMonthModel.seletedEndDate]) {
            model.isSeleted = true;
        }
        else{
            model.isSeleted = false;
        }
        
        if ([model.date isEqualToDate:calendarMonthModel.seletedBeginDate]) {
            model.isSeleted = true;
        }
        
        UILabel *label = self.dayItemViewArray[i];
        //设置今天的label字体颜色
        
        
        
        UIImageView *imageView = self.selectViewArray[i];
        if (model.isSeleted)
        {
            imageView.alpha = 1;
            label.textColor = [UIColor whiteColor];
        }else
        {
            imageView.alpha = 0;
            if (model.isToday)
            {   //867866
                
                label.textColor = HEXCOLOR(0x867866, 1);
            }
            else
            {
#if 0
                if (model.style == CellDayTypeWeek) {
                    label.textColor = HEXCOLOR(0xB9BEC1, 1);
                }
                else
                {
                    label.textColor = HEXCOLOR(0x191919, 1);
                }
#endif
                label.textColor = HEXCOLOR(0x191919, 1);
            }
            
        }
        
        if (model.date.year == 1991) {
            label.text = @"";
            i++;
            continue;
        }
        
        NSString *str = [NSString stringWithFormat:@"%ld",model.date.day];
        label.text = str;
        
        
        
        lastModel = model;
        i++;
    }
    
    
    
    for (int j = i; j < 42; j++) {
 
        UIImageView *imageView = self.selectViewArray[j];
        imageView.alpha = 0;
    }
    
    NSInteger count = self.dayItemViewArray.count;
    

    for (int j=i; j < count; j++) {
        UILabel *label = self.dayItemViewArray[j];
        label.text = @"";
    }
    
    
    //设置下划线
    CGFloat moveX = DEVICE_WIDTH / 7.0 * (calendarMonthModel.date.weekday - 1) + 4;
    if (moveX == 4) {
        moveX = 0;
    }
    self.firstLineLayer.frame = CGRectMake(moveX, 0, DEVICE_WIDTH, 1);
    
    CGFloat num = self.dateArray.count / 7.0;
    int intNum = num;
    
    if (num == (CGFloat)intNum) {
        intNum--;
    }
    
    for (int j=0; j < intNum; j++) {
        CALayer *layer = self.lineViewArray[j];
        layer.hidden = NO;
    }
    
    for (int j = intNum; j < 5; j++) {
        CALayer *layer = self.lineViewArray[j];
        layer.hidden = YES;
    }
    
}

-(id)dayItemViewArray
{
    if(_dayItemViewArray == nil)
    {
        _dayItemViewArray = [NSMutableArray new];
    }
    
    return _dayItemViewArray;
}

-(id)selectViewArray
{
    if(_selectViewArray == nil)
    {
        _selectViewArray = [NSMutableArray new];
    }
    
    return _selectViewArray;
}

-(id)lineViewArray
{
    if(_lineViewArray == nil)
    {
        _lineViewArray = [NSMutableArray new];
    }
    
    return _lineViewArray;
}

@end
