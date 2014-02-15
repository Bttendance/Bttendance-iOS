//
//  SignUpController.m
//  Bttendance
//
//  Created by HAJE on 2013. 11. 19..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import "CourseCreateController.h"

NSString *createCourseRequest;


@interface CourseCreateController ()
@end

@implementation CourseCreateController
@synthesize schoolId, schoolName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    createCourseRequest = [BTURL stringByAppendingString:@"/course/create"];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        name_index = [NSIndexPath indexPathForRow:0 inSection:0];
        number_index= [NSIndexPath indexPathForRow:1 inSection:0];
        school_index = [NSIndexPath indexPathForRow:2 inSection:0];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonSystemItemCancel target:self action:@selector(backbuttonpressed:)];
        self.navigationItem.leftItemsSupplementBackButton = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    //status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //Navigation title
    //set title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0];
    titlelabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Create Course", @"");
    [titlelabel sizeToFit];
    
    //Navigation showing
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"set autofocus");
    customCell *cell1 = (customCell *)[self.tableView cellForRowAtIndexPath:name_index];
    [cell1.textfield becomeFirstResponder];
    
}

-(void) viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void) viewWillAppear:(BOOL)animated{
    //Navigation showing
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[customCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell contentView].backgroundColor = [BttendanceColor BT_white:1];
    }
    
    switch(indexPath.row){
        case 0:{
            [[cell textLabel] setText:@"Name"];
            [[cell textLabel] setTextColor:[BttendanceColor BT_black:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            
            [(customCell *)cell textfield].delegate = self;
            [(customCell *)cell textfield].returnKeyType = UIReturnKeyNext;
            [(customCell *)cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(customCell *)cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard
            
            [[(customCell *)cell textfield] setTextColor:[BttendanceColor BT_black:1]];
            [[(customCell *)cell textfield] setFont:[UIFont systemFontOfSize:15]];
            break;
        }
        case 1:{
            [[cell textLabel] setText:@"Number"];
            [[cell textLabel] setTextColor:[BttendanceColor BT_black:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            
            [(customCell *)cell textfield].delegate = self;
            [(customCell *)cell textfield].returnKeyType = UIReturnKeyNext;
            [(customCell *)cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(customCell *)cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting
            
            [[(customCell *)cell textfield] setTextColor:[BttendanceColor BT_black:1]];
            [[(customCell *)cell textfield] setFont:[UIFont systemFontOfSize:15]];
            break;
        }
        case 2:{
            [[cell textLabel] setText:@"School"];
            [[cell textLabel] setTextColor:[BttendanceColor BT_black:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            
            [(customCell *)cell textfield].enabled = NO;
            [(customCell *)cell textfield].text = self.schoolName;
            [(customCell *)cell textfield].delegate = self;
            [(customCell *)cell textfield].returnKeyType = UIReturnKeyNext;
            [(customCell *)cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(customCell *)cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting
            
            [[(customCell *)cell textfield] setTextColor:[BttendanceColor BT_silver:1]];
            [[(customCell *)cell textfield] setFont:[UIFont systemFontOfSize:15]];
            break;
        }
        case 3:{
            static NSString *CellIdentifier1 = @"SignButtonCell";
            SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            
            if(cell_new == nil){
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
                cell_new = [topLevelObjects objectAtIndex:0];
            }
            
            [cell_new.button setTitle:@"Create Course" forState:UIControlStateNormal];
            cell_new.button.titleLabel.textColor = [BttendanceColor BT_navy:1];
            cell_new.button.layer.cornerRadius = 3;
            [cell_new.button addTarget:self action:@selector(CreateButton:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell_new;
        }
        default:
            break;
    }

    return cell;
}

-(IBAction)CreateButton:(id)sender{
    NSDictionary *userinfo = [BTUserDefault getUserInfo];
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    NSString *name = [((customCell *)[self.tableView cellForRowAtIndexPath:name_index]).textfield text];
    NSString *number = [((customCell *)[self.tableView cellForRowAtIndexPath:number_index]).textfield text];
    NSString *school = [((customCell *)[self.tableView cellForRowAtIndexPath:school_index]).textfield text];
    
    [self JSONCreateCourseRequest:username :password :name :number :@"1"];
    
    NSLog(@"name : %@",name);
    NSLog(@"number : %@",number);
    NSLog(@"school : %@",school);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSLog(@"return call!");
    
    if([textField isEqual:((customCell *)[self.tableView cellForRowAtIndexPath:name_index]).textfield]){
        [((customCell *)[self.tableView cellForRowAtIndexPath:number_index]).textfield becomeFirstResponder];
        return YES;
    }
    
    if([textField isEqual:((customCell *)[self.tableView cellForRowAtIndexPath:number_index]).textfield]){
        [((customCell *)[self.tableView cellForRowAtIndexPath:number_index]).textfield resignFirstResponder];
    }
    
    return NO;

}

-(void)JSONCreateCourseRequest:(NSString *)username :(NSString *)password :(NSString *)name :(NSString *)number :(NSString *)school_id{
    
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"name":name,
                             @"number":number,
                             @"school_id":school_id};
    
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    [AFmanager POST:createCourseRequest parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"Create Course success : %@", responseObject);
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"Create Course fail %@", error);
    }];

}

-(void)backbuttonpressed:(id)aResponder{
    //move to view which has index 1 in viewstack;
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
    
}

@end
