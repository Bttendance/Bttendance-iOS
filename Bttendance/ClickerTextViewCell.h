//
//  ClickerTextViewCell.h
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 8. 4..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClickerTextViewCellDelegate;

@interface ClickerTextViewCell : UITableViewCell<UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UITextView *inputField;
@property (nonatomic, weak) id<ClickerTextViewCellDelegate> delegate;
@end

@protocol ClickerTextViewCellDelegate <NSObject>
- (void)growingCell:(ClickerTextViewCell *)cell didChangeSize:(CGSize)size;

@end