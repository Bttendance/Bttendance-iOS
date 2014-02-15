//
//  Serial_Input.h
//  Bttendance
//
//  Created by HAJE on 2013. 12. 1..
//  Copyright (c) 2013년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customCell.h"
#import <AFNetworking.h>
#import "SignUpController.h"
#import "BTAPIs.h"
#import "BVUnderlineButton.h"
#import "BttendanceColor.h"

@interface SerialViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>{
    NSString *type;
    NSIndexPath *serialcode;
    UIButton *enterBt;
    
    Boolean isSignUp;
    NSInteger schoolId;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (readwrite, retain) NSString *type;
@property (nonatomic) Boolean isSignUp;
@property (nonatomic) NSInteger schoolId;

-(IBAction)enter:(id)sender;

@end
