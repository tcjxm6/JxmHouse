//
//  DayChooseView.m
//  XFOldDriver
//
//  Created by XFXB on 16/5/16.
//  Copyright © 2016年 XFOldDriver. All rights reserved.
//

#import "DayChooseView.h"
#import "DateTools.h"
#import <Masonry/Masonry.h>

//#import <JCRBlurView.h>
@interface DayChooseView ()

@property (nonatomic,strong) CalendarPicker *calendarPicker;
@property (nonatomic,strong) UIView *navgationBar;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *commitView;

@end

@implementation DayChooseView

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
        [self xf_setupViews];
    }
    return self;
}

- (void)xf_setupViews {
    self.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    self.backgroundColor = [UIColor whiteColor];
    [self calendarPicker];
    [self navgationBar];
    [self headView];
    [self commitView];
    
}


-(void)show
{
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self];
    [self showPickerViewWithAnimate];
    
}

-(void)showPickerViewWithAnimate
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.calendarPicker scrollDeep];
    });
    self.calendarPicker.alpha = 0.5;
    self.calendarPicker.transform = CGAffineTransformMakeTranslation(0, (DEVICE_HEIGHT - 64 -55 - 44));
    
    self.titleLabel.alpha = 0.2;
    [UIView animateWithDuration:0.65 animations:^{
        self.calendarPicker.alpha = 1;
        self.titleLabel.alpha = 1;
        self.calendarPicker.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hide
{
    
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


-(id)calendarPicker
{
    if(_calendarPicker == nil)
    {
        NSDate *now = [NSDate date];
        NSDate *beginDate = [now dateBySubtractingYears:1];
        beginDate = [NSDate dateWithYear:beginDate.year month:beginDate.month day:beginDate.day];
        NSDate *endDate = [NSDate dateWithYear:now.year month:now.month day:now.day];
        CGFloat y = 64 + 65;
        _calendarPicker = [[CalendarPicker alloc] initWithBeginTime:beginDate endTime:endDate];
        _calendarPicker.frame = CGRectMake(0, y, DEVICE_WIDTH, DEVICE_HEIGHT - y - 44);
        WS(ws);
        _calendarPicker.chooseTimeBlock = ^(NSDate *begin,NSDate *end){
            ws.headView.beginLabel.text = [NSString stringWithFormat:@"%ld.%02ld.%02ld",begin.year,begin.month,begin.day];
            if (end) {
                ws.headView.endLabel.text = [NSString stringWithFormat:@"%ld.%02ld.%02ld",end.year,end.month,end.day];
            }else{
                ws.headView.endLabel.text = @"-";
            }
        };
        [self addSubview:_calendarPicker];
        
    }
    
    return _calendarPicker;
}

-(id)navgationBar
{
    if(_navgationBar == nil)
    {
        _navgationBar = [UIView new];
        _navgationBar.frame = CGRectMake(0, 0, DEVICE_WIDTH, 64);
        [self addSubview:_navgationBar];
        
        
        UILabel *label = [UILabel new];
        label.text = @"选择日期";
        label.font = [UIFont boldSystemFontOfSize:16];
        label.frame = CGRectMake(0, 20, DEVICE_WIDTH, 44);
        label.textAlignment = NSTextAlignmentCenter;
        self.titleLabel = label;
        [_navgationBar addSubview:label];
        
        UIButton *cancel = [[UIButton alloc] init];
        CGFloat width = 50;
        cancel.frame = CGRectMake(DEVICE_WIDTH - width - 10, 20, width, 44);
        [cancel setTitleColor:HEXCOLOR(0x867866, 1) forState:UIControlStateNormal];
        cancel.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(cancelEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [_navgationBar addSubview:cancel];
        
        //分割线
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 63.5, DEVICE_WIDTH, 0.5);
        view.backgroundColor = HEXCOLOR(0x000000, 0.5);
        [_navgationBar addSubview:view];
        
    }
    
    return _navgationBar;
}

-(void)cancelEvent:(UIButton *)sender {
    [self hide];
}


-(id)headView
{
    if(_headView == nil)
    {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TimeChooseHeadView" owner:nil options:nil];
        _headView = [nibContents lastObject];
        _headView.userInteractionEnabled = NO;
        _headView.frame = CGRectMake(0, 64, DEVICE_WIDTH, 68);
        [self addSubview:_headView];
        
    }
    
    return _headView;
}


-(id)commitView
{
    if(_commitView == nil)
    {
        _commitView = [UIButton new];
        _commitView.backgroundColor = [UIColor whiteColor];
        
        [_commitView setTitle:@"查找" forState:UIControlStateNormal];
        [_commitView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitView setBackgroundColor:HEXCOLOR(0x867866, 1)];
        _commitView.layer.cornerRadius = 22;
        _commitView.layer.masksToBounds = YES;
//        _commitView.layer.borderColor = COLOR_XF_BKG.CGColor;
//        _commitView.layer.borderWidth = 1;
        _commitView.titleLabel.font = [UIFont systemFontOfSize:16];
        
        //        _commitView.titleLabel.textColor = HEXCOLOR(0xF12E51, 1);
        
        [self addSubview:_commitView];
        WS(ws);
        [_commitView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ws).offset(-5);
            make.left.equalTo(ws).offset(8);
            make.right.equalTo(ws).offset(-8);
            make.height.mas_equalTo(44);
        }];
        
        [_commitView addTarget:self  action:@selector(commitEvent:) forControlEvents:UIControlEventTouchUpInside];

        
    }
    
    return _commitView;
}

-(void)commitEvent:(UIButton *)sender
{
    if ([self.headView.endLabel.text isEqualToString:@"-"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请选择一个时间段" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
        return ;
    }
    
    if (self.choose) {
        self.choose(self.headView.beginLabel.text,self.headView.endLabel.text);
    }
    [self hide];
}


@end
