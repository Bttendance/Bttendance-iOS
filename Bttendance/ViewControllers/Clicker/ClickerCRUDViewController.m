//
//  ClickerCRUDViewController.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 9. 18..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ClickerCRUDViewController.h"
#import "UIColor+Bttendance.h"
#import "NSDate+Bttendance.h"
#import "PasswordCell.h"
#import "NumberOptionCell.h"
#import "NumberPadDoneBtn.h"
#import "BTUserDefault.h"
#import "BTAPIs.h"
#import "BTNotification.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AudioToolbox/AudioServices.h>

@interface ClickerCRUDViewController ()

@property(assign) NSInteger choiceCount;
@property(strong, nonatomic) NSString *message;
@property(assign) NSInteger progressTime;
@property(assign) BOOL showInfoOnSelect;

@property(strong, nonatomic) NSString *detailPrivacy;

@property(strong, nonatomic) NSString *aOptionText;
@property(strong, nonatomic) NSString *bOptionText;
@property(strong, nonatomic) NSString *cOptionText;
@property(strong, nonatomic) NSString *dOptionText;
@property(strong, nonatomic) NSString *eOptionText;

@property (strong, nonatomic) UITextView *textview;
@property (strong, nonatomic) UILabel *placeholder;
@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) NumberOptionCell *numberOptionCell;
@property (strong, nonatomic) NumberPadDoneBtn *numberPadDoneBtn;

@property (strong, nonatomic) User *user;

@end

@implementation ClickerCRUDViewController

