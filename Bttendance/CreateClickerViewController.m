//
//  CreateClickerViewController.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 29..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "CreateClickerViewController.h"
#import "BTUserDefault.h"
#import <AFNetworking/AFNetworking.h>
#import "BTAPIs.h"
#import "BTColor.h"
#import "ChooseCountCell.h"
#import "SignButtonCell.h"
#import "PasswordCell.h"
#import "BTNotification.h"
#import "BTDateFormatter.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AudioToolbox/AudioServices.h>

@interface CreateClickerViewController ()

@property (strong, nonatomic) UITextView *textview;
@property (strong, nonatomic) UILabel *placeholder;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) UILabel *label;
@property (assign) NSInteger choice;
@property (strong, nonatomic) NSIndexPath *textviewIndex;
@property (strong, nonatomic) NSIndexPath *choiceviewIndex;
@property (strong, nonatomic) NSIndexPath *labelviewIndex;
@property(assign) NSInteger progressTime;
@property(assign) BOOL showInfoOnSelect;
@property(strong, nonatomic) NSString *detailPrivacy;

@end

@implementation CreateClickerViewController
@synthesize cid;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *start = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Start", nil) style:UIBarButtonItemStyleDone target:self action:@selector(start:)];
    self.navigationItem.rightBarButtonItem = start;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = NO;
    
    //Navigation title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Start Clicker", @"");
    [titlelabel sizeToFit];
    
    self.textviewIndex = [NSIndexPath indexPathForRow:1 inSection:0];
    self.choiceviewIndex = [NSIndexPath indexPathForRow:2 inSection:0];
    self.labelviewIndex = [NSIndexPath indexPathForRow:3 inSection:0];
    
    self.textview = [[UITextView alloc] initWithFrame:CGRectMake(14, 10, 292, 101)];
    self.textview.backgroundColor = [UIColor clearColor];
    self.textview.font = [UIFont systemFontOfSize:14];
    self.textview.textColor = [BTColor BT_silver:1.0];
    self.textview.tintColor = [BTColor BT_silver:1.0];
    self.textview.text = @"";
    [self.textview sizeToFit];
    self.textview.frame = CGRectMake(14, 8, 292, MAX(100, ceil(self.textview.frame.size.height)));
    self.textview.delegate = self;
    
    self.placeholder = [[UILabel alloc] initWithFrame:CGRectMake(19, 16, 292, 20)];
    self.placeholder.font = [UIFont systemFontOfSize:14];
    self.placeholder.textColor = [BTColor BT_silver:0.5];
    self.placeholder.text = [NSString stringWithFormat:NSLocalizedString(@"%@에 진행된 설문입니다.", nil), [BTDateFormatter detailedStringFromDate:[NSDate date]]];
    self.placeholder.numberOfLines = 0;
    [self.placeholder sizeToFit];
    
    self.message = @"";
    self.choice = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [self.textview becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.textview.text == nil || self.textview.text.length == 0)
        self.placeholder.hidden = NO;
    else
        self.placeholder.hidden = YES;
}

