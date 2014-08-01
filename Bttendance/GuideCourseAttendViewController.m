//
//  GuideCourseAttendViewController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "GuideCourseAttendViewController.h"
#import "BTColor.h"

@interface GuideCourseAttendViewController ()

@property (strong) UILabel *message1;
@property (strong) UILabel *message2;
@property (strong) UILabel *message3;
@property (strong) UILabel *message4;

@end

@implementation GuideCourseAttendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.message1 = [[UILabel alloc]initWithFrame:CGRectMake(82, 12, 212, 60)];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle1.lineSpacing = 7;
    NSString *string1 = NSLocalizedString(@"강의자가 BTTENDANCE의 기능을 사용하면 강의정보 밑의 피드를 확인 해서 참여하세요.", nil);
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:string1];
    [str1 addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle1} range:[string1 rangeOfString:string1]];
    self.message1.attributedText = str1;
    self.message1.numberOfLines = 0;
    self.message1.font = [UIFont systemFontOfSize:14];
    self.message1.textColor = [BTColor BT_black:1.0];
    [self.message1 sizeToFit];
    
    self.message2 = [[UILabel alloc]initWithFrame:CGRectMake(82, 12, 212, 60)];
    NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle2.lineSpacing = 7;
    NSString *string2 = NSLocalizedString(@"각 피드를 누르면 세부 정보를 볼 수 있습니다.", nil);
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:string2];
    [str2 addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle2} range:[string2 rangeOfString:string2]];
    self.message2.attributedText = str2;
    self.message2.numberOfLines = 0;
    self.message2.font = [UIFont systemFontOfSize:14];
    self.message2.textColor = [BTColor BT_black:1.0];
    [self.message2 sizeToFit];
    
    self.message3 = [[UILabel alloc]initWithFrame:CGRectMake(82, 12, 212, 60)];
    NSMutableParagraphStyle *paragraphStyle3 = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle3.lineSpacing = 7;
    NSString *string3 = NSLocalizedString(@"BTTENDANCE의 출석체크 기능은 Bluetooth를 사용하므로, 출석할 때는 꼭 Bluetooth를 켜주세요.", nil);
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:string3];
    [str3 addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle3} range:[string3 rangeOfString:string3]];
    self.message3.attributedText = str3;
    self.message3.numberOfLines = 0;
    self.message3.font = [UIFont systemFontOfSize:14];
    self.message3.textColor = [BTColor BT_black:1.0];
    [self.message3 sizeToFit];
    
    self.message4 = [[UILabel alloc]initWithFrame:CGRectMake(82, 12, 212, 60)];
    NSMutableParagraphStyle *paragraphStyle4 = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle4.lineSpacing = 7;
    NSString *string4 = NSLocalizedString(@"수업시간 중에는 BTTENDANCE 외에 다른 용도로 스마트폰을 쓰는 걸 자제해주세요 ㅜㅜ", nil);
    NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc] initWithString:string4];
    [str4 addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle4} range:[string4 rangeOfString:string4]];
    self.message4.attributedText = str4;
    self.message4.numberOfLines = 0;
    self.message4.font = [UIFont systemFontOfSize:14];
    self.message4.textColor = [BTColor BT_black:1.0];
    [self.message4 sizeToFit];
    
    [self.nextBt setBackgroundImage:[BTColor imageWithCyanColor:1.0] forState:UIControlStateNormal];
    [self.nextBt setBackgroundImage:[BTColor imageWithCyanColor:0.85] forState:UIControlStateHighlighted];
    [self.nextBt setBackgroundImage:[BTColor imageWithCyanColor:0.85] forState:UIControlStateSelected];
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    //all view component fade in
    self.tableview.alpha = 0;
    self.nextBt.alpha = 0;
    [UIImageView beginAnimations:nil context:NULL];
    [UIImageView setAnimationDuration:1];
    self.tableview.alpha = 1;
    self.nextBt.alpha = 1;
    [UIImageView commitAnimations];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

