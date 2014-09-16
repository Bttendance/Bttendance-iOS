//
//  EditClickerViewController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 8. 4..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "EditClickerViewController.h"
#import "BTAPIs.h"
#import "UIColor+Bttendance.h"
#import "ChooseCountCell.h"
#import "SignButtonCell.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AudioToolbox/AudioServices.h>

@interface EditClickerViewController ()

@property (strong, nonatomic) UITextView *textview;
@property (strong, nonatomic) NSString *message;
@property (assign) NSInteger choice;
@property (strong, nonatomic) NSIndexPath *textviewIndex;
@property (strong, nonatomic) NSIndexPath *choiceviewIndex;

@end

@implementation EditClickerViewController

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
    titlelabel.textColor = [UIColor white:1.0];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Edit Clicker", @"");
    [titlelabel sizeToFit];
    
    self.textviewIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    self.choiceviewIndex = [NSIndexPath indexPathForRow:1 inSection:0];
    
    self.textview = [[UITextView alloc] initWithFrame:CGRectMake(14, 10, 292, 85)];
    self.textview.backgroundColor = [UIColor clearColor];
    self.textview.font = [UIFont systemFontOfSize:14];
    self.textview.textColor = [UIColor silver:1.0];
    self.textview.tintColor = [UIColor silver:1.0];
    self.textview.text = self.post.message;
    [self.textview sizeToFit];
    self.textview.frame = CGRectMake(14, 8, 292, MAX(84, ceil(self.textview.frame.size.height)));
    self.textview.delegate = self;
    
    self.message = self.post.message;
    self.choice = self.post.clicker.choice_count;
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
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.textview.text = self.message;
        [self.textview sizeToFit];
        self.textview.frame = CGRectMake(14, 8, 292, MAX(84, ceil(self.textview.frame.size.height)));
        return MAX(70, ceil(self.textview.frame.size.height));
    } else
        return 120;
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
    } else {
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
        
        cell.typeButton2.enabled = NO;
        cell.typeButton3.enabled = NO;
        cell.typeButton4.enabled = NO;
        cell.typeButton5.enabled = NO;
        
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
    
    BOOL pass = YES;
    
    if (self.textview.text == nil || self.textview.text.length == 0) {
        [self.tableview cellForRowAtIndexPath:self.textviewIndex].contentView.backgroundColor = [UIColor red:0.1];
        pass = NO;
    } else {
        [self.tableview cellForRowAtIndexPath:self.textviewIndex].contentView.backgroundColor = [UIColor clearColor];
    }
    
    if (!pass) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        sender.enabled = YES;
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor navy:0.7];
    hud.labelText = NSLocalizedString(@"Loading", nil);
    hud.detailsLabelText = NSLocalizedString(@"Updating Clicker", nil);
    hud.yOffset = -40.0f;
    
    [BTAPIs updateMessageOfPost:[NSString stringWithFormat:@"%ld", (long)self.post.id]
                    withMessage:self.message
                        success:^(Post *post) {
                            sender.enabled = YES;
                            [hud hide:YES];
                            [self.navigationController popViewControllerAnimated:YES];
                        } failure:^(NSError *error) {
                            sender.enabled = YES;
                            [hud hide:YES];
                        }];
}

@end
