//
//  StdCourseView.m
//  bttendance
//
//  Created by HAJE on 2014. 1. 15..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import "CourseListViewController.h"

@interface CourseListViewController ()

@end

@implementation CourseListViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        data = [[NSMutableArray alloc] init];
        userinfo = [BTUserDefault getUserInfo];
        supervisingCourses = [userinfo objectForKey:SupervisingCoursesKey];
        attendingCourses = [userinfo objectForKey:AttendingCoursesKey];
    }
    
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [BTColor BT_grey:1];
    [self tableview].backgroundColor = [BTColor BT_grey:1];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    NSString *uuid = [userinfo objectForKey:UUIDKey];
    
    NSDictionary *params = @{@"username":username,
                             @"password":password,
                             @"device_uuid":uuid};
    NSDictionary *params_ = @{@"username":username,
                              @"password":password};
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [AFmanager GET:[BTURL stringByAppendingString:@"/user/auto/signin"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        [BTUserDefault setUserInfo:responseObject];

        userinfo = [BTUserDefault getUserInfo];
        supervisingCourses = [userinfo objectForKey:SupervisingCoursesKey];
        attendingCourses = [userinfo objectForKey:AttendingCoursesKey];
        
        [AFmanager GET:[BTURL stringByAppendingString:@"/user/courses"] parameters:params_ success:^(AFHTTPRequestOperation *operation, id responseObject){
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            data = responseObject;
            [self.tableview reloadData];
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            NSLog(@"Get User Courses Fail : %@", error);
        }];
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Supervising Courses";
        case 1:
        default:
            return @"Attending Courses";
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(18, 8, 284, 30);
    myLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, 320, 40);
    [headerView addSubview:myLabel];
    
    return headerView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            if(data.count !=0)
                return [supervisingCourses count] + 1;
            else
                return 0;
        case 1:
        default:
            if(data.count !=0)
                return [attendingCourses count] + 1;
            else
                return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == [supervisingCourses count]) {
                
                static NSString *CellIdentifier1 = @"ButtonCell";
                ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
                
                if(cell == nil){
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ButtonCell" owner:self options:nil];
                    cell = [topLevelObjects objectAtIndex:0];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [BTColor BT_grey:1];
                [cell.button addTarget:self action:@selector(move_to_school:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
            } else {
                
                static NSString *CellIdentifier = @"CourseCell";
                
                CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if(cell == nil){
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CourseCell" owner:self options:nil];
                    cell = [topLevelObjects objectAtIndex:0];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if(data.count != 0){
                    for (int i = 0 ; i< data.count; i++){
                        if( [[supervisingCourses objectAtIndex:indexPath.row] intValue] ==
                           [[[data objectAtIndex:i] objectForKey:@"id"] intValue]){
                            cell.CourseName.text = [[data objectAtIndex:indexPath.row] objectForKey:@"name"];
                            cell.Professor.text = [[data objectAtIndex:indexPath.row] objectForKey:@"professor_name"];
                            cell.School.text = [[data objectAtIndex:indexPath.row] objectForKey:@"school_name"];
                            cell.CourseID = [[[data objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
                            cell.backgroundColor = [BTColor BT_grey:1];
                            cell.cellbackground.backgroundColor = [BTColor BT_white:1];
                            cell.cellbackground.layer.cornerRadius = 2;
                            [cell.check_button addTarget:self action:@selector(attdStart:) forControlEvents:UIControlEventTouchUpInside];
                        }
                    }
                }
                
                return cell;
            }
        case 1:
        default:
            if (indexPath.row == [attendingCourses count]) {
                
                static NSString *CellIdentifier1 = @"ButtonCell";
                ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
                
                if(cell == nil){
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ButtonCell" owner:self options:nil];
                    cell = [topLevelObjects objectAtIndex:0];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [BTColor BT_grey:1];
                [cell.button addTarget:self action:@selector(move_to_school:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
            } else {
                
                static NSString *CellIdentifier = @"CourseCell";
                
                CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if(cell == nil){
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CourseCell" owner:self options:nil];
                    cell = [topLevelObjects objectAtIndex:0];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if(data.count != 0){
                    for(int i = 0; i< data.count; i++){
                        for(int j = 0; j < attendingCourses.count; j++){
                            if([[attendingCourses objectAtIndex:j] intValue] == [[[data objectAtIndex:i] objectForKey:@"id"] intValue]){
                                cell.CourseName.text = [[data objectAtIndex:i] objectForKey:@"name"];
                                cell.Professor.text = [[data objectAtIndex:i] objectForKey:@"professor_name"];
                                cell.School.text = [[data objectAtIndex:i] objectForKey:@"school_name"];
                                cell.CourseID = [[[data objectAtIndex:i] objectForKey:@"id"] intValue];
                                cell.backgroundColor = [BTColor BT_grey:1];
                                cell.cellbackground.backgroundColor = [BTColor BT_white:1];
                                cell.cellbackground.layer.cornerRadius = 2;
                                break;
                            }
                        }
                    }
                }
                return cell;
            }
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
            if(indexPath.row == [supervisingCourses count])
                return 71.0f;
            else
                return 102.0f;
        case 1:
        default:
            if(indexPath.row == [attendingCourses count])
                return 71.0f;
            else
                return 102.0f;
    }
}

-(void)move_to_school:(id)sender{
    
    UIButton *comingbutton = sender;
    ButtonCell *comingcell = (ButtonCell *)comingbutton.superview.superview.superview;
    
    SchoolChooseView *schoolChooseView = [[SchoolChooseView alloc] init];
    if([self.tableview indexPathForCell:comingcell].section == 0){
        //cell from section 0
        schoolChooseView.auth = YES;
    }
    else{
        //cell from section 1
        schoolChooseView.auth = NO;
    }
    [self.navigationController pushViewController:schoolChooseView animated:YES];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(data.count != 0){
        CourseCell *cell = (CourseCell *)[self.tableview cellForRowAtIndexPath:indexPath];
        CourseDetailViewController *courseDetailViewController = [[CourseDetailViewController alloc] initWithNibName:@"CourseDetailViewController" bundle:nil];
        courseDetailViewController.currentcell = cell;
        
        if(indexPath.section == 0){
            //section 0
            courseDetailViewController.auth = YES;
        }
        else{
            //section 1
            courseDetailViewController.auth = NO;
        }
        
        [self.navigationController pushViewController:courseDetailViewController animated:YES];
    }
}

-(void)move_to_course:(id)sender{
//    StdCourseDetailView *stdCourseDetailView = [[StdCourseDetailView alloc] init];
//    stdCourseDetailView.currentcell = (CourseCell *)[self.tableview cellForRowAtIndexPath:indexPath];
//    [self.navigationController pushViewController:stdCourseDetailView animated:YES];
}

-(void)attdStart:(id)sender{
    NSLog(@"attendance check start");
    
}


@end