#pragma mark - Notification Handlers
- (void)keyboardDidShow:(NSNotification *)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.view setFrame:CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height - kbSize.height - 64)];
    [self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    [self.view setFrame:CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height - 64)];
    [self.view layoutIfNeeded];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 62;
    } else if (indexPath.row == 1) {
        self.textview.text = self.message;
        [self.textview sizeToFit];
        self.textview.frame = CGRectMake(14, 8, 292, MAX(100, ceil(self.textview.frame.size.height)));
        return MAX(86, ceil(self.textview.frame.size.height)) + 14;
    } else if (indexPath.row == 2)
        return 48;
    else if(indexPath.row == 3)
        return 60;
    else if (indexPath.row == 4 || indexPath.row == 5)
        return 46;
    else
        return 33;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 62)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [BTColor BT_grey:1.0];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 11, 288, 36)];
        NSString *progressTimeMessage = [NSString stringWithFormat:NSLocalizedString(@"* 설문이 시작되면 %d초간 답변을 수집합니다.", nil), self.progressTime];
        NSString *showInfoOnSelectMessage, *detailPrivacyMessage;
        if (self.showInfoOnSelect)
            showInfoOnSelectMessage = [NSString stringWithFormat:NSLocalizedString(@"* 설문이 진행되는 동안 학생들이 결과를 볼 수 있습니다.", nil)];
        else
            showInfoOnSelectMessage = [NSString stringWithFormat:NSLocalizedString(@"* 설문이 끝난 후에야 학생들이 결과를 볼 수 있습니다.", nil)];
        if ([@"professor" isEqualToString:self.detailPrivacy])
            detailPrivacyMessage = [NSString stringWithFormat:NSLocalizedString(@"* 상세 결과는 강의자만 볼 수 있습니다.", nil)];
        else if ([@"all" isEqualToString:self.detailPrivacy])
            detailPrivacyMessage = [NSString stringWithFormat:NSLocalizedString(@"* 모두 상세 결과를 볼 수 있습니다.", nil)];
        else
            detailPrivacyMessage = [NSString stringWithFormat:NSLocalizedString(@"* 아무도 상세 결과를 볼 수 없습니다.", nil)];
        
        label.text = [NSString stringWithFormat:@"%@\n%@\n%@", progressTimeMessage, showInfoOnSelectMessage, detailPrivacyMessage];
        label.textColor = [BTColor BT_silver:1.0];
        label.font = [UIFont systemFontOfSize:12];
        label.numberOfLines = 0;
        [label sizeToFit];
        [cell addSubview:label];
        return cell;
    } else if (indexPath.row == 1) {
        self.textview.text = self.message;
        [self.textview sizeToFit];
        self.textview.frame = CGRectMake(14, 8, 292, MAX(100, ceil(self.textview.frame.size.height)));
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, MAX(86, ceil(self.textview.frame.size.height)))];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [BTColor BT_white:1];
        [cell addSubview:self.textview];
        [cell addSubview:self.placeholder];
        return cell;
    } else if (indexPath.row == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(14, 26, 320, 12)];
        self.label.text = NSLocalizedString(@"Choose number of choices", nil);
        self.label.textColor = [BTColor BT_silver:1.0];
        self.label.font = [UIFont systemFontOfSize:12];
        [cell addSubview:self.label];
        
        return cell;
    } else if (indexPath.row == 3) {
        static NSString *CellIdentifier1 = @"ChooseCountCell";
        ChooseCountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ChooseCountCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        switch (self.choice) {
            case 2:
                [cell chooseType2:nil];
                break;
            case 3:
                [cell chooseType3:nil];
                break;
            case 4:
                [cell chooseType4:nil];
                break;
            case 5:
                [cell chooseType5:nil];
                break;
            default:
                break;
        }
        
        cell.typeMessage.text = NSLocalizedString(@"Choices", nil);
        return cell;
    } else if (indexPath.row == 4) {
        static NSString *CellIdentifier = @"PasswordCell";
        PasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.password.textColor = [BTColor BT_silver:1.0];
        cell.arrow.hidden = NO;
        cell.password.text = NSLocalizedString(@"설문 옵션", nil);
        return cell;
    } else if (indexPath.row ==5) {
        static NSString *CellIdentifier = @"PasswordCell";
        PasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.password.textColor = [BTColor BT_silver:1.0];
        cell.arrow.hidden = NO;
        cell.password.text = NSLocalizedString(@"저장한 질문 불러오기", nil);
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 33)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [BTColor BT_grey:1.0];
        return cell;
    }
}

#pragma UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView {
    [self.tableview beginUpdates];
    
    if (textView.text == nil || textView.text.length == 0)
        self.placeholder.hidden = NO;
    else
        self.placeholder.hidden = YES;
    
    self.message = textView.text;
    [self.textview sizeToFit];
    self.textview.frame = CGRectMake(14, 8, 292, MAX(100, ceil(self.textview.frame.size.height)));
    [self.tableview endUpdates];
}

- (void)start_clicker {
}

#pragma NavigationBarAction
- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)start:(UIBarButtonItem *)sender {
    sender.enabled = NO;
    
    ChooseCountCell *chooseCountCell = (ChooseCountCell *)[self.tableview cellForRowAtIndexPath:self.choiceviewIndex];
    self.choice = chooseCountCell.choice;
    
    BOOL pass = YES;
    
    if (chooseCountCell.choice < 2 || chooseCountCell.choice > 5) {
        [self.tableview cellForRowAtIndexPath:self.choiceviewIndex].contentView.backgroundColor = [BTColor BT_red:0.1];
        self.label.textColor = [BTColor BT_red:1.0];
        pass = NO;
    } else {
        [self.tableview cellForRowAtIndexPath:self.choiceviewIndex].contentView.backgroundColor = [UIColor clearColor];
        self.label.textColor = [BTColor BT_silver:1.0];
    }
    
    if (!pass) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        sender.enabled = YES;
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [BTColor BT_navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Starting Clicker", nil);
    hud.yOffset = -40.0f;
    
    NSString *message = self.textview.text;
    if (message == nil || message.length == 0)
        message = self.placeholder.text;
    
    [BTAPIs startClickerWithCourse:cid
                           message:message
                       choiceCount:[NSString stringWithFormat:@"%ld", (long)self.choice]
                           andTime:[NSString stringWithFormat:@"%ld", (long) self.progressTime]
                         andSelect:self.showInfoOnSelect
                        andPrivacy:self.detailPrivacy
                           success:^(Post *post) {
                               [hud hide:YES];
                               NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:post, PostInfo, nil];
                               [[NSNotificationCenter defaultCenter] postNotificationName:OpenNewPost object:nil userInfo:data];
                               [self.navigationController popViewControllerAnimated:NO];
                           } failure:^(NSError *error) {
                               [hud hide:YES];
                               sender.enabled = YES;
                           }];
}

#pragma IBAction
- (void)loadQuestion:(id)sender {
    ClickerQuestionViewController *clickerQuestion = [[ClickerQuestionViewController alloc] initWithNibName:@"ClickerQuestionViewController" bundle:nil];
    clickerQuestion.delegate = self;
    [self.navigationController pushViewController:clickerQuestion animated:YES];
}

#pragma ClickerQuestionViewControllerDelegate
- (void)chosenQuestion:(Question *)chosen {
    self.message = chosen.message;
    self.choice = chosen.choice_count;
    [self.tableview reloadData];
}

@end
