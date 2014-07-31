//
//  GuideNoCourseViewController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ViewController.h"
#import "RESideMenu.h"

@interface NoCourseViewController : UIViewController <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *message1;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *message2;
@property (weak, nonatomic) IBOutlet UIButton *button2;

- (IBAction)addCourse:(id)sender;
- (IBAction)showGuide:(id)sender;

@end
