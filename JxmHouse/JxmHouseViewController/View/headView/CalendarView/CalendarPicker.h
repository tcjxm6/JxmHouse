//
//  CalendarPicker.h
//  CalendarTest
//
//  Created by XFXB on 16/8/11.
//  Copyright © 2016年 CalendarTest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarMonthModel.h"
@interface CalendarPicker : UIView

typedef void (^ChooseTimeBlock)(NSDate *begin,NSDate *end);
//点击后选择的初始时间
@property (nonatomic,strong) NSDate *seletedBeginDate;
//点击后选择的结束时间
@property (nonatomic,strong) NSDate *seletedEndDate;

@property (nonatomic,strong) ChooseTimeBlock chooseTimeBlock;


//初始化开始时间和结束时间
-(id)initWithBeginTime:(NSDate *)beginDate endTime:(NSDate *)endDate;

-(void)scrollDeep;

@end
