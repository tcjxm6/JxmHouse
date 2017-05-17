//
//  CalendarMonthModel.m
//  CalendarTest
//
//  Created by XFXB on 16/8/11.
//  Copyright © 2016年 CalendarTest. All rights reserved.
//

#import "CalendarMonthModel.h"
#import "DayModel.h"
@interface CalendarMonthModel()



@end

@implementation CalendarMonthModel



-(id)initWithDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        self.date = date;
        [self initSome];
    }
    return self;
}

-(void)initSome
{
    NSDate *now = [NSDate date];

    //计算item的高度
    self.date = [NSDate dateWithYear:self.date.year month:self.date.month day:1];
    NSInteger weekday = self.date.weekday;
    NSInteger daysInMonth = self.date.daysInMonth;
    daysInMonth += (weekday - 1);
    
    CGFloat weeks = (CGFloat)daysInMonth / 7.0;
    NSInteger intWeek = weeks;
    
    if (weeks > (CGFloat)intWeek) {
        intWeek++;
    }
    
    self.itemSize = CGSizeMake(DEVICE_WIDTH, ITEM_TITLE_HEIGHT + ITEM_HEIGHT * intWeek);
//    NSLog(@"这里是%ld月份，有%ld个days  weekday = %ld",self.date.month,daysInMonth,weekday);
    //计算item里面的数据内容
    NSMutableArray *arr = [NSMutableArray new];
    int day = 1;
    for (int i = 0; i < daysInMonth; i++) {

        DayModel *model = [DayModel new];
        if (i < weekday-1) {
            model.style = CellDayTypeEmpty;
            model.date = [NSDate dateWithYear:1991 month:02 day:27];
            model.isSeleted = false;
            [arr addObject:model];
        }else
        {
            model.date = [NSDate dateWithYear:self.date.year month:self.date.month day:day];
            if (model.date.year == now.year && model.date.month == now.month & model.date.day == now.day) {
                model.isToday = true;
            }
            if (model.date.isWeekend) {
                model.style = CellDayTypeWeek;
            }
            model.isSeleted = false;
            [arr addObject:model];
            day++;
        }
        
    }
    
    self.dayDataArray = arr.copy;
}

-(void)initDayDataArray
{
    
}

#pragma lazyload







@end
