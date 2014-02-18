//
//  MainView.h
//  Bttendance
//
//  Created by HAJE on 2013. 12. 5..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseCell.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AFNetworking/AFNetworking.h>
#import "BTUserDefault.h"
#import "CourseAttendView.h"
#import "CourseInfoCell.h"
#import "BTColor.h"
#import "PostCell.h"
#import "ButtonCell.h"
#import "AppDelegate.h"
#import "CourseCreateController.h"
#import "AttdStatViewController.h"


@interface MainView : UIViewController<UITableViewDataSource, UITableViewDelegate, CBCentralManagerDelegate, CBPeripheralDelegate, CLLocationManagerDelegate, UITabBarDelegate, UITabBarControllerDelegate, UIAlertViewDelegate>{
    CBMutableService *myservice;
    CBPeripheralManager *myPmanager;
    CBCentralManager *myCmanager;
    CLLocationManager *locationmanager;
    Boolean locationcheck;
    
    NSDictionary *userinfo;
    
    NSMutableArray *data;
    
    NSString *pid;
    
    NSString *cid;
    
    NSString *my_id;
    
    
    
    PostCell *currentpostcell;
    
    CourseCell *currentcoursecell;
    
    NSUInteger rowcount;
    
    UITabBarController *tbc;
    
    int time;
    
    Boolean viewscope;
    
    Boolean first_launch;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UITabBar *tab_bar;
@property (weak, nonatomic) IBOutlet UITabBarItem *Feed;
@property (weak, nonatomic) IBOutlet UITabBarItem *Course;
@property (weak, nonatomic) IBOutlet UITabBarItem *Profile;

@property (weak, nonatomic) IBOutlet UIButton *ScanButton;
@property (weak, nonatomic) IBOutlet UIButton *StopButton;
@property (weak, nonatomic) IBOutlet UIButton *LocationButton;
@property (weak, nonatomic) IBOutlet UIButton *StopGps;
@property (weak, nonatomic) IBOutlet UIButton *AddRow;
@property (weak, nonatomic) IBOutlet UIButton *CourseCheck;

- (IBAction)ScanButton:(id)sender;
- (IBAction)StopButton:(id)sender;
- (IBAction)LocationButton:(id)sender;
- (IBAction)StopGps:(id)sender;
- (IBAction)AddRow:(id)sender;
- (IBAction)CourseCheck:(id)sender;
-(void)showing_timer:(CourseCell *)cell;
-(void)showing_timer_post:(PostCell *)cell;
-(void)change_check_simbol:(NSTimer *)timer;



@end
