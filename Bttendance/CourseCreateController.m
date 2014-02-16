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
@synthesize schoolId, schoolName, prfName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    createCourseRequest = [BTURL stringByAppendingString:@"/course/create"];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        name_index = [NSIndexPath indexPathForRow:0 inSection:0];
        number_index= [NSIndexPath indexPathForRow:1 inSection:0];
        school_index = [NSIndexPath indexPathForRow:3 inSection:0];
        profname_index = [NSIndexPath indexPathForRow:2 inSection:0];
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
    CustomCell *cell1 = (CustomCell *)[self.tableView cellForRowAtIndexPath:name_index];
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
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell contentView].backgroundColor = [BTColor BT_white:1];
    }
    
    switch(indexPath.row){
        case 0:{
            [[cell textLabel] setText:@"Name"];
            [[cell textLabel] setTextColor:[BTColor BT_black:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            
            [(CustomCell *)cell textfield].delegate = self;
            [(CustomCell *)cell textfield].returnKeyType = UIReturnKeyNext;
            [(CustomCell *)cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(CustomCell *)cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard
            
            [[(CustomCell *)cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *)cell textfield] setFont:[UIFont systemFontOfSize:15]];
            break;
        }
        case 1:{
            [[cell textLabel] setText:@"Number"];
            [[cell textLabel] setTextColor:[BTColor BT_black:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            
            [(CustomCell *)cell textfield].delegate = self;
            [(CustomCell *)cell textfield].returnKeyType = UIReturnKeyNext;
            [(CustomCell *)cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(CustomCell *)cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting
            
            [[(CustomCell *)cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *)cell textfield] setFont:[UIFont systemFontOfSize:15]];
            break;
        }
            
        case 2:{
            [[cell textLabel] setText:@"Professor"];
            [[cell textLabel] setTextColor:[BTColor BT_black:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            
            [(CustomCell *)cell textfield].enabled = YES;
            [(CustomCell *)cell textfield].text = self.prfName;
            [(CustomCell *)cell textfield].delegate = self;
            [(CustomCell *)cell textfield].returnKeyType = UIReturnKeyDone;
            [(CustomCell *)cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(CustomCell *)cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting
            
            [[(CustomCell *)cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *)cell textfield] setFont:[UIFont systemFontOfSize:15]];
            break;
        }
            
        case 3:{
            [[cell textLabel] setText:@"School"];
            [[cell textLabel] setTextColor:[BTColor BT_black:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            
            [(CustomCell *)cell textfield].enabled = NO;
            [(CustomCell *)cell textfield].text = self.schoolName;
            [(CustomCell *)cell textfield].delegate = self;
            [(CustomCell *)cell textfield].returnKeyType = UIReturnKeyNext;
            [(CustomCell *)cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(CustomCell *)cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting
            
            [[(CustomCell *)cell textfield] setTextColor:[BTColor BT_silver:1]];
            [[(CustomCell *)cell textfield] setFont:[UIFont systemFontOfSize:15]];
            break;
        }
        
        case 4:{
            static NSString *CellIdentifier1 = @"SignButtonCell";
            SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            
            if(cell_new == nil){
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
                cell_new = [topLevelObjects objectAtIndex:0];
            }
            
            [cell_new.button setTitle:@"Create Course" forState:UIControlStateNormal];
            cell_new.button.layer.cornerRadius = 3;
            [cell_new.button addTarget:self action:@selector(CreateButton:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell_new;
        }
        default:
            break;
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 4:
            return 78;
        default:
            return 44;
    }
}

-(IBAction)CreateButton:(id)sender{
    NSDictionary *userinfo = [BTUserDefault getUserInfo];
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    NSString *name = [((CustomCell *)[self.tableView cellForRowAtIndexPath:name_index]).textfield text];
    NSString *number = [((CustomCell *)[self.tableView cellForRowAtIndexPath:number_index]).textfield text];
    NSString *school = [((CustomCell *)[self.tableView cellForRowAtIndexPath:school_index]).textfield text];
    NSString *prfname = [((CustomCell *)[self.tableView cellForRowAtIndexPath:profname_index]).textfield text];
    NSString *sid = [NSString stringWithFormat:@"%d", self.schoolId];
    
    [self JSONCreateCourseRequest:username :password :name :number :sid :prfname];
    
    NSLog(@"name : %@",name);
    NSLog(@"number : %@",number);
    NSLog(@"school : %@",school);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSLog(@"return call!");
    
    if([textField isEqual:((CustomCell *)[self.tableView cellForRowAtIndexPath:name_index]).textfield]){
        [((CustomCell *)[self.tableView cellForRowAtIndexPath:number_index]).textfield becomeFirstResponder];
        return YES;
    }
    
    if([textField isEqual:((CustomCell *)[self.tableView cellForRowAtIndexPath:number_index]).textfield]){
        [((CustomCell *)[self.tableView cellForRowAtIndexPath:profname_index]).textfield becomeFirstResponder];
    }
    
    if([textField isEqual:((CustomCell *)[self.tableView cellForRowAtIndexPath:number_index]).textfield]){
        [((CustomCell *)[self.tableView cellForRowAtIndexPath:number_index]).textfield resignFirstResponder];
    }
    return NO;

}

-(void)JSONCreateCourseRequest:(NSString *)username :(NSString *)password :(NSString *)name :(NSString *)number :(NSString *)school_id :(NSString *)prfname{
    
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"name":name,
                             @"number":number,
                             @"school_id":school_id,
                             @"professor_name":prfname};
    
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
