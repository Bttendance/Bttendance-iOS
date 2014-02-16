//
//  SerialRequestViewController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 2. 15..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"

@interface SerialRequestViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    UIButton *enterBt;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