- (void)loadView
{
    [super loadView];
    self.tableView = [[SLExpandableTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Navigation title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    switch (self.clickerType) {
        case CLICKER_CREATE:
            titlelabel.text = NSLocalizedString(@"Start Clicker", nil);
            break;
        case CLICKER_EDIT:
            titlelabel.text = NSLocalizedString(@"Edit Clicker", nil);
            break;
        case QUESTION_CREATE:
            titlelabel.text = NSLocalizedString(@"Add Question", nil);
            break;
        case QUESTION_EDIT:
            titlelabel.text = NSLocalizedString(@"Edit Question", nil);
        default:
            break;
    }
    [titlelabel sizeToFit];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = NO;
    
    UIBarButtonItem *start = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Start", nil) style:UIBarButtonItemStyleDone target:self action:@selector(start:)];
    self.navigationItem.rightBarButtonItem = start;
    
    super.tableView.backgroundColor = [UIColor grey:1.0];
    super.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    super.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    super.tableView.allowsMultipleSelection = YES;
    
    self.user = [BTUserDefault getUser];
    
    if (self.post != nil) {
        self.message = self.post.message;
        self.choiceCount = self.post.clicker.choice_count;
        self.progressTime = self.post.clicker.progress_time;
        self.showInfoOnSelect = self.post.clicker.show_info_on_select;
        self.detailPrivacy = self.post.clicker.detail_privacy;
    } else if (self.question != nil) {
        self.message = self.question.message;
        self.choiceCount = self.question.choice_count;
        self.progressTime = self.question.progress_time;
        self.showInfoOnSelect = self.question.show_info_on_select;
        self.detailPrivacy = self.question.detail_privacy;
    } else {
        self.message = @"";
        self.choiceCount = 0;
        self.progressTime = self.user.setting.progress_time;
        self.showInfoOnSelect = self.user.setting.show_info_on_select;
        self.detailPrivacy = self.user.setting.detail_privacy;
    }
    
    self.textview = [[UITextView alloc] initWithFrame:CGRectMake(14, 10, 292, 101)];
    self.textview.backgroundColor = [UIColor clearColor];
    self.textview.font = [UIFont systemFontOfSize:14];
    self.textview.textColor = [UIColor silver:1.0];
    self.textview.tintColor = [UIColor silver:1.0];
    self.textview.text = self.message;
    [self.textview sizeToFit];
    self.textview.frame = CGRectMake(14, 8, 292, MAX(100, ceil(self.textview.frame.size.height)));
    self.textview.delegate = self;
    
    self.placeholder = [[UILabel alloc] initWithFrame:CGRectMake(19, 16, 292, 20)];
    self.placeholder.font = [UIFont systemFontOfSize:14];
    self.placeholder.textColor = [UIColor silver:0.5];
    switch (self.clickerType) {
        case CLICKER_CREATE:
            break;
        case CLICKER_EDIT:
        case QUESTION_CREATE:
        case QUESTION_EDIT:
        default:
            break;
    }
    self.placeholder.text = [NSString stringWithFormat:NSLocalizedString(@"%@에 진행된 설문입니다.", nil), [NSDate detailedStringFromDate:[NSDate date]]];
    self.placeholder.numberOfLines = 0;
    [self.placeholder sizeToFit];
    
    static NSString *CellIdentifier = @"NumberOptionCell";
    self.numberOptionCell = [super.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.numberOptionCell == nil) {
        [super.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
        self.numberOptionCell = [super.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        self.numberOptionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    self.numberPadDoneBtn = [[NumberPadDoneBtn alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.numberOptionCell.title.inputAccessoryView = self.numberPadDoneBtn;
    self.numberOptionCell.title.tintColor = [UIColor silver:1.0];
    self.numberOptionCell.title.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.textview becomeFirstResponder];
    switch (self.clickerType) {
        case CLICKER_CREATE:
            break;
        case CLICKER_EDIT:
            [(SLExpandableTableView *)self.tableView expandSection:2 animated:NO];
            [(SLExpandableTableView *)self.tableView expandSection:3 animated:NO];
            break;
        case QUESTION_CREATE:
            [(SLExpandableTableView *)self.tableView expandSection:3 animated:NO];
            break;
        case QUESTION_EDIT:
        default:
            [(SLExpandableTableView *)self.tableView expandSection:2 animated:NO];
            [(SLExpandableTableView *)self.tableView expandSection:3 animated:NO];
            break;
    }
}

#pragma NavigationBarAction
- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)start:(UIBarButtonItem *)sender {
    sender.enabled = NO;
    
    BOOL pass = YES;
    
    NSString *message = self.message;
    if (self.clickerType == CLICKER_CREATE && (message == nil || message.length == 0))
        message = self.placeholder.text;
    
    if (message == nil || message.length == 0) {
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].contentView.backgroundColor = [UIColor red:0.1];
        pass = NO;
    } else {
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]].contentView.backgroundColor = [UIColor clearColor];
    }
    
    if (self.choiceCount < 2 || self.choiceCount > 5) {
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]].contentView.backgroundColor = [UIColor red:0.1];
        self.label.textColor = [UIColor red:1.0];
        pass = NO;
    } else {
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]].contentView.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor silver:1.0];
    }
    
    if (!pass) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        sender.enabled = YES;
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.yOffset = -40.0f;
    
    switch (self.clickerType) {
        case CLICKER_CREATE: {
            hud.detailsLabelText = NSLocalizedString(@"Starting Clicker", nil);
            [BTAPIs startClickerWithCourse:[NSString stringWithFormat:@"%ld", (long) self.post.course.id]
                                   message:message
                               choiceCount:[NSString stringWithFormat:@"%ld", (long) self.choiceCount]
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
            break;
        }
        case CLICKER_EDIT: {
            hud.detailsLabelText = NSLocalizedString(@"Updating Clicker", nil);
            [BTAPIs updateMessageOfPost:[NSString stringWithFormat:@"%ld", (long)self.post.id]
                            withMessage:message
                                success:^(Post *post) {
                                    sender.enabled = YES;
                                    [hud hide:YES];
                                    [self.navigationController popViewControllerAnimated:YES];
                                } failure:^(NSError *error) {
                                    sender.enabled = YES;
                                    [hud hide:YES];
                                }];
            break;
        }
        case QUESTION_CREATE: {
            hud.detailsLabelText = NSLocalizedString(@"Adding Question", nil);
            [BTAPIs createQuestionWithMessage:message
                               andChoiceCount:[NSString stringWithFormat:@"%ld", (long) self.choiceCount]
                                      andTime:[NSString stringWithFormat:@"%ld", (long) self.progressTime]
                                    andSelect:self.showInfoOnSelect
                                   andPrivacy:self.detailPrivacy
                                      success:^(Question *question) {
                                          [hud hide:YES];
                                          sender.enabled = YES;
                                          [self.navigationController popViewControllerAnimated:YES];
                                      } failure:^(NSError *error) {
                                          [hud hide:YES];
                                          sender.enabled = YES;
                                      }];
            break;
        }
        case QUESTION_EDIT: {
            hud.detailsLabelText = NSLocalizedString(@"Updating Question", nil);
            [BTAPIs updateQuestion:[NSString stringWithFormat:@"%ld", (long) self.question.id]
                       WithMessage:message
                    andChoiceCount:[NSString stringWithFormat:@"%ld", (long) self.choiceCount]
                           andTime:[NSString stringWithFormat:@"%ld", (long) self.progressTime]
                         andSelect:self.showInfoOnSelect
                        andPrivacy:self.detailPrivacy
                           success:^(Question *question) {
                               [hud hide:YES];
                               sender.enabled = YES;
                               [self.navigationController popViewControllerAnimated:YES];
                           } failure:^(NSError *error) {
                               [hud hide:YES];
                               sender.enabled = YES;
                           }];
            break;
        }
    }
}

