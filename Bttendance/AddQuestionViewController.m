//
//  AddQuestionViewController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 8. 4..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "AddQuestionViewController.h"
#import "BTColor.h"
#import "BTAPIs.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AudioToolbox/AudioServices.h>
#import "ChooseCountCell.h"

@interface AddQuestionViewController ()

@property (strong, nonatomic) UITextView *textview;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) NSIndexPath *textviewIndex;
@property (strong, nonatomic) NSIndexPath *choiceviewIndex;
@property (strong, nonatomic) NSIndexPath *labelviewIndex;
@property(assign) NSInteger progressTime;
@property(assign) BOOL showInfoOnSelect;
@property(strong, nonatomic) NSString *detailPrivacy;

@end

@implementation AddQuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = NO;
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStyleDone target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = save;
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [BTColor BT_white:1.0];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Add Question", @"");
    [titlelabel sizeToFit];
    
    self.textviewIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    self.choiceviewIndex = [NSIndexPath indexPathForRow:1 inSection:0];
    self.labelviewIndex = [NSIndexPath indexPathForRow:2 inSection:0];
    
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
}

-(void)viewDidAppear:(BOOL)animated {
    [self.textview becomeFirstResponder];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0){
        self.textview.text = self.message;
        [self.textview sizeToFit];
        self.textview.frame = CGRectMake(14, 8, 292, MAX(84, ceil(self.textview.frame.size.height)));
        return MAX(70, ceil(self.textview.frame.size.height));
    }
    else if (indexPath.row == 1)
        return 120;
    else
        return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.textview.text = self.message;
        [self.textview sizeToFit];
        self.textview.frame = CGRectMake(14, 8, 292, MAX(84, ceil(self.textview.frame.size.height)));
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, MAX(70, ceil(self.textview.frame.size.height)))];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell addSubview:self.textview];
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *CellIdentifier1 = @"ChooseCountCell";
        ChooseCountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ChooseCountCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.typeMessage.text = NSLocalizedString(@"Choices", nil);
        return cell;
    } else {
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

#pragma NavigationBarAction
- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save:(UIBarButtonItem *)sender {
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
    hud.detailsLabelText = NSLocalizedString(@"Adding Question", nil);
    hud.yOffset = -40.0f;
    
    [BTAPIs createQuestionWithMessage:self.textview.text
                       andChoiceCount:[NSString stringWithFormat:@"%d", chooseCountCell.choice]
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
}

@end
