//
//  ViewController.m
//  MultiColumnTableView
//
//  Created by DCQ on 2017/10/17.
//  Copyright © 2017年 ZNXZ. All rights reserved.
//

#import "ViewController.h"
#import "EWMultiColumnTableView.h"

@interface ViewController ()<EWMultiColumnTableViewDataSource> {
    
    NSMutableArray *data;
    NSMutableArray *sectionHeaderData;
    
    CGFloat colWidth;
    NSInteger numberOfSections;
    NSInteger numberOfColumns;
    
    EWMultiColumnTableView *tblView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    numberOfColumns = 5;
    numberOfSections = 5;
    
    int sectionDistro[] = {5, 7, 4, 9, 2};
    colWidth = 240.0f;
    
    data = [[NSMutableArray alloc] initWithCapacity:numberOfSections * 5];
    sectionHeaderData = [[NSMutableArray alloc] initWithCapacity:numberOfSections];
    
    for (int i = 0; i < numberOfSections; i++) {
        
        int rows = sectionDistro[i];
        NSMutableArray *a = [NSMutableArray arrayWithCapacity:numberOfColumns];
        for (int j = 0; j < numberOfColumns; j++) {
            
            int d = rand() % 100;
            
            NSMutableString *text = [NSMutableString stringWithFormat:@"S %d C %d", i, j];
            if (d < 66) {
                [text appendFormat:@"\nsecond line"];
            }
            
            if (d < 33) {
                [text appendFormat:@"\nthird line"];
            }
            
            
            [a addObject:text];
        }
        [sectionHeaderData addObject:a];
        
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:10];
        for (int k = 0; k < rows; k++) {
            
            NSMutableArray *rowArray = [NSMutableArray arrayWithCapacity:numberOfColumns];
            for (int j = 0; j < numberOfColumns; j++) {
                int d = rand() % 100;
                
                NSMutableString *text = [NSMutableString stringWithFormat:@"(%d, %d, %d)", i, k, j];
                if (d < 66) {
                    [text appendFormat:@"\nsecond line"];
                }
                
                if (d < 33) {
                    [text appendFormat:@"\nthird line"];
                }
                
                [rowArray addObject:text];
            }
            
            [sectionArray addObject:rowArray];
        }
        
        [data addObject:sectionArray];
    }
    
    
    tblView = [[EWMultiColumnTableView alloc] initWithFrame:CGRectInset(self.view.bounds, 5.0f, 5.0f)];
    tblView.sectionHeaderEnabled = YES;
    //    tblView.cellWidth = 100.0f;
    //    tblView.boldSeperatorLineColor = [UIColor blueColor];
    //    tblView.normalSeperatorLineColor = [UIColor blueColor];
    //    tblView.boldSeperatorLineWidth = 10.0f;
    //    tblView.normalSeperatorLineWidth = 10.0f;
    tblView.dataSource = self;
    tblView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:tblView];
    
    [self performBlock:^{
        
        [tblView scrollToColumn:3 position:EWMultiColumnTableViewColumnPositionMiddle animated:YES];
    } afterDelay:0.5];
}

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    int64_t delta = (int64_t)(1.0e9 * delay);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), block);
}

#pragma mark - EWMultiColumnTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(EWMultiColumnTableView *)tableView
{
    return numberOfSections;
}

- (UIView *)tableView:(EWMultiColumnTableView *)tableView cellForIndexPath:(NSIndexPath *)indexPath column:(NSInteger)col
{
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, colWidth, 40.0f)];
    l.numberOfLines = 0;
    l.lineBreakMode = UILineBreakModeWordWrap;
    
    return l;
}


