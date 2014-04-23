//
//  PostCell.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 1. 1..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCell : UITableViewCell {
}

+ (PostCell *)cellFromNibNamed:(NSString *)nibName;

@property(weak, nonatomic) IBOutlet UILabel *Title;
@property(weak, nonatomic) IBOutlet UILabel *Message;
@property(weak, nonatomic) IBOutlet UILabel *Date;

@property(assign, nonatomic) NSInteger PostID;
@property(assign, nonatomic) NSInteger CourseID;
@property(assign, nonatomic) NSString *CourseName;
@property(assign, nonatomic) Boolean isNotice;

@property(weak, nonatomic) IBOutlet UIView *background;
@property(weak, nonatomic) IBOutlet UIImageView *check_icon;
@property(weak, nonatomic) IBOutlet UIImageView *check_overlay;

@property(weak, nonatomic) IBOutlet UIView *cellbackground;

@property(assign, nonatomic) NSDate *createdDate;
@property(assign, nonatomic) NSInteger gap;

@property(assign, nonatomic) NSTimer *blink;
@property(assign, nonatomic) NSInteger blinkTime;

@end