//
//  StdMainView.h
//  Bttendance
//
//  Created by HAJE on 2013. 12. 26..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseCell.h"
#import <CoreBluetooth/CoreBluetooth.h>
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
#import "AttdStatView.h"

@interface MainViewController : UIViewController{
    IBOutlet UITabBarController *tbc;
}

@end
