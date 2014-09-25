//
//  ClickerQuestionViewController.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 2..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ClickerQuestionViewController.h"
#import "UIColor+Bttendance.h"
#import "UIImage+Bttendance.h"
#import "BTUserDefault.h"
#import "BTAPIs.h"
#import "QuestionCell.h"
#import "ClickerCRUDViewController.h"

@interface ClickerQuestionViewController ()

@property (strong) NSArray *questions;

@end

@implementation ClickerQuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = NO;
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor white:1.0];
    self.navigationItem.titleView = titlelabel;
    if (self.showDetailBt)
        titlelabel.text = NSLocalizedString(@"Clicker Questions", @"");
    else
        titlelabel.text = NSLocalizedString(@"Saved Questions", @"");
    [titlelabel sizeToFit];
    
    self.questions = [NSArray array];
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.questions = [BTUserDefault getQuestions];
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });
    });
    
    self.tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 4)];
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 4)];
    
    if (self.showDetailBt) {
        self.tableview.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height + 20 - 46 - 64);
        self.detailBt.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height + 20 - 64 - 46, 320, 46);
        [self.detailBt setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:1.0]] forState:UIControlStateNormal];
        [self.detailBt setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateHighlighted];
        [self.detailBt setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateSelected];
        [self.detailBt setTitle:NSLocalizedString(@"", nil) forState:UIControlStateNormal];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        label.textColor = [UIColor white:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:16];
        label.text = NSLocalizedString(@"Add a Question", nil);
        [label sizeToFit];
        
        CGFloat width = label.frame.size.width;
        CGFloat height = label.frame.size.height;
        label.frame = CGRectMake(160 - width / 2 , 24 - height / 2, width, height);
        [self.detailBt addSubview:label];
    } else {
        self.tableview.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64);
    }
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [BTAPIs myQuestionsInSuccess:^(NSArray *questions) {
        self.questions = questions;
        [self.tableview reloadData];
    } failure:^(NSError *error) {
    }];
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.questions == nil)
        return 0;
    
    return [self.questions count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIFont *cellfont = [UIFont boldSystemFontOfSize:13];
    NSString *rawmessage = ((Question *)[self.questions objectAtIndex:indexPath.row]).message;
    NSAttributedString *message = [[NSAttributedString alloc] initWithString:rawmessage attributes:@{NSFontAttributeName:cellfont}];
    CGRect MessageLabelSize = [message boundingRectWithSize:(CGSize){196, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    
    return MAX(160, 100 + MessageLabelSize.size.height);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"QuestionCell";
    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Question *question = [self.questions objectAtIndex:indexPath.row];
    
    NSString *progressTimeMessage = [NSString stringWithFormat:NSLocalizedString(@"* 설문이 시작되면 %d분간 답변을 수집합니다.", nil), (int)(question.progress_time/60)];
    NSString *showInfoOnSelectMessage, *detailPrivacyMessage;
    if (question.show_info_on_select)
        showInfoOnSelectMessage = [NSString stringWithFormat:NSLocalizedString(@"* 설문이 진행되는 동안 학생들이 결과를 볼 수 있습니다.", nil)];
    else
        showInfoOnSelectMessage = [NSString stringWithFormat:NSLocalizedString(@"* 설문이 끝난 후에야 학생들이 결과를 볼 수 있습니다.", nil)];
    if ([@"professor" isEqualToString:question.detail_privacy])
        detailPrivacyMessage = [NSString stringWithFormat:NSLocalizedString(@"* 강의자만 상세 결과를 볼 수 있습니다.", nil)];
    else if ([@"all" isEqualToString:question.detail_privacy])
        detailPrivacyMessage = [NSString stringWithFormat:NSLocalizedString(@"* 모두 상세 결과를 볼 수 있습니다.", nil)];
    else
        detailPrivacyMessage = [NSString stringWithFormat:NSLocalizedString(@"* 아무도 상세 결과를 볼 수 없습니다.", nil)];
    
    NSString *message = [NSString stringWithFormat:@"%@\n%@\n%@", detailPrivacyMessage, showInfoOnSelectMessage, progressTimeMessage];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:message];
    [attributed addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message rangeOfString:[NSString stringWithFormat:NSLocalizedString(@"%d분간", nil), (int)(question.progress_time/60)]]];
    [attributed addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message rangeOfString:NSLocalizedString(@"진행되는 동안", nil)]];
    [attributed addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message rangeOfString:NSLocalizedString(@"끝난 후에야", nil)]];
    [attributed addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message rangeOfString:NSLocalizedString(@"강의자만", nil)]];
    [attributed addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message rangeOfString:NSLocalizedString(@"모두", nil)]];
    [attributed addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12.0] range:[message rangeOfString:NSLocalizedString(@"아무도", nil)]];
    
    cell.detail.attributedText = attributed;
    cell.detail.numberOfLines = 0;
    
    cell.message.frame = CGRectMake(25, 21, 196, 60);
    cell.message.text = question.message;
    cell.message.numberOfLines = 0;
    [cell.message sizeToFit];
    
    cell.choice.text = [NSString stringWithFormat:@"%ld", (long)((Question *)[self.questions objectAtIndex:indexPath.row]).choice_count];
    
    NSInteger height = MAX(160, 100 + cell.message.frame.size.height);
    cell.background_bg.frame = CGRectMake(11, 7, 298, height - 14);
    cell.selected_bg.frame = CGRectMake(11, 7, 298, height - 14);
    cell.choice_bg.frame = CGRectMake(239, 25 + (height - 160)/2, 52, 52);
    cell.choice_inner_bg.frame = CGRectMake(241, 27 + (height - 160)/2, 48, 48);
    cell.choice.frame = CGRectMake(241, 27 + (height - 160)/2, 48, 48);
    cell.detail.frame = CGRectMake(20, 100 + height - 160, 280, 0);
    [cell.detail sizeToFit];
    
    return cell;
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.showDetailBt) {
        ClickerCRUDViewController *clickerView = [[ClickerCRUDViewController alloc] initWithStyle:UITableViewStylePlain];
        clickerView.clickerType = QUESTION_EDIT;
        clickerView.question = [self.questions objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:clickerView animated:YES];
    } else {
        [self.delegate chosenQuestion:(Question *)[self.questions objectAtIndex:indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - IBAction
-(IBAction)showDetail:(id)sender {
    ClickerCRUDViewController *clickerView = [[ClickerCRUDViewController alloc] initWithStyle:UITableViewStylePlain];
    clickerView.clickerType = QUESTION_CREATE;
    [self.navigationController pushViewController:clickerView animated:YES];
}

@end
