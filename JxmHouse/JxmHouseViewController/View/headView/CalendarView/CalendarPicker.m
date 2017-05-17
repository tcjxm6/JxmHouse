//
//  CalendarPicker.m
//  CalendarTest
//
//  Created by XFXB on 16/8/11.
//  Copyright © 2016年 CalendarTest. All rights reserved.
//

#import "CalendarPicker.h"
#import "CalendarCell.h"

@interface CalendarPicker ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DayViewClickEventDelegate>


@property (nonatomic,strong) NSDate *beginDate;
@property (nonatomic,strong) NSDate *endDate;
@property (nonatomic,strong) NSArray *calendarDataArray;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIView *headView;
@end

@implementation CalendarPicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.frame;
    rect.origin.x = 0;
    rect.origin.y = 20;
    rect.size.height -= 20;
    self.collectionView.frame = rect;
    self.backgroundColor = [UIColor blueColor];
    [self.collectionView reloadData];
    [self headView].frame = CGRectMake(0, 0, DEVICE_WIDTH, 20);
}

-(id)initWithBeginTime:(NSDate *)beginDate endTime:(NSDate *)endDate
{
    self = [super init];
    if (self) {
        
        self.beginDate = beginDate;
        self.endDate = endDate;
        [self initView];
        [self setCalendarData];
        [[self collectionView] reloadData];
    }
    return self;
}

-(void)initView
{
    [self headView];
    

    
    
}


-(void)setCalendarData
{
    NSMutableArray *arr = [NSMutableArray new];
    
    NSDate *begin = self.beginDate;
    
    if ([self.beginDate isLaterThan:self.endDate]) {
        return;
    }
    
    while ([begin isEarlierThanOrEqualTo:self.endDate]) {
        CalendarMonthModel *model = [[CalendarMonthModel alloc] initWithDate:begin];
        
        [arr addObject:model];
        
        begin = [begin dateByAddingMonths:1];
    }

    
    self.calendarDataArray = arr.copy;
    
    
    
    
}

-(void)dayItemClick:(NSDate *)date
{
//    NSLog(@"点击了%ld - %ld",date.month,date.day);
    
    if (self.seletedBeginDate && self.seletedEndDate) {
        self.seletedBeginDate = date;
        self.seletedEndDate = nil;
        [self.collectionView reloadData];
        if (self.chooseTimeBlock) {
            self.chooseTimeBlock(self.seletedBeginDate,self.seletedEndDate);
        }
        return;
    }
    
    if (self.seletedBeginDate == nil)
    {
        self.seletedBeginDate = date;
    }
    else if (self.seletedEndDate == nil)
    {
        if ([date isEarlierThan:self.seletedBeginDate])
        {
            self.seletedEndDate = self.seletedBeginDate;
            self.seletedBeginDate = date;
        }
        else
        {
            self.seletedEndDate = date;
        }
    }
    
    [self.collectionView reloadData];
    
    if (self.chooseTimeBlock) {
        self.chooseTimeBlock(self.seletedBeginDate,self.seletedEndDate);
    }
//    NSLog(@"设置开始：%ld - %ld\n设置结束:%ld - %ld",self.seletedBeginDate.month,self.seletedBeginDate.day,self.seletedEndDate.month,self.seletedEndDate.day);
}


-(void)scrollDeep
{
//    [self.collectionView scrollToBottomAnimated:NO];
   
}
#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.calendarDataArray.count;
}

-(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.dayView.delegate = self;
    
    CalendarMonthModel *model = self.calendarDataArray[indexPath.row];
    model.seletedBeginDate = self.seletedBeginDate;
    model.seletedEndDate = self.seletedEndDate;
    [cell updateWithModel:model];
    return cell;
}



#pragma UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarMonthModel *model = self.calendarDataArray[indexPath.row];
    return model.itemSize;
}

//配置item的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 20, 0);
}

#pragma lazyload

-(id)headView
{
    if(_headView == nil)
    {
        NSArray *arr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        _headView = [UIView new];
        _headView.frame = CGRectMake(0, 0, DEVICE_WIDTH, 20);
        _headView.backgroundColor = [UIColor whiteColor];
        CGFloat width = DEVICE_WIDTH / 7.0;
        for (int i = 0; i < 7; i++) {
            UILabel *label = [UILabel new];
            label.frame = CGRectMake(i*width, 0, width, 20);
            label.text = arr[i];
            if (i == 0 || i == 6) {
                label.textColor = HEXCOLOR(0xB9BEC1, 1);
            }
            else
            {
                label.textColor = HEXCOLOR(0x191919, 1);
            }
            
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            [_headView addSubview:label];
        }
        [self addSubview:_headView];
    }
    
    return _headView;
}

-(id)collectionView
{
    if(_collectionView == nil)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, DEVICE_WIDTH, 1) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        [self addSubview:_collectionView];
        
       

    }
    
    return _collectionView;
}

@end
