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
#import <MBProgressHUD/MBProgressHUD.h>
#import <AudioToolbox/AudioServices.h>

@interface CreateClickerViewController ()

@property (strong, nonatomic) UITextView *textview;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) UILabel *label;
@property (assign) NSInteger choice;
@property (strong, nonatomic) NSIndexPath *textviewIndex;
@property (strong, nonatomic) NSIndexPath *choiceviewIndex;
@property (strong, nonatomic) NSIndexPath *labelviewIndex;

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
    
    self.textview = [[UITextView alloc] initWithFrame:CGRectMake(14, 10, 292, 85)];
    self.textview.backgroundColor = [UIColor clearColor];
    self.textview.font = [UIFont systemFontOfSize:14];
    self.textview.textColor = [BTColor BT_silver:1.0];
    self.textview.tintColor = [BTColor BT_silver:1.0];
    self.textview.text = @"";
    [self.textview sizeToFit];
    self.textview.frame = CGRectMake(14, 8, 292, MAX(84, ceil(self.textview.frame.size.height)));
    self.textview.delegate = self;
    
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
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 38;
    } else if (indexPath.row == 1) {
        self.textview.text = self.message;
        [self.textview sizeToFit];
        self.textview.frame = CGRectMake(14, 8, 292, MAX(84, ceil(self.textview.frame.size.height)));
        return MAX(70, ceil(self.textview.frame.size.height));
    } else if (indexPath.row == 2)
        return 120;
    else if(indexPath.row == 3)
        return 20;
    else
        return 78;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 38)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [BTColor BT_grey:1.0];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 13, 288, 12)];
        label.text = NSLocalizedString(@"* 설문이 시작되면 60초간 답변을 수집합니다.", nil);
        label.textColor = [BTColor BT_silver:1.0];
        label.font = [UIFont systemFontOfSize:12];
        [cell addSubview:label];
        return cell;
    } else if (indexPath.row == 1) {
        self.textview.text = self.message;
        [self.textview sizeToFit];
        self.textview.frame = CGRectMake(14, 8, 292, MAX(84, ceil(self.textview.frame.size.height)));
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, MAX(70, ceil(self.textview.frame.size.height)))];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell addSubview:self.textview];
        return cell;
    } else if (indexPath.row == 2) {
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
        
        cell.typeMessage2.text = NSLocalizedString(@"Choices", nil);
        cell.typeMessage3.text = NSLocalizedString(@"Choices", nil);
        cell.typeMessage4.text = NSLocalizedString(@"Choices", nil);
        cell.typeMessage5.text = NSLocalizedString(@"Choices", nil);
        
        [cell.typeMessage2 sizeToFit];
        [cell.typeMessage3 sizeToFit];
        [cell.typeMessage4 sizeToFit];
        [cell.typeMessage5 sizeToFit];
        
        CGFloat width = cell.typeMessage2.frame.size.width + 8 + 36;
        CGFloat margin = (160 - width) / 2 - 5; //margin보다 조금 왼쪽으로 옮김
        
        cell.bg2.frame = CGRectMake(margin, 14, 36, 36);
        cell.bg3.frame = CGRectMake(160 + margin, 14, 36, 36);
        cell.bg4.frame = CGRectMake(margin, 70, 36, 36);
        cell.bg5.frame = CGRectMake(160 + margin, 70, 36, 36);
        
        cell.typeLable2.frame = CGRectMake(margin + 2, 16, 32, 32);
        cell.typeLable3.frame = CGRectMake(162 + margin, 16, 32, 32);
        cell.typeLable4.frame = CGRectMake(margin + 2, 72, 32, 32);
        cell.typeLable5.frame = CGRectMake(162 + margin, 72, 32, 32);
        
        cell.typeMessage2.frame = CGRectMake(44 + margin, 23, width - 8 - 36, 20);
        cell.typeMessage3.frame = CGRectMake(204 + margin, 23, width - 8 - 36, 20);
        cell.typeMessage4.frame = CGRectMake(44 + margin, 78, width - 8 - 36, 20);
        cell.typeMessage5.frame = CGRectMake(204 + margin, 78, width - 8 - 36, 20);
        
        return cell;
    } else if (indexPath.row == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        self.label.text = NSLocalizedString(@"Choose number of choices", nil);
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [BTColor BT_silver:1.0];
        self.label.font = [UIFont boldSystemFontOfSize:12];
        [cell addSubview:self.label];
        
        return cell;
    } else {
        static NSString *CellIdentifier1 = @"SignButtonCell";
        SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        if (cell_new == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
            cell_new = [topLevelObjects objectAtIndex:0];
            cell_new.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell_new.contentView.backgroundColor = [BTColor BT_white:1.0];
        
        [cell_new.button setTitle:NSLocalizedString(@"Load saved question", nil) forState:UIControlStateNormal];
        [cell_new.button setBackgroundImage:[BTColor imageWithCyanColor:1.0] forState:UIControlStateNormal];
        [cell_new.button setBackgroundImage:[BTColor imageWithCyanColor:0.85] forState:UIControlStateHighlighted];
        [cell_new.button setBackgroundImage:[BTColor imageWithCyanColor:0.85] forState:UIControlStateSelected];
        
        cell_new.button.frame = CGRectMake(9, 12, 302, 43);
        
        [cell_new.button addTarget:self action:@selector(loadQuestion:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell_new;
    }
}

#pragma UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView {
    [self.tableview beginUpdates];
    self.message = textView.text;
    [self.textview sizeToFit];
    self.textview.frame = CGRectMake(14, 8, 292, MAX(84, ceil(self.textview.frame.size.height)));
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
    
    BOOL pass = YES;
    
    if (self.textview.text == nil || self.textview.text.length == 0) {
        [self.tableview cellForRowAtIndexPath:self.textviewIndex].contentView.backgroundColor = [BTColor BT_red:0.1];
        pass = NO;
    } else {
        [self.tableview cellForRowAtIndexPath:self.textviewIndex].contentView.backgroundColor = [UIColor clearColor];
    }
    
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
    
    [BTAPIs startClickerWithCourse:cid
                           message:self.textview.text
                       choiceCount:[NSString stringWithFormat:@"%ld", (long)self.choice]
                           success:^(Post *post) {
                               [hud hide:YES];
                               sender.enabled = YES;
                               [self.navigationController popViewControllerAnimated:YES];
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
