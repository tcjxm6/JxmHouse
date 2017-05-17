//
//  CalendarCell.h
//  CalendarTest
//
//  Created by XFXB on 16/8/12.
//  Copyright © 2016年 CalendarTest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarMonthModel.h"
#import "DayView.h"



@interface CalendarCell : UICollectionViewCell

@property (nonatomic,strong) DayView *dayView;
-(void)updateWithModel:(CalendarMonthModel *)model;
@end
