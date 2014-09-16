//
//  EditQuestionViewController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 8. 4..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@interface EditQuestionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UITextViewDelegate>

@property (strong) Question *question;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