#pragma UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView {
    [self.tableView beginUpdates];
    
    if (textView.text == nil || textView.text.length == 0)
        self.placeholder.hidden = NO;
    else
        self.placeholder.hidden = YES;
    
    self.message = textView.text;
    [self.textview sizeToFit];
    self.textview.frame = CGRectMake(14, 8, 292, MAX(100, ceil(self.textview.frame.size.height)));
    [self.tableView endUpdates];
}

#pragma mark - ChooseCountCellDelegate
- (void)chosen:(NSInteger)choiceCount {
    self.choiceCount = choiceCount;
    [(SLExpandableTableView *)super.tableView reloadDataAndResetExpansionStates:NO];
    [(SLExpandableTableView *)super.tableView expandSection:2 animated:YES];
}

#pragma mark - SLExpandableTableViewDatasource
- (BOOL)tableView:(SLExpandableTableView *)tableView canExpandSection:(NSInteger)section
{
    if (section == 2)
        return YES;
    return NO;
}

- (BOOL)tableView:(SLExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section
{
    return NO;
}

- (UITableViewCell<UIExpandingTableViewCell> *)tableView:(SLExpandableTableView *)tableView expandingCellForSection:(NSInteger)section
{
    if (section == 2) { //ChoiceCount
        static NSString *CellIdentifier1 = @"ChooseCountCell";
        ChooseCountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ChooseCountCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        switch (self.choiceCount) {
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
        }
        
        cell.typeMessage.text = NSLocalizedString(@"Choices", nil);
        cell.delegate = self;
        return cell;
    }
    return nil;
}

#pragma mark - SLExpandableTableViewDelegate
- (void)tableView:(SLExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section
{
}

- (void)tableView:(SLExpandableTableView *)tableView didExpandSection:(NSUInteger)section animated:(BOOL)animated
{
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 2;
        case 2:
//            if (self.choiceCount == 0)
                return 1;
//            return self.choiceCount + 2;
        case 3:
            return 1;
        case 4:
        default:
            switch (self.clickerType) {
                case CLICKER_CREATE:
                case QUESTION_EDIT:
                    return 2;
                case CLICKER_EDIT:
                case QUESTION_CREATE:
                default:
                    return 0;
            }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 62; //Header
        case 1:
            if (indexPath.row == 0) { //TextView
                self.textview.text = self.message;
                [self.textview sizeToFit];
                self.textview.frame = CGRectMake(14, 8, 292, MAX(100, ceil(self.textview.frame.size.height)));
                return MAX(86, ceil(self.textview.frame.size.height)) + 14;
            }
            if (indexPath.row == 1) //ChoiceCountDetail
                return 48;
        case 2:
            if (indexPath.row == 0) //ChoiceCount
                return 60;
            else if (indexPath.row == self.choiceCount + 1) //Margin
                return 33;
            else
                return 47; //ChoiceMessage
        case 3:
            return 47; //Options
        case 4:
        default:
            switch (self.clickerType) {
                case CLICKER_CREATE:
                    if (indexPath.row == 1) //Margin
                        return 33;
                    break;
                default:
                    if (indexPath.row == 0) //Margin
                        return 33;
                    break;
            }
            return 46; //Footer
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: { //Header
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 62)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor grey:1.0];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 11, 288, 36)];
            label.textColor = [UIColor silver:1.0];
            label.font = [UIFont systemFontOfSize:12];
            
            NSString *progressTimeMessage = [NSString stringWithFormat:NSLocalizedString(@"* 설문이 시작되면 %d초간 답변을 수집합니다.", nil), self.progressTime];
            NSString *showInfoOnSelectMessage, *detailPrivacyMessage;
            if (self.showInfoOnSelect)
                showInfoOnSelectMessage = [NSString stringWithFormat:NSLocalizedString(@"* 설문이 진행되는 동안 학생들이 결과를 볼 수 있습니다.", nil)];
            else
                showInfoOnSelectMessage = [NSString stringWithFormat:NSLocalizedString(@"* 설문이 끝난 후에야 학생들이 결과를 볼 수 있습니다.", nil)];
            if ([@"professor" isEqualToString:self.detailPrivacy])
                detailPrivacyMessage = [NSString stringWithFormat:NSLocalizedString(@"* 강의자만 상세 결과를 볼 수 있습니다.", nil)];
            else if ([@"all" isEqualToString:self.detailPrivacy])
                detailPrivacyMessage = [NSString stringWithFormat:NSLocalizedString(@"* 모두 상세 결과를 볼 수 있습니다.", nil)];
            else
                detailPrivacyMessage = [NSString stringWithFormat:NSLocalizedString(@"* 아무도 상세 결과를 볼 수 없습니다.", nil)];
            
            NSString *message = [NSString stringWithFormat:@"%@\n%@\n%@", progressTimeMessage, showInfoOnSelectMessage, detailPrivacyMessage];
            NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:message];
            [attributed addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message rangeOfString:[NSString stringWithFormat:NSLocalizedString(@"%d초간", nil), self.progressTime]]];
            [attributed addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message rangeOfString:NSLocalizedString(@"진행되는 동안", nil)]];
            [attributed addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message rangeOfString:NSLocalizedString(@"끝난 후에야", nil)]];
            [attributed addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message rangeOfString:NSLocalizedString(@"강의자만", nil)]];
            [attributed addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message rangeOfString:NSLocalizedString(@"모두", nil)]];
            [attributed addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message rangeOfString:NSLocalizedString(@"아무도", nil)]];
            
            label.attributedText = attributed;
            label.numberOfLines = 0;
            [label sizeToFit];
            [cell addSubview:label];
            return cell;
        }
        case 1:
            if (indexPath.row == 0) { //TextView
                self.textview.text = self.message;
                [self.textview sizeToFit];
                self.textview.frame = CGRectMake(14, 8, 292, MAX(100, ceil(self.textview.frame.size.height)));
                UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, MAX(86, ceil(self.textview.frame.size.height)))];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor white:1];
                [cell addSubview:self.textview];
                [cell addSubview:self.placeholder];
                return cell;
            }
            if (indexPath.row == 1) { //ChoiceCountDetail
                UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor clearColor];
                
                self.label = [[UILabel alloc] initWithFrame:CGRectMake(14, 26, 320, 12)];
                self.label.text = NSLocalizedString(@"Choose number of choices", nil);
                self.label.textColor = [UIColor silver:1.0];
                self.label.font = [UIFont systemFontOfSize:12];
                [cell addSubview:self.label];
                
                return cell;
            }
        case 2:
            if (indexPath.row == 0) { //ChoiceCount
            } else if (indexPath.row == self.choiceCount + 1) { //Margin
                UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 33)];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor grey:1.0];
                return cell;
            } else { //ChoiceMessage
                static NSString *CellIdentifier = @"PasswordCell";
                PasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.password.textColor = [UIColor silver:1.0];
                cell.arrow.hidden = NO;
                cell.password.text = NSLocalizedString(@"설문 옵션", nil);
                return cell;
            }
        case 3: {
            static NSString *CellIdentifier = @"PasswordCell";
            PasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.password.textColor = [UIColor silver:1.0];
            cell.arrow.hidden = NO;
            cell.password.text = NSLocalizedString(@"설문 옵션", nil);
            return cell;
        }
        case 4:
        default:
            switch (self.clickerType) {
                case CLICKER_CREATE:
                    if (indexPath.row == 1) { //Margin
                        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 33)];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.backgroundColor = [UIColor grey:1.0];
                        return cell;
                    } else { //Footer
                        static NSString *CellIdentifier = @"PasswordCell";
                        PasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        if (cell == nil) {
                            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
                            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }
                        cell.password.textColor = [UIColor silver:1.0];
                        cell.arrow.hidden = NO;
                        cell.password.text = NSLocalizedString(@"저장한 질문 불러오기", nil);
                        return cell;
                    }
                    break;
                default:
                    if (indexPath.row == 0) { //Margin
                        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 33)];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.backgroundColor = [UIColor grey:1.0];
                        return cell;
                    } else { //Footer
                        static NSString *CellIdentifier = @"PasswordCell";
                        PasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        if (cell == nil) {
                            [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
                            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }
                        cell.password.textColor = [UIColor silver:1.0];
                        cell.arrow.hidden = NO;
                        cell.password.text = NSLocalizedString(@"Delete Question", nil);
                        cell.password.textColor = [UIColor red:1];
                        return cell;
                    }
                    break;
            }
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 3) {
        ClickerOptionViewController *optionView = [[ClickerOptionViewController alloc] initWithStyle:UITableViewStylePlain];
        switch (self.clickerType) {
            case CLICKER_CREATE:
            case CLICKER_EDIT:
                optionView.optionType = CLICKER;
                break;
            case QUESTION_CREATE:
            case QUESTION_EDIT:
                optionView.optionType = QUESTION;
                break;
        }
        optionView.progressTime = self.progressTime;
        optionView.showInfoOnSelect = self.showInfoOnSelect;
        optionView.detailPrivacy = self.detailPrivacy;
        optionView.delegate = self;
        [self.navigationController pushViewController:optionView animated:YES];
    }
    
    if (indexPath.section == 4) {
        switch (self.clickerType) {
            case CLICKER_CREATE: {
                ClickerQuestionViewController *questionView = [[ClickerQuestionViewController alloc] initWithNibName:@"ClickerQuestionViewController" bundle:nil];
                questionView.questionType = LOAD;
                questionView.delegate = self;
                [self.navigationController pushViewController:questionView animated:YES];
                break;
            }
            case QUESTION_EDIT:
                break;
            default:
                break;
        }
    }
}

#pragma mark - ClickerOptionViewControllerDelegate
- (void)chosenOptionTime:(NSInteger)progressTime andOnSelect:(BOOL)showInfoOnSelect andDetail:(NSString *)detailPrivacy
{
    self.progressTime = progressTime;
    self.showInfoOnSelect = showInfoOnSelect;
    self.detailPrivacy = detailPrivacy;
    [(SLExpandableTableView *)super.tableView reloadDataAndResetExpansionStates:NO];
}
#pragma mark - ClickerQuestionViewControllerDelegate
- (void)chosenQuestion:(Question *)chosen {
    self.message = chosen.message;
    self.choiceCount = chosen.choice_count;
    self.progressTime = chosen.progress_time;
    self.showInfoOnSelect = chosen.show_info_on_select;
    self.detailPrivacy = chosen.detail_privacy;
    [(SLExpandableTableView *)super.tableView reloadDataAndResetExpansionStates:NO];
}

#pragma mark - Private category implementation ()

@end
