//
//  ChooseCountCell.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 8. 4..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseCountCell : UITableViewCell

+ (ChooseCountCell *)cellFromNibNamed;

@property (weak, nonatomic) IBOutlet UIView *bg2;
@property (weak, nonatomic) IBOutlet UIView *bg3;
@property (weak, nonatomic) IBOutlet UIView *bg4;
@property (weak, nonatomic) IBOutlet UIView *bg5;

@property (weak, nonatomic) IBOutlet UILabel *typeLable2;
@property (weak, nonatomic) IBOutlet UILabel *typeLable3;
@property (weak, nonatomic) IBOutlet UILabel *typeLable4;
@property (weak, nonatomic) IBOutlet UILabel *typeLable5;

@property (weak, nonatomic) IBOutlet UILabel *typeMessage2;
@property (weak, nonatomic) IBOutlet UILabel *typeMessage3;
@property (weak, nonatomic) IBOutlet UILabel *typeMessage4;
@property (weak, nonatomic) IBOutlet UILabel *typeMessage5;

@property (weak, nonatomic) IBOutlet UIButton *typeButton2;
@property (weak, nonatomic) IBOutlet UIButton *typeButton3;
@property (weak, nonatomic) IBOutlet UIButton *typeButton4;
@property (weak, nonatomic) IBOutlet UIButton *typeButton5;

@property (assign) int choice;

-(IBAction)chooseType2:(id)sender;
-(IBAction)chooseType3:(id)sender;
-(IBAction)chooseType4:(id)sender;
-(IBAction)chooseType5:(id)sender;

@end
