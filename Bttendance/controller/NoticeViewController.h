//
//  NoticeView.h
//  bttendance
//
//  Created by HAJE on 2014. 1. 28..
//  Copyright (c) 2014년 Utopia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTUserDefault.h"
#import "CourseCell.h"
#import <AFNetworking/AFNetworking.h>
#import "BTAPIs.h"

@interface NoticeViewController : UIViewController<UITextViewDelegate>{
    NSDictionary *userinfo;
    __weak NSString *cid;
    __weak CourseCell *currentcell;
    
    NSString *Cid;
    
}

@property (weak, nonatomic) NSString *cid;
@property (weak, nonatomic) CourseCell *currentcell;
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UITextView *message;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;
-(void)post_Notice;

@end
