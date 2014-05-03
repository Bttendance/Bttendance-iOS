//
//  NoticeView.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 28..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateNoticeViewController : UIViewController <UITextViewDelegate> {
    UIBarButtonItem *post;
}

@property(weak, nonatomic) NSString *cid;
@property(weak, nonatomic) IBOutlet UITextView *message;
@property(weak, nonatomic) IBOutlet UILabel *placeholder;

- (void)post_Notice;

@end
