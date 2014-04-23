//
//  GradeView.m
//  bttendance
//
//  Created by HAJE on 2014. 1. 28..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import "GradeViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "BTUserDefault.h"
#import "GradeCell.h"
#import "BTAPIs.h"

@interface GradeViewController ()

@end

@implementation GradeViewController
@synthesize currentcell, cid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        userinfo = [BTUserDefault getUserInfo];
        rowcount = 0;

        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 9.5, 15)];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backButtonItem];
        self.navigationItem.leftItemsSupplementBackButton = NO;
    }
    return self;
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = @"Grade";
    [titlelabel sizeToFit];

    // Do any additional setup after loading the view from its nib.
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];

    NSDictionary *params = @{@"username" : username,
            @"password" : password,
            @"course_id" : cid};

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    [AFmanager GET:[BTURL stringByAppendingString:@"/course/grades"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        data = responseObject;
        rowcount = data.count;
        [self.tableview reloadData];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    }      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];

};

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rowcount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 53;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"GradeCell";

    GradeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"GradeCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = [[data objectAtIndex:indexPath.row] objectForKey:@"full_name"];
    cell.idnumber.text = [[data objectAtIndex:indexPath.row] objectForKey:@"student_id"];
    NSArray *stringcomp = [[[data objectAtIndex:indexPath.row] objectForKey:@"grade"] componentsSeparatedByString:@"/"];
    cell.att.text = [stringcomp objectAtIndex:0];
    cell.tot.text = [stringcomp objectAtIndex:1];

    return cell;
}


@end
