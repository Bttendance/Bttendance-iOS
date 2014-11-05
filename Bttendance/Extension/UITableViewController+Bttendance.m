//
//  UITableViewController+Bttendance.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 11. 4..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "UITableViewController+Bttendance.h"

@implementation UITableViewController (Bttendance)

- (void)initTableView {
    self.tableView.backgroundColor = [UIColor grey:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

@end
