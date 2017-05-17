//
//  DayChooseView.h
//  XFOldDriver
//
//  Created by XFXB on 16/5/16.
//  Copyright © 2016年 XFOldDriver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarPicker.h"
#import "TimeChooseHeadView.h"

@interface DayChooseView : UIView

typedef void (^ChooseBLock)(NSString *beginTime,NSString *endTime);

@property (nonatomic,strong) ChooseBLock choose;
@property (nonatomic,strong) TimeChooseHeadView *headView;

-(void)show;
-(void)hide;

@end
