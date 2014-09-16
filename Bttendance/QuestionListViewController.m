//
//  QuestionListViewController.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "QuestionListViewController.h"
#import "UIColor+Bttendance.h"
#import "UIImage+Bttendance.h"
#import "BTUserDefault.h"
#import "BTAPIs.h"
#import "QuestionCell.h"
#import "EditQuestionViewController.h"
#import "AddQuestionViewController.h"

@interface QuestionListViewController ()

@property (strong) NSArray *questions;

@end

@implementation QuestionListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backButtonItem];
    self.navigationItem.leftItemsSupplementBackButton = NO;
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor white:1.0];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Clicker Questions", @"");
    [titlelabel sizeToFit];
    
    self.questions = [NSArray array];
    
    [self.createBt setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:1.0]] forState:UIControlStateNormal];
    [self.createBt setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateHighlighted];
    [self.createBt setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateSelected];
    
    [self.createBt setTitle:NSLocalizedString(@"Add a Question", nil) forState:UIControlStateNormal];
    [self.createBt.titleLabel sizeToFit];
    
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.questions = [BTUserDefault getQuestions];
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });
    });
    
    self.tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 4)];
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 4)];
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
    
    return MAX(102, 42 + MessageLabelSize.size.height);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"QuestionCell";
    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.message.frame = CGRectMake(25, 21, 196, 60);
    cell.message.text = ((Question *)[self.questions objectAtIndex:indexPath.row]).message;
    cell.message.numberOfLines = 0;
    [cell.message sizeToFit];
    
    cell.choice.text = [NSString stringWithFormat:@"%ld", (long)((Question *)[self.questions objectAtIndex:indexPath.row]).choice_count];
    
    NSInteger height = MAX(102, 42 + cell.message.frame.size.height);
    cell.background_bg.frame = CGRectMake(11, 7, 298, height - 14);
    cell.selected_bg.frame = CGRectMake(11, 7, 298, height - 14);
    cell.choice_bg.frame = CGRectMake(239, 25 + (height - 102)/2, 52, 52);
    cell.choice_inner_bg.frame = CGRectMake(241, 27 + (height - 102)/2, 48, 48);
    cell.choice.frame = CGRectMake(241, 27 + (height - 102)/2, 48, 48);
    
    return cell;
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Question *question = [self.questions objectAtIndex:indexPath.row];
    EditQuestionViewController *editQuestion = [[EditQuestionViewController alloc] initWithNibName:@"EditQuestionViewController" bundle:nil];
    editQuestion.question = question;
    [self.navigationController pushViewController:editQuestion animated:YES];
}

#pragma IBAction
-(IBAction)create:(id)sender {
    AddQuestionViewController *addQuestion = [[AddQuestionViewController alloc] initWithNibName:@"AddQuestionViewController" bundle:nil];
    [self.navigationController pushViewController:addQuestion animated:YES];
}

@end