- (void)tableView:(EWMultiColumnTableView *)tableView setContentForCell:(UIView *)cell indexPath:(NSIndexPath *)indexPath column:(NSInteger)col{
    UILabel *l = (UILabel *)cell;
    l.text = [[[data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:col];
    
    CGRect f = l.frame;
    f.size.width = [self tableView:tableView widthForColumn:col];
    l.frame = f;
    
    [l sizeToFit];
}

- (CGFloat)tableView:(EWMultiColumnTableView *)tableView heightForCellAtIndexPath:(NSIndexPath *)indexPath column:(NSInteger)col
{
    NSString *str = [[[data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectAtIndex:col];
    CGSize s = [str sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]
               constrainedToSize:CGSizeMake([self tableView:tableView widthForColumn:col], MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    
    return s.height + 20.0f;
}

- (CGFloat)tableView:(EWMultiColumnTableView *)tableView widthForColumn:(NSInteger)column
{
    return colWidth;
}

- (NSInteger)tableView:(EWMultiColumnTableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[data objectAtIndex:section] count];
}

- (UIView *)tableView:(EWMultiColumnTableView *)tableView sectionHeaderCellForSection:(NSInteger)section column:(NSInteger)col
{
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [self tableView:tableView widthForColumn:col], 40.0f)];
    l.backgroundColor = [UIColor yellowColor];
    return l;
}

- (void)tableView:(EWMultiColumnTableView *)tableView setContentForSectionHeaderCell:(UIView *)cell section:(NSInteger)section column:(NSInteger)col
{
    UILabel *l = (UILabel *)cell;
    l.text = [NSString stringWithFormat:@"S %d C %d", section, col];
    
    CGRect f = l.frame;
    f.size.width = [self tableView:tableView widthForColumn:col];
    l.frame = f;
    
    [l sizeToFit];
}

- (NSInteger)numberOfColumnsInTableView:(EWMultiColumnTableView *)tableView
{
    return numberOfColumns;
}

#pragma mark Header Cell

- (UIView *)tableView:(EWMultiColumnTableView *)tableView headerCellForIndexPath:(NSIndexPath *)indexPath
{
    return [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 40.0f)];
}

- (void)tableView:(EWMultiColumnTableView *)tableView setContentForHeaderCell:(UIView *)cell atIndexPath:(NSIndexPath *)indexPath
{
    UILabel *l = (UILabel *)cell;
    l.text = [NSString stringWithFormat:@"Line: (%d, %d)", indexPath.section, indexPath.row];
}

- (CGFloat)tableView:(EWMultiColumnTableView *)tableView heightForHeaderCellAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (CGFloat)tableView:(EWMultiColumnTableView *)tableView heightForSectionHeaderCellAtSection:(NSInteger)section column:(NSInteger)col
{
    return 50.0f;
}

- (UIView *)tableView:(EWMultiColumnTableView *)tableView headerCellInSectionHeaderForSection:(NSInteger)section
{
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [self widthForHeaderCellOfTableView:tableView], 30.0f)];
    l.backgroundColor = [UIColor orangeColor];
    return l;
    
}

- (void)tableView:(EWMultiColumnTableView *)tableView setContentForHeaderCellInSectionHeader:(UIView *)cell AtSection:(NSInteger)section
{
    UILabel *l = (UILabel *)cell;
    l.text = [NSString stringWithFormat:@"Section %d", section];
}

- (CGFloat)widthForHeaderCellOfTableView:(EWMultiColumnTableView *)tableView
{
    return 200.0f;
}


- (UIView *)tableView:(EWMultiColumnTableView *)tableView headerCellForColumn:(NSInteger)col
{
    UILabel *l =  [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 250.0f, 300.0f)] ;
    l.text = [NSString stringWithFormat:@"Column: %d", col];
    l.userInteractionEnabled = YES;
    
    l.tag = col;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    recognizer.numberOfTapsRequired = 2;
    [l addGestureRecognizer:recognizer];
    
    return l;
}

- (UIView *)topleftHeaderCellOfTableView:(EWMultiColumnTableView *)tableView
{
    UILabel *l =  [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 250.0f, [self heightForHeaderCellOfTableView:tableView])];
    l.text = @"Products";
    
    return l;
}

- (CGFloat)heightForHeaderCellOfTableView:(EWMultiColumnTableView *)tableView
{
    return 300.0f;
}

- (void)tableView:(EWMultiColumnTableView *)tableView swapDataOfColumn:(NSInteger)col1 andColumn:(NSInteger)col2
{
    for (int i = 0; i < [self numberOfSectionsInTableView:tableView]; i++) {
        NSMutableArray *section = [data objectAtIndex:i];
        for (int j = 0; j < [self tableView:tableView numberOfRowsInSection:i]; j++) {
            NSMutableArray *a = [section objectAtIndex:j];
            id tmp = [a objectAtIndex:col2];
            
            [a replaceObjectAtIndex:col2 withObject:[a objectAtIndex:col1]];
            [a replaceObjectAtIndex:col1 withObject:tmp];
            
        }
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    int col = [recognizer.view tag];
    for (NSMutableArray *array in sectionHeaderData) {
        [array removeObjectAtIndex:col];
        //        [array addObject:@""];
    }
    
    for (NSMutableArray *section in data) {
        for (NSMutableArray *row in section) {
            [row removeObjectAtIndex:col];
            //            [row addObject:@""];
        }
    }
    
    numberOfColumns--;
    
    [tblView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
