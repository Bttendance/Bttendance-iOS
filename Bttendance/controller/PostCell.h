//
//  PostCell.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 1. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface PostCell : UITableViewCell {
}

+ (PostCell *)cellFromNibNamed:(NSString *)nibName;

@property(weak, nonatomic) IBOutlet UILabel *Title;
@property(weak, nonatomic) IBOutlet UILabel *Message;
@property(weak, nonatomic) IBOutlet UILabel *Date;

@property(weak, nonatomic) IBOutlet UIView *background;
@property(weak, nonatomic) IBOutlet UIImageView *check_icon;
@property(weak, nonatomic) IBOutlet UIImageView *check_overlay;

@property(weak, nonatomic) IBOutlet UIView *cellbackground;

@property(retain, nonatomic) Post *post;
@property(assign, nonatomic) NSInteger gap;

@property(retain, nonatomic) NSTimer *blink;
@property(assign, nonatomic) NSInteger blinkTime;

@end