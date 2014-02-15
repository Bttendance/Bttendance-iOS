//
//  ProfProfileNameEditView.h
//  bttendance
//
//  Created by HAJE on 2014. 1. 22..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTColor.h"
#import "ProfProfileView.h"

@interface ProfProfileNameEditView : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    __weak NSString *fullname;
    NSDictionary *userinfo;
}

@property (weak, nonatomic) NSString *fullname;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

-(void)save_fullnameppeev;

@end
