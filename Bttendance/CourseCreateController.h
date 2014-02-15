//
//  SignUpController.h
//  Bttendance
//
//  Created by HAJE on 2013. 11. 19..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "AppDelegate.h"
#import "customCell.h"
#import "SignButtonCell.h"
#import "BttendanceColor.h"
#import "BTAPIs.h"

@interface CourseCreateController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSIndexPath *name_index, *number_index, *school_index;
    NSDictionary *user_info;
    NSInteger schoolId;
    __weak NSString *schoolName;
}


//@property (retain, nonatomic) IBOutlet UINavigationItem *navigation;

@property (strong, nonatomic) IBOutlet UIButton *create;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger schoolId;
@property (weak, nonatomic) NSString *schoolName;

-(IBAction)CreateButton:(id)sender;

-(void)JSONCreateCourseRequest:(NSString *)username :(NSString *)password :(NSString *)name :(NSString *)number :(NSString *)school_id;

@end
