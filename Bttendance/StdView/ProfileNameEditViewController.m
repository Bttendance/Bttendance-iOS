//
//  StdProfileNameEditView.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 22..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ProfileNameEditViewController.h"
#import "BTColor.h"
#import "ProfileViewController.h"
#import "BTAPIs.h"
#import "BTUserDefault.h"
#import <AFNetworking/AFNetworking.h>

@interface ProfileNameEditViewController ()

@end

@implementation ProfileNameEditViewController

@synthesize fullname;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save_fullname)];
    self.navigationItem.rightBarButtonItem = save;

    //Navigation title
    //set title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Edit Name", @"");
    [titlelabel sizeToFit];


    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_name_field becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)save_fullname {
    //save data in textfield to temp var;
    fullname = ((UITextField *) [[[self tableview] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].contentView.subviews objectAtIndex:0]).text;

    [BTAPIs updateFullName:fullname
                   success:^(User *user) {
                       [self.navigationController popViewControllerAnimated:YES];
                   } failure:^(NSError *error) {
                   }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NameEditCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    _name_field = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, 290, 44)];
//    name_field.text = fullname;
    ProfileViewController *parentView = (ProfileViewController *) [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    _name_field.text = parentView.fullname;
    _name_field.textColor = [BTColor BT_black:1];
    _name_field.tintColor = [BTColor BT_silver:1];
    _name_field.backgroundColor = [BTColor BT_white:1];
    _name_field.autocorrectionType = UITextAutocorrectionTypeNo;
    _name_field.keyboardType = UIKeyboardTypeDefault;
    _name_field.clearButtonMode = UITextFieldViewModeAlways;
    _name_field.returnKeyType = UIReturnKeyDone;
    _name_field.delegate = self;

    cell.contentView.backgroundColor = [BTColor BT_white:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:_name_field];

    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self save_fullname];
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Enter New name";
}

@end
