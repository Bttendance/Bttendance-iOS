//
//  CreateClickerViewController.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 29..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateClickerViewController : UIViewController <UITextViewDelegate> {
    UIBarButtonItem *start;
}

@property(weak, nonatomic) NSString *cid;
@property(weak, nonatomic) IBOutlet UITextView *message;
@property(weak, nonatomic) IBOutlet UILabel *placeholder;

- (void)start_clicker;


@end
