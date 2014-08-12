//
//  NoticeView.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 28..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateNoticeViewController : UIViewController <UITextViewDelegate>

@property(retain, nonatomic) NSString *cid;
@property(weak, nonatomic) IBOutlet UITextView *message;
@property(weak, nonatomic) IBOutlet UILabel *placeholder;
@property(weak, nonatomic) IBOutlet UILabel *information;

- (void)post_Notice;

@end
