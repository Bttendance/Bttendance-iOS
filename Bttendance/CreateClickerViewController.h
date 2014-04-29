//
//  CreateClickerViewController.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 29..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseCell.h"

@interface CreateClickerViewController : UIViewController <UITextViewDelegate> {
    __weak NSString *cid;
    __weak CourseCell *currentcell;
    UIBarButtonItem *start;
    
    NSString *Cid;
    
}

@property(weak, nonatomic) NSString *cid;
@property(weak, nonatomic) CourseCell *currentcell;
@property(weak, nonatomic) IBOutlet UITextView *message;
@property(weak, nonatomic) IBOutlet UILabel *placeholder;

- (void)start_clicker;


@end
