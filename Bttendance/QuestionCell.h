//
//  QuestionCell.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 1..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionCell : UITableViewCell

+ (QuestionCell *)cellFromNibNamed;

@property(weak, nonatomic) IBOutlet UIView *background_bg;
@property(weak, nonatomic) IBOutlet UILabel *message;
@property(weak, nonatomic) IBOutlet UIView *choice_bg;
@property(weak, nonatomic) IBOutlet UIView *choice_inner_bg;
@property(weak, nonatomic) IBOutlet UILabel *choice;
@property(weak, nonatomic) IBOutlet UIView *selected_bg;

@end
