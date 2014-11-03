//
//  ClickerCRUDViewController.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 9. 18..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SLExpandableTableView.h>
#import "ChooseCountCell.h"
#import "Post.h"
#import "ClickerQuestion.h"
#import "ClickerOptionViewController.h"
#import "ClickerQuestionViewController.h"

typedef NS_ENUM(NSInteger, ClickerType) {
    CLICKER_CREATE,
    CLICKER_EDIT,
    QUESTION_CREATE,
    QUESTION_EDIT
};

@interface ClickerCRUDViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate, SLExpandableTableViewDatasource, SLExpandableTableViewDelegate, ChooseCountCellDelegate, ClickerOptionViewControllerDelegate, ClickerQuestionViewControllerDelegate>

@property (assign) ClickerType clickerType;
@property (strong) Post *post;
@property (strong) ClickerQuestion *question;
@property(assign) NSInteger courseID;

@end