#pragma mark UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 127;
        case 1:
            return 60;
        case 2:
            return 24 + MAX(41, self.message1.frame.size.height);
        case 3:
            return 24 + MAX(41, self.message2.frame.size.height);
        case 4:
            return 24 + MAX(41, self.message3.frame.size.height);
        case 5:
            return 24 + MAX(41, self.message4.frame.size.height);
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 127)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [BTColor BT_navy:1.0];
            
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 38, 280, 90)];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 8;
            NSString *string = NSLocalizedString(@"강의에 성공적으로\n등록되었습니다!", nil);
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
            [str addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:[string rangeOfString:string]];
            title.attributedText = str;
            title.numberOfLines = 0;
            title.font = [UIFont systemFontOfSize:28];
            title.textColor = [BTColor BT_white:1.0];
            [title sizeToFit];
            title.textAlignment = NSTextAlignmentCenter;
            [title setFrame:CGRectMake(20, 26, 280, title.frame.size.height)];
            [cell addSubview:title];
            
            return cell;
        }
        case 1: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [BTColor BT_white:1.0];
            
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 28, 320, 20)];
            title.text = NSLocalizedString(@"BTTENDANCE를 잘 사용하는 법", nil);
            title.font = [UIFont boldSystemFontOfSize:18];
            title.textAlignment = NSTextAlignmentCenter;
            title.textColor = [BTColor BT_navy:1.0];
            [cell addSubview:title];
            
            return cell;
        }
        case 2: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 24 + MAX(41, self.message1.frame.size.height))];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [BTColor BT_white:1.0];
            
            UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(30, 2, 30, 60)];
            number.text = @"1";
            number.font = [UIFont boldSystemFontOfSize:49];
            number.textAlignment = NSTextAlignmentCenter;
            number.textColor = [BTColor BT_navy:1.0];
            [cell addSubview:number];
            
            [cell addSubview:self.message1];
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(72, 15, 1.5, self.message1.frame.size.height - 4)];
            line.backgroundColor = [BTColor BT_navy:1];
            [cell addSubview:line];
            
            return cell;
        }
        case 3: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 24 + MAX(41, self.message2.frame.size.height))];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [BTColor BT_white:1.0];
            
            UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(30, 2, 30, 60)];
            number.text = @"2";
            number.font = [UIFont boldSystemFontOfSize:49];
            number.textAlignment = NSTextAlignmentCenter;
            number.textColor = [BTColor BT_navy:1.0];
            [cell addSubview:number];
            
            [cell addSubview:self.message2];
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(72, 15, 1.5, self.message2.frame.size.height - 4)];
            line.backgroundColor = [BTColor BT_navy:1];
            [cell addSubview:line];
            
            return cell;
        }
        case 4: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 24 + MAX(41, self.message3.frame.size.height))];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [BTColor BT_white:1.0];
            
            UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(30, 2, 30, 60)];
            number.text = @"3";
            number.font = [UIFont boldSystemFontOfSize:49];
            number.textAlignment = NSTextAlignmentCenter;
            number.textColor = [BTColor BT_navy:1.0];
            [cell addSubview:number];
            
            [cell addSubview:self.message3];
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(72, 15, 1.5, self.message3.frame.size.height - 4)];
            line.backgroundColor = [BTColor BT_navy:1];
            [cell addSubview:line];
            
            return cell;
        }
        case 5: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 24 + MAX(41, self.message4.frame.size.height))];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [BTColor BT_white:1.0];
            
            UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(30, 2, 30, 60)];
            number.text = @"4";
            number.font = [UIFont boldSystemFontOfSize:49];
            number.textAlignment = NSTextAlignmentCenter;
            number.textColor = [BTColor BT_navy:1.0];
            [cell addSubview:number];
            
            [cell addSubview:self.message4];
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(72, 15, 1.5, self.message3.frame.size.height - 4)];
            line.backgroundColor = [BTColor BT_navy:1];
            [cell addSubview:line];
            
            return cell;
        }
        default: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [BTColor BT_white:1.0];
            return cell;
        }
    }
}

#pragma IBAction
- (IBAction)next:(id)sender {
    self.tableview.alpha = 1;
    self.nextBt.alpha = 1;
    [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tableview.alpha = 0;
        self.nextBt.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end
