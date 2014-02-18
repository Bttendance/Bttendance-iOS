//
//  GradeView.m
//  bttendance
//
//  Created by HAJE on 2014. 1. 28..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import "GradeViewController.h"

@interface GradeViewController ()

@end

@implementation GradeViewController
@synthesize currentcell, cid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        userinfo = [BTUserDefault getUserInfo];
        rowcount = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"course_id":cid};
    
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    
    [AFmanager GET:[BTURL stringByAppendingString:@"/course/grades"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        data = responseObject;
        rowcount = data.count;
        [AFmanager GET:[BTURL stringByAppendingString:@"/course/students"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObejct){
            studentlist = responseObejct;
            
            [self.tableview reloadData];
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            
        }];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
    
};

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return rowcount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"GradeCell";
    
    GradeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"GradeCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for(int i = 0; i < studentlist.count; i++){
        if([[data objectAtIndex:indexPath.row] objectForKey:@"id"] == [[studentlist objectAtIndex:i] objectForKey:@"id"]){
            cell.name.text = [[studentlist objectAtIndex:i] objectForKey:@"full_name"];
            cell.idnumber.text = [[studentlist objectAtIndex:i] objectForKey:@"email"];
            NSArray* stringcomp = [[[data objectAtIndex:indexPath.row] objectForKey:@"grade"] componentsSeparatedByString:@"/"];
            cell.att.text = [stringcomp objectAtIndex:0];
            cell.tot.text = [stringcomp objectAtIndex:1];
            break;
        }
    }
    
    return cell;
}



@end
