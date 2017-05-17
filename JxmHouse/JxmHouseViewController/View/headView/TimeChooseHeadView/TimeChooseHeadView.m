//
//  TimeChooseHeadView.m
//  XFOldDriver
//
//  Created by XFXB on 16/5/16.
//  Copyright © 2016年 XFOldDriver. All rights reserved.
//

#import "TimeChooseHeadView.h"
#import "DayChooseView.h"

@interface TimeChooseHeadView ()

@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation TimeChooseHeadView





- (void)awakeFromNib {
    // Initialization code
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    self.endLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    self.beginLabel.text = [dateFormatter stringFromDate:[NSDate date]];
    
    self.backView.layer.shadowColor = HEXCOLOR(0x000000, 0.2).CGColor;
    self.backView.layer.shadowOffset = CGSizeMake(0,1);
    self.backView.layer.shadowOpacity = 1;
    self.backView.layer.shadowRadius = 4;
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.beginTextField = [UITextField new];
    self.endTextField = [UITextField new];
    self.beginTextField.text = [dateFormatter stringFromDate:[NSDate date]];
    self.endTextField.text = [dateFormatter stringFromDate:[NSDate date]];
    
    [super awakeFromNib];
}

-(BOOL)isRightTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *beginTime = [dateFormatter dateFromString:self.beginTextField.text];
    NSDate *endTime = [dateFormatter dateFromString:self.endTextField.text];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = kCFCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:beginTime  toDate:endTime  options:0];
    NSInteger day = [comps day];
    if (day >=0 ) {
        return true;
    }
    else{
        return false;
    }
    
}

-(void)setMaxDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *beginTime = [dateFormatter dateFromString:self.beginTextField.text];
    NSDate *endTime = [dateFormatter dateFromString:self.endTextField.text];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = kCFCalendarUnitMonth;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:beginTime  toDate:endTime  options:0];
    NSInteger day = [comps month];
    
    
    if (day > 3) {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setMonth:-3];
        
        NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        beginTime = [calender dateByAddingComponents:comps toDate:endTime options:0];

        self.beginTextField.text = [dateFormatter stringFromDate:beginTime];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"查询时间限三个月内!" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)beginTimeEvent:(id)sender {
    
    
    DayChooseView *view = [DayChooseView new];
    [view show];
    view.headView.beginLabel.text = self.beginLabel.text;
    view.headView.endLabel.text = self.endLabel.text;
    WS(ws);
    view.choose = ^(NSString *begin,NSString *end){
        ws.beginLabel.text = begin;
        ws.endLabel.text = end;
        NSString *_begin = [begin stringByReplacingOccurrencesOfString:@"." withString:@"-"];
        ws.beginTextField.text = _begin;
        NSString *_end = [end stringByReplacingOccurrencesOfString:@"." withString:@"-"];
        ws.endTextField.text = _end;
        if (ws.callback) {
            ws.callback(_begin,_end);
        }
    };
}


- (IBAction)searchEvent:(id)sender {
    if (![self isRightTime]) {
        NSString *text = self.endTextField.text;
        self.endTextField.text = self.beginTextField.text;
        self.beginTextField.text = text;
    }
    
    [self setMaxDate];
    
    if (self.callback) {
        self.callback(self.beginTextField.text,self.endTextField.text);
    }
}

@end
