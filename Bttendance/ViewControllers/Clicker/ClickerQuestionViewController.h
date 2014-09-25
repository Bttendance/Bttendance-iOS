//
//  ClickerQuestionViewController.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 2..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@protocol ClickerQuestionViewControllerDelegate <NSObject>

@required
- (void)chosenQuestion:(Question *)chosen;
@end

@interface ClickerQuestionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<ClickerQuestionViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(weak, nonatomic) IBOutlet UIButton *detailBt;
@property(assign) BOOL showDetailBt;
-(IBAction)showDetail:(id)sender;

@end
