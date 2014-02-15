//
//  CourseView.h
//  Bttendance
//
//  Created by HAJE on 2013. 12. 27..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "UserInfoCell.h"
#import "BTUserDefault.h"
#import "BTColor.h"
#import "BTAPIs.h"

@interface AttdStatView : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>{
    NSUInteger rowcount0;//for section 0
    NSUInteger rowcount1;//for section 1
    
    NSMutableArray *data0;
    NSMutableArray *data1;
    
    NSDictionary *userinfo;
    
    UserInfoCell *currentcell;
    
    Boolean viewscope;
 
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UITabBar *tab_bar;
@property (weak, nonatomic) IBOutlet UITabBarItem *Course;
@property (weak, nonatomic) IBOutlet UITabBarItem *Feed;


@property (assign, nonatomic) NSInteger postId;
@property (assign, nonatomic) NSInteger courseId;
@property (assign, nonatomic) NSString *courseName;


-(IBAction)check_button_action:(id)sender;

@end
