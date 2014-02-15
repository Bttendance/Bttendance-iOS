//
//  SignButtonCell.h
//  bttendance
//
//  Created by HAJE on 2014. 1. 4..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignButtonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *button;

+(SignButtonCell *)cellFromNibNamed:(NSString *)nibName;


@end
