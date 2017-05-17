//
//  CalendarMonthModel.h
//  CalendarTest
//
//  Created by XFXB on 16/8/11.
//  Copyright © 2016年 CalendarTest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTools.h"

#define ITEM_WIDTH (DEVICE_WIDTH / 7)
#define ITEM_HEIGHT ((ITEM_WIDTH) + 5)
#define ITEM_TITLE_HEIGHT 50


@interface CalendarMonthModel : NSObject

//每个月份cell的高度，宽
@property (nonatomic,assign) CGSize itemSize;
//每天的DayModel数组
@property (nonatomic,strong) NSArray *dayDataArray;
//月份初始化时间
@property (nonatomic,strong) NSDate *date;
//点击后选择的初始时间
@property (nonatomic,strong) NSDate *seletedBeginDate;
//点击后选择的结束时间
@property (nonatomic,strong) NSDate *seletedEndDate;



-(id)initWithDate:(NSDate *)date;

@end
