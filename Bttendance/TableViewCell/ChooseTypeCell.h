//
//  ChooseTypeCell.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 29..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseTypeCell : UITableViewCell

+ (ChooseTypeCell *)cellFromNibNamed;

@property (weak, nonatomic) IBOutlet UIImageView *typeImage1;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage2;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage3;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage4;

@property (weak, nonatomic) IBOutlet UILabel *typeLable1;
@property (weak, nonatomic) IBOutlet UILabel *typeLable2;
@property (weak, nonatomic) IBOutlet UILabel *typeLable3;
@property (weak, nonatomic) IBOutlet UILabel *typeLable4;

@property (weak, nonatomic) IBOutlet UIButton *typeButton1;
@property (weak, nonatomic) IBOutlet UIButton *typeButton2;
@property (weak, nonatomic) IBOutlet UIButton *typeButton3;
@property (weak, nonatomic) IBOutlet UIButton *typeButton4;

@property (weak, nonatomic) IBOutlet UIView *typeSelected;

@property (strong) NSString *type;

-(IBAction)chooseType1:(id)sender;
-(IBAction)chooseType2:(id)sender;
-(IBAction)chooseType3:(id)sender;
-(IBAction)chooseType4:(id)sender;

@end
