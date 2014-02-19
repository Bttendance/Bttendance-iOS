//
//  StdFeedView.m
//  bttendance
//
//  Created by HAJE on 2014. 1. 15..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController ()

@end

@implementation FeedViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        rowcount = 0;
        userinfo = [BTUserDefault getUserInfo];
        my_id = [userinfo objectForKey:UseridKey];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"NEWMESSAGE" object:nil];
        
        time = 180; //set time
        first_launch = true;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [BTColor BT_grey:1];
    [self tableview].backgroundColor = [BTColor BT_grey:1];
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    NSDictionary *params = @{@"username":username,
                             @"password":password};
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    [AFmanager GET:[BTURL stringByAppendingString:@"/user/feed"] parameters:params success:^(AFHTTPRequestOperation *operation, id responsObject){
        data = responsObject;
        rowcount = data.count;
        [_tableview reloadData];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return rowcount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 102.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //make post cell for student
    static NSString *CellIdentifierP = @"PostCell";
    
    rowcount = data.count;
    
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierP];
    
    if(cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.Title.text = [[data objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.Message.text = [[data objectAtIndex:indexPath.row] objectForKey:@"message"];
    
    cell.PostID = [[[data objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
    
    //time convert
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    
    NSDateFormatter *dm = [[NSDateFormatter alloc] init];
    [dm setTimeZone:[NSTimeZone timeZoneWithName:@"KST"]];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateformatter setTimeZone:gmt];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [dm setDateFormat:@"yy/MM/dd HH:mm"];
    NSDate *updatedAt = [dateformatter dateFromString:[[data objectAtIndex:indexPath.row] objectForKey:@"updatedAt"]];
    
    cell.Date.text = [dm stringFromDate:updatedAt];
    updatedAt = [dm dateFromString:cell.Date.text];
    
    NSTimeInterval secs = [updatedAt timeIntervalSinceNow];
    
    cell.gap = secs;
    
    cell.backgroundColor = [BTColor BT_grey:1];
    cell.cellbackground.backgroundColor = [BTColor BT_white:1];
    cell.cellbackground.layer.cornerRadius = 2;
    
    cell.timer = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if([[[data objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"notice"]){
        //notice
        [cell.check_icon setImage:[UIImage imageNamed:@"notice@2x.png"]];
        cell.isNotice = true;
        [cell.check_button setBackgroundImage:nil forState:UIControlStateNormal];
    } else {
        cell.isNotice = false;
    
        if(time + cell.gap <= 0){//time over;
            //check attendance completed
            NSArray *temp = [[data objectAtIndex:indexPath.row] objectForKey:@"checks"];
            Boolean check = false;
            for(int i = 0; i < temp.count ; i++){
                NSString *check_id = [NSString stringWithFormat:@"%@",[[[data objectAtIndex:indexPath.row] objectForKey:@"checks"]objectAtIndex:i]];
                if([my_id isEqualToString:check_id]){
                    check = true;
                }
            }
            if(!check){ // NOT ATTENDANCE!!!!
                //change image
                [cell.check_icon setImage:[UIImage imageNamed:@"attendfail@2x.png"]];
                [cell.check_button setBackgroundImage:Nil forState:UIControlStateNormal];
            }
        }
        else{//ongoing
            NSArray *temp = [[data objectAtIndex:indexPath.row] objectForKey:@"checks"];
            Boolean check = false;
            for(int i = 0; i < temp.count ; i++){
                NSString *check_id = [NSString stringWithFormat:@"%@",[[[data objectAtIndex:indexPath.row] objectForKey:@"checks"] objectAtIndex:i]];
                if([my_id isEqualToString:check_id]){
                    check = true;
                }
            }
            if(check){
                [cell.background setImage:nil];
            }
            else{
                [self showing_timer_post:cell];
            }
        }
    }
    return cell;
    
}
-(void)receiveMessage:(id)sender{
    
    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];
    NSDictionary *params = @{@"username":username,
                             @"password":password};
    
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    [AFmanager GET:[BTURL stringByAppendingString:@"/user/feed"] parameters:params success:^(AFHTTPRequestOperation *operation, id responsObject){
        data = responsObject;
        rowcount = data.count;
        [_tableview reloadData];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"get user's feeds fail : %@", error);
    }];
}

-(void)showing_timer_post:(PostCell *)cell{
    float a = -cell.gap;
    float ratio = a/(float)time;
    
    if(time > a){
        [cell.background setImage:[UIImage imageNamed:@"0072b0.png"]];
        
        CGRect frame1 = cell.background.frame;
        frame1.size.height = cell.background.frame.size.height*(1.0f - ratio);
        frame1.origin.y = cell.background.frame.origin.y + cell.background.frame.size.height*ratio;
        cell.background.frame = frame1;
        
        [UIImageView beginAnimations:nil context:NULL];
        [UIImageView setAnimationDuration:(time -a)];
        
        CGRect frame = cell.background.frame;
        frame.size.height = 0.0f;
        frame.origin.y = 77.0f;
        cell.background.frame = frame;
        [UIImageView commitAnimations];
        
        cell.timer = cell.timer - cell.gap;
        
        [cell.check_button addTarget:self action:@selector(send_attendance_check:) forControlEvents:UIControlEventTouchUpInside];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(change_check_post1:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:cell,@"cell", nil] repeats:YES];
        
    }
}
-(void)change_check_post:(NSTimer *)timer{
    PostCell *cell = [[timer userInfo] objectForKey:@"cell"];
    
    NSInteger i = cell.timer;
    
    if(i >= 2*time){
        [timer invalidate];
        timer = nil;
        i = 0;
    }
    
    int j = i%2;
    
    switch (j) {
        case 0:{
            cell.check_icon.alpha = 0;
            [UIImageView beginAnimations:nil context:NULL];
            [UIImageView setAnimationDuration:0.5];
            cell.check_icon.alpha = 1;
            [UIImageView commitAnimations];
            i++;
            cell.timer = i;
            break;
        }
        case 1:{
            cell.check_icon.alpha = 1;
            [UIImageView beginAnimations:nil context:NULL];
            [UIImageView setAnimationDuration:0.5];
            cell.check_icon.alpha = 0;
            [UIImageView commitAnimations];
            i++;
            cell.timer = i;
            break;
        }
        default:
            break;
    }
}

-(void)send_attendance_check:(id)sender{
    UIButton *send = (UIButton *)sender;
    PostCell *cell = (PostCell *)send.superview.superview.superview;
    
    currentpostcell = cell;
    pid = [NSString stringWithFormat:@"%ld", (long)cell.PostID];
    
    //disable button
    [cell.check_button removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
}

@end
