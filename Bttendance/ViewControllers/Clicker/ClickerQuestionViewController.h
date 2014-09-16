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

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, weak) id<ClickerQuestionViewControllerDelegate> delegate;

@end
