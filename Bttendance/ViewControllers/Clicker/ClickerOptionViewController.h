//
//  ClickerOptionViewController.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 9. 17..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OptionType) {
    DEFAULT,
    CLICKER,
    QUESTION
};

@protocol ClickerOptionViewControllerDelegate <NSObject>

@required
- (void)chosenOptionTime:(NSInteger)progressTime andOnSelect:(BOOL)showInfoOnSelect andDetail:(NSString *)detailPrivacy;
@end

@interface ClickerOptionViewController : UITableViewController

@property (nonatomic, weak) id<ClickerOptionViewControllerDelegate> delegate;
@property(assign) NSInteger progressTime;
@property(assign) BOOL showInfoOnSelect;
@property(strong, nonatomic) NSString *detailPrivacy;
@property(assign) OptionType optionType;

@end
