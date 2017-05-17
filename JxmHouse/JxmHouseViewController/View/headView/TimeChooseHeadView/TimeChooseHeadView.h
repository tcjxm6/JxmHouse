//
//  TimeChooseHeadView.h
//  XFOldDriver
//
//  Created by XFXB on 16/5/16.
//  Copyright © 2016年 XFOldDriver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeChooseHeadView : UIView

typedef void (^CallbackBLock)(NSString *beginTime,NSString *endTime);
@property (nonatomic,strong) CallbackBLock callback;

@property (nonatomic,strong) NSString *beginTime;
@property (nonatomic,strong) NSString *endTime;

@property (strong, nonatomic)  UITextField *beginTextField;
@property (strong, nonatomic)  UITextField *endTextField;

@property (weak, nonatomic) IBOutlet UILabel *beginLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@end
