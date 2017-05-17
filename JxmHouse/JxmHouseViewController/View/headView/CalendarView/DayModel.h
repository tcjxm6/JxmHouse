//
//  DayModel.h
//  CalendarTest
//
//  Created by XFXB on 16/8/15.
//  Copyright © 2016年 CalendarTest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DayModel : NSObject

typedef NS_ENUM(NSInteger, CollectionViewCellDayType) {
    CellDayTypeEmpty,   //不显示
    CellDayTypePast,    //过去的日期
    CellDayTypeFutur,   //将来的日期
    CellDayTypeWeek,    //周末
    CellDayTypeClick    //被点击的日期
    
};

@property (nonatomic,strong) NSDate *date;

@property (assign, nonatomic) CollectionViewCellDayType style;//显示的样式

//点击后选择的初始时间
@property (nonatomic,strong) NSDate *seletedBeginDate;
//点击后选择的结束时间
@property (nonatomic,strong) NSDate *seletedEndDate;

@property (nonatomic,assign) BOOL isSeleted;
@property (nonatomic,assign) BOOL isToday;
@end
