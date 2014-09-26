//
//  ClickerOptionViewController.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 9. 17..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ClickerOptionViewController.h"
#import "UIColor+Bttendance.h"
#import "OptionCell.h"

@interface ClickerOptionViewController ()
@end

@implementation ClickerOptionViewController

- (void)viewDidLoad
{
    //Navigation title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"설문 옵션", nil);
    [titlelabel sizeToFit];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = NO;
    
    super.tableView.backgroundColor = [UIColor grey:1.0];
    super.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    super.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    super.tableView.allowsMultipleSelection = YES;
    
    [self updateSelection];
}

#pragma NavigationBarAction
- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 13;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0
        || indexPath.row == 4
        || indexPath.row == 7)
        return 48;
    
    if (indexPath.row == 12)
        return 33;
    
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0
        || indexPath.row == 4
        || indexPath.row == 7) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 26, 320, 12)];
        switch (indexPath.row) {
            case 0:
                label.text = NSLocalizedString(@"설문 수집 시간", nil);
                break;
            case 4:
                label.text = NSLocalizedString(@"설문이 진행중일 때 실시간 결과를 학생들에게", nil);
                break;
            case 7:
                label.text = NSLocalizedString(@"누가 어떤 답변을 선택했는지", nil);
                break;
        }
        label.textColor = [UIColor silver:1.0];
        label.font = [UIFont systemFontOfSize:12];
        [cell addSubview:label];
        return cell;
    } else if (indexPath.row == 12) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 33)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor grey:1.0];
        return cell;
    } else {
        static NSString *CellIdentifier = @"OptionCell";
        OptionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        switch (indexPath.row) {
            case 1:
                cell.title.text = NSLocalizedString(@"모두 보기", nil);
                break;
            case 2:
                cell.title.text = NSLocalizedString(@"강의자만 보기", nil);
                break;
            case 3:
                cell.title.text = NSLocalizedString(@"아무도 못보게 하기", nil);
                break;
            case 5:
                cell.title.text = NSLocalizedString(@"보여주기", nil);
                break;
            case 6:
                cell.title.text = NSLocalizedString(@"보여주지 않기", nil);
                break;
            case 8:
                cell.title.text = NSLocalizedString(@"1분", nil);
                break;
            case 9:
                cell.title.text = NSLocalizedString(@"2분", nil);
                break;
            case 10:
                cell.title.text = NSLocalizedString(@"3분", nil);
                break;
            case 11:
                cell.title.text = NSLocalizedString(@"5분", nil);
                break;
        }
        return cell;
    }
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1: //모두 보기
            self.detailPrivacy = @"all";
            break;
        case 2: //강의자만 보기
            self.detailPrivacy = @"professor";
            break;
        case 3: //아무도 못보게 하기
            self.detailPrivacy = @"none";
            break;
        case 5: //보여주기
            self.showInfoOnSelect = YES;
            break;
        case 6: //보여주지 않기
            self.showInfoOnSelect = NO;
            break;
        case 8: //1분
            self.progressTime = 60;
            break;
        case 9: //2분
            self.progressTime = 120;
            break;
        case 10: //3분
            self.progressTime = 180;
            break;
        case 11: //5분
            self.progressTime = 300;
            break;
        default:
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
    }
    
    [self updateSelection];
    [self.delegate chosenOptionTime:self.progressTime andOnSelect:self.showInfoOnSelect andDetail:self.detailPrivacy];
}

#pragma Private Methods
- (void)updateSelection {
    [super.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES];
    [super.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES];
    [super.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] animated:YES];
    [super.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] animated:YES];
    [super.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] animated:YES];
    [super.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0] animated:YES];
    [super.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0] animated:YES];
    [super.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0] animated:YES];
    [super.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0] animated:YES];
    
    if ([self.detailPrivacy isEqualToString:@"all"])
        [super.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    else if ([self.detailPrivacy isEqualToString:@"professor"])
        [super.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    else
        [super.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    if (self.showInfoOnSelect)
        [super.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    else
        [super.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    if (self.progressTime == 60)
        [super.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    else if (self.progressTime == 120)
        [super.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    else if (self.progressTime == 180)
        [super.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    else
        [super.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

@end
