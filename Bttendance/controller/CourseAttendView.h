//
//  CourseView.h
//  Bttendance
//
//  Created by HAJE on 2013. 12. 27..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "CourseInfoCell.h"
#import "BTUserDefault.h"
#import "BttendanceColor.h"
#import "BTAPIs.h"

@interface CourseAttendView : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>{
    NSUInteger rowcount0;//for section 0
    NSUInteger rowcount1;//for section 1
    
    NSMutableArray *data0;
    NSMutableArray *data1;
    
    NSDictionary *userinfo;
    
    CourseInfoCell *currentcell;
    
    int sid;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic) int sid;

-(IBAction)check_button_action1:(id)sender;

@end