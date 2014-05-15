//
//  ClickerDetailViewController.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 5. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ClickerDetailViewController.h"
#import "BTDateFormatter.h"
#import "BTColor.h"
#import "XYPieChart.h"
#import "BTNotification.h"

@interface ClickerDetailViewController ()

@end

@implementation ClickerDetailViewController
@synthesize post;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backButtonItem];
        self.navigationItem.leftItemsSupplementBackButton = NO;
    }
    return self;
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Navigation title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = post.course.name;
    [titlelabel sizeToFit];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateClicker:) name:ClickerUpdated object:nil];
}

- (void)updateClicker:(NSNotification *)notification {
    if ([notification object] == nil)
        return;
    
    Clicker *clicker = [notification object];
    if (post.clicker.id != clicker.id)
        return;
    
    [post.clicker copyDataFromClicker:clicker];
    [chart reloadData];
    
    NSArray *array = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:3 inSection:0], nil];
    [self.tableview reloadRowsAtIndexPaths:array
                          withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewDidAppear:(BOOL)animated {
    [chart reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0: //message
        {
            UIFont *cellfont = [UIFont boldSystemFontOfSize:14];
            NSString *rawmessage = post.message;
            NSAttributedString *message = [[NSAttributedString alloc] initWithString:rawmessage attributes:@{NSFontAttributeName:cellfont}];
            CGRect MessageLabelSize = [message boundingRectWithSize:(CGSize){200, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
            return ceil(MessageLabelSize.size.height) + 30;
        }
        case 1: //time
            return 30;
        case 2: //ring
            return 270;
        case 3: //detail
            return 70;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: //message
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
            if (cell == nil)
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MessageCell"];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 20, 240, 17)];
            label.font = [UIFont boldSystemFontOfSize:14];
            label.text = post.message;
            label.textColor = [BTColor BT_silver:1];
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.numberOfLines = 0;
            [label sizeToFit];
            label.frame = CGRectMake(40, 20, 240, label.frame.size.height);
            label.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:label];
            
            cell.backgroundColor = [BTColor BT_grey:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 1: //time
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell"];
            if (cell == nil)
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TimeCell"];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 240, 30)];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [BTColor BT_silver:1];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [BTDateFormatter stringFromDate:post.createdAt];
            [cell.contentView addSubview:label];
            
            cell.backgroundColor = [BTColor BT_grey:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 2: //ring
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
            if (cell == nil)
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ImageCell"];
            
            chart = [[XYPieChart alloc] initWithFrame:CGRectMake(40, 24, 240, 240)];
            chart.showLabel = NO;
            chart.pieRadius = 120;
            chart.userInteractionEnabled = NO;
            [chart setDataSource:post.clicker];
            [cell.contentView addSubview:chart];
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(39, 23, 242, 242)];
            [image setImage:[UIImage imageNamed:@"polledge@2x.png"]];
            [cell.contentView addSubview:image];
            
            cell.backgroundColor = [BTColor BT_grey:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 3: //detail
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
            if (cell == nil)
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DetailCell"];
            
            
            UILabel *label;
            for (UIView *view in  cell.contentView.subviews) {
                if ([view isKindOfClass:[UILabel class]]) {
                        label = (UILabel *)view;
                }
            }
            
            if (label == nil) {
                label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
                label.font = [UIFont systemFontOfSize:14];
                label.textColor = [BTColor BT_silver:1];
                label.textAlignment = NSTextAlignmentCenter;
                [cell.contentView addSubview:label];
            }
            
            label.text = [post.clicker detailText];
            
            cell.backgroundColor = [BTColor BT_grey:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        default:
            return nil;
    }
}

@end
