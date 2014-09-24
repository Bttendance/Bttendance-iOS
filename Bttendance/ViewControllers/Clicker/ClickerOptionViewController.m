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
#import "NumberOptionCell.h"
#import "NumberPadDoneBtn.h"

@interface ClickerOptionViewController ()
@property (strong, nonatomic) NumberOptionCell *numberOptionCell;
@property (strong, nonatomic) NumberPadDoneBtn *numberPadDoneBtn;
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
    
    static NSString *CellIdentifier = @"NumberOptionCell";
    self.numberOptionCell = [super.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.numberOptionCell == nil) {
        [super.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
        self.numberOptionCell = [super.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        self.numberOptionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    self.numberOptionCell.title.text = NSLocalizedString(@"직접 설정", nil);
    self.numberPadDoneBtn = [[NumberPadDoneBtn alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.numberOptionCell.title.inputAccessoryView = self.numberPadDoneBtn;
    self.numberOptionCell.title.tintColor = [UIColor silver:1.0];
    self.numberOptionCell.title.delegate = self;
    
    if (self.progressTime == 60)
        [super.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    else if (self.progressTime == 120)
        [super.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    else if (self.progressTime == 180)
        [super.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    else {
        [super.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        self.numberOptionCell.title.text = [NSString stringWithFormat:NSLocalizedString(@"직접 설정 (%d초)", nil), self.progressTime];
    }
    
    if (self.showInfoOnSelect)
        [super.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    else
        [super.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    if ([self.detailPrivacy isEqualToString:@"all"])
        [super.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    else if ([self.detailPrivacy isEqualToString:@"professor"])
        [super.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    else
        [super.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

#pragma NavigationBarAction
- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [super.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES];
    [super.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES];
    [super.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] animated:YES];
    [super.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 13;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0
        || indexPath.row == 5
        || indexPath.row == 8)
        return 48;
    
    if (indexPath.row == 12)
        return 33;
    
    return 47;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0
        || indexPath.row == 5
        || indexPath.row == 8) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 26, 320, 12)];
        switch (indexPath.row) {
            case 0:
                label.text = NSLocalizedString(@"설문 수집 시간", nil);
                break;
            case 5:
                label.text = NSLocalizedString(@"설문이 진행중일 때 실시간 결과를 학생들에게", nil);
                break;
            case 8:
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
    } else if (indexPath.row == 4) {
        return self.numberOptionCell;
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
                cell.title.text = NSLocalizedString(@"1분", nil);
                break;
            case 2:
                cell.title.text = NSLocalizedString(@"2분", nil);
                break;
            case 3:
                cell.title.text = NSLocalizedString(@"3분", nil);
                break;
            case 6:
                cell.title.text = NSLocalizedString(@"보여주기", nil);
                break;
            case 7:
                cell.title.text = NSLocalizedString(@"보여주지 않기", nil);
                break;
            case 9:
                cell.title.text = NSLocalizedString(@"모두 보기", nil);
                break;
            case 10:
                cell.title.text = NSLocalizedString(@"교수님만 보기", nil);
                break;
            case 11:
                cell.title.text = NSLocalizedString(@"아무도 못보게 하기", nil);
                break;
        }
        return cell;
    }
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1: //1분
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES];
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] animated:YES];
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] animated:YES];
            break;
        case 2: //2분
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES];
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] animated:YES];
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] animated:YES];
            break;
        case 3: //3분
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES];
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES];
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] animated:YES];
            break;
        case 4: //직접 설정
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES];
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES];
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] animated:YES];
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            [self.numberOptionCell.title becomeFirstResponder];
            break;
        case 6: //보여주기
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0] animated:YES];
            break;
        case 7: //보여주지 않기
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] animated:YES];
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            break;
        case 9: //모두 보기
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0] animated:YES];
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0] animated:YES];
            break;
        case 10: //교수님만 보기
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0] animated:YES];
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0] animated:YES];
            break;
        case 11: //아무도 못보게 하기
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0] animated:YES];
            [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0] animated:YES];
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            break;
        default:
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
    }
    
    [self updateClickerOption];
}

#pragma ClickerOptionViewControllerDelegate
- (void)updateClickerOption {
    NSArray *selectedRows = [super.tableView indexPathsForSelectedRows];
    for (NSIndexPath *indexPath in selectedRows) {
        switch (indexPath.row) {
            case 1: //1분
                self.progressTime = 60;
                break;
            case 2: //2분
                self.progressTime = 120;
                break;
            case 3: //3분
                self.progressTime = 180;
                break;
            case 4: //직접 설정
                break;
            case 6: //보여주기
                self.showInfoOnSelect = YES;
                break;
            case 7: //보여주지 않기
                self.showInfoOnSelect = NO;
                break;
            case 9: //모두 보기
                self.detailPrivacy = @"all";
                break;
            case 10: //교수님만 보기
                self.detailPrivacy = @"professor";
                break;
            case 11: //아무도 못보게 하기
                self.detailPrivacy = @"none";
                break;
        }
    }
    [self.delegate chosenOptionTime:self.progressTime andOnSelect:self.showInfoOnSelect andDetail:self.detailPrivacy];
}

@end
