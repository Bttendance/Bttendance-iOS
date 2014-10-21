//
//  GuideNoCourseViewController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "NoCourseViewController.h"
#import "UIColor+Bttendance.h"
#import "UIImage+Bttendance.h"
#import "GuidePageViewController.h"
#import "CourseCreateViewController.h"
#import "CourseAttendViewController.h"

@interface NoCourseViewController ()

@end

@implementation NoCourseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"No Course", nil);
    [titlelabel sizeToFit];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [menuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    [self.navigationItem setLeftBarButtonItem:menuButtonItem];
    
    self.title1.text = NSLocalizedString(@"아직 과목을 추가하지 않으셨군요!", nil);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7;
    
    NSString *string1 = NSLocalizedString(@"BTTENDANCE를 사용하기 위해서는\n과목을 개설하시거나(강의자)\n수강하셔야(학생) 합니다.", nil);
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:string1];
    [str1 addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:[string1 rangeOfString:string1]];
    self.message1.attributedText = str1;
    self.message1.numberOfLines = 0;
    self.message1.textAlignment = NSTextAlignmentCenter;
    
    NSString *string2 = NSLocalizedString(@"BTTENDANCE에 대해\n더 알고 싶으시다면", nil);
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:string2];
    [str2 addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:[string2 rangeOfString:string2]];
    self.message2.attributedText = str2;
    self.message2.numberOfLines = 0;
    self.message2.textAlignment = NSTextAlignmentCenter;
    
    self.line.frame = CGRectMake(47, 279, 226, 0.7);
    self.line.backgroundColor = [UIColor silver:0.7];
    
    [self.button1 setTitle:NSLocalizedString(@"과목 추가하기", nil) forState:UIControlStateNormal];
    [self.button2 setTitle:NSLocalizedString(@"가이드 보기", nil) forState:UIControlStateNormal];
    
    [self.button1 setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:1.0]] forState:UIControlStateNormal];
    [self.button1 setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateHighlighted];
    [self.button1 setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateSelected];
    
    [self.button2 setBackgroundImage:[UIImage imageWithColor:[UIColor silver:0.65]] forState:UIControlStateNormal];
    [self.button2 setBackgroundImage:[UIImage imageWithColor:[UIColor silver:0.45]] forState:UIControlStateHighlighted];
    [self.button2 setBackgroundImage:[UIImage imageWithColor:[UIColor silver:0.45]] forState:UIControlStateSelected];
    
    if ([[UIScreen mainScreen] bounds].size.height < 568) {
        self.title1.frame = CGRectMake(20, 28, 280, 16);
        self.message1.frame = CGRectMake(20, 54, 280, 88);
        self.button1.frame = CGRectMake(90, 149, 141, 48);
        self.line.frame = CGRectMake(47, 234, 226, 0.7);
        self.message2.frame = CGRectMake(20, 259, 280, 70);
        self.button2.frame = CGRectMake(90, 332, 141, 48);
    }
}

#pragma IBOutlet
- (void)addCourse:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Create Course", nil), NSLocalizedString(@"Attend Course", nil), nil];
    [actionSheet showInView:self.view];
}

-(void)showGuide:(id)sender
{
    GuidePageViewController *guidePage = [[GuidePageViewController alloc] initWithNibName:@"GuidePageViewController" bundle:nil];
    [self presentViewController:guidePage animated:NO completion:nil];
}

#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: { //create course
            CourseCreateViewController *courseCreateView = [[CourseCreateViewController alloc] initWithStyle:UITableViewStylePlain];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:courseCreateView] animated:YES completion:nil];
            break;
        }
        case 1: { //attend course
            CourseAttendViewController *courseAttendView = [[CourseAttendViewController alloc] initWithStyle:UITableViewStylePlain];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:courseAttendView] animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

@end
