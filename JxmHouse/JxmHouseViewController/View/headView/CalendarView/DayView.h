//
//  DayView.h
//  CalendarTest
//
//  Created by XFXB on 16/8/12.
//  Copyright © 2016年 CalendarTest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarMonthModel.h"
@protocol DayViewClickEventDelegate<NSObject>

-(void)dayItemClick:(NSDate *)date;

@end

@interface DayView : UIView



@property (nonatomic,weak) id<DayViewClickEventDelegate> delegate;
-(void)updateWithModel:(CalendarMonthModel *) calendarMonthModel;

@end
