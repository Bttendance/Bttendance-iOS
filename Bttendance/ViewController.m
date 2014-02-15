//
//  ViewController.m
//  Bttendance
//
//  Created by HAJE on 2013. 11. 27..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        fullname_index = [NSIndexPath indexPathForRow:0 inSection:0];
        email_index = [NSIndexPath indexPathForRow:1 inSection:0];
        username_index = [NSIndexPath indexPathForRow:2 inSection:0];
        password_index = [NSIndexPath indexPathForRow:3 inSection:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    customCell *cell1 = (customCell *)[self.tableView cellForRowAtIndexPath:fullname_index];
    [cell1.textfield becomeFirstResponder];

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
        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell = [[customCell alloc] initWithFrame:CGRectZero];
        cell = [[customCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

//        [(customCell *)cell textfield].text = [NSString stringWithFormat:@"%d", indexPath.row];
    }
    
    switch(indexPath.row){
        case 0:
            [[cell textLabel] setText:@"Full name"];
            [(customCell *)cell textfield].placeholder = @"John Smith";

            break;
        case 1:
            [[cell textLabel] setText:@"Email"];
            [(customCell *)cell textfield].placeholder = @"example@example.com";
            break;
        case 2:
            [[cell textLabel] setText:@"User name"];
            [(customCell *)cell textfield].placeholder = @"@ID";
            break;
        case 3:
            [[cell textLabel] setText:@"Password"];
            [(customCell *)cell textfield].placeholder = @"Required";
            break;
        default:
            break;
    }
//    [[cell textLabel ] setText:[NSString stringWithFormat:@"I am cell %d", indexPath.row]];
    
    return cell;
}


@end
