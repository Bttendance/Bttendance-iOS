//
//  SchoolView.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 1. 23..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SchoolChooseViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "BTUserDefault.h"
#import "BTColor.h"
#import "BTAPIs.h"
#import "CourseCreateViewController.h"

@interface SchoolChooseViewController ()

@end

@implementation SchoolChooseViewController
@synthesize auth;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rowcount0 = 0;
        rowcount1 = 0;
        sectionCount = 0;
        data0 = [[NSMutableArray alloc] init];
        data1 = [[NSMutableArray alloc] init];

        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backButtonItem];
        self.navigationItem.leftItemsSupplementBackButton = NO;
    }
    return self;
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    //set tableview background color
    [self tableview].backgroundColor = [BTColor BT_grey:1];

    //navigation title
    //set title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Choose School", @"");
    [titlelabel sizeToFit];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.tableview reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [BTAPIs allSchoolsAtSuccess:^(NSArray *schools) {
        NSArray *userschoollist;
        if (auth)
            userschoollist = [BTUserDefault getUser].employed_schools;
        else
            userschoollist = [BTUserDefault getUser].enrolled_schools;
        
        data0 = [[NSMutableArray alloc] init];
        data1 = [[NSMutableArray alloc] init];
        if (userschoollist.count != 0) {
            for (int i = 0; i < schools.count; i++) {
                Boolean joined = false;
                for (int j = 0; j < userschoollist.count; j++) {
                    NSInteger school_id = ((School *)[schools objectAtIndex:i]).id;
                    NSInteger userschool_id = ((SimpleSchool *)[userschoollist objectAtIndex:j]).id;
                    if (school_id == userschool_id) {
                        joined = true;
                        break;
                    }
                }
                
                if (joined)
                    [data0 addObject:[schools objectAtIndex:i]];
                else
                    [data1 addObject:[schools objectAtIndex:i]];
            }
            
            rowcount0 = data0.count;
            rowcount1 = data1.count;
            sectionCount = 0;
            if (rowcount0 > 0)
                sectionCount++;
            if (rowcount1 > 0)
                sectionCount++;
            [self.tableview reloadData];
            
        } else {
            data0 = nil;
            rowcount0 = 0;
            data1 = [NSMutableArray arrayWithArray:schools];
            rowcount1 = data1.count;
            sectionCount = 1;
            [self.tableview reloadData];
        }
    } failure:^(NSError *error) {
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (sectionCount == 2) {
        switch (section) {
            case 0:
                return rowcount0;
            case 1:
            default:
                return rowcount1;
        }
    } else if (sectionCount == 1) {
        if (rowcount0 > 0)
            return rowcount0;
        else
            return rowcount1;
    } else
        return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (sectionCount == 2) {
        switch (section) {
            case 0:
                if (auth)
                    return @"Employed Schools";
                else
                    return @"Enrolled Schools";
            case 1:
            default:
                return @"Joinable Schools";
        }
    } else if (sectionCount == 1) {
        if (rowcount0 > 0 && auth)
            return @"Employed Schools";
        else if (rowcount0 > 0 && !auth)
            return @"Enrolled Schools";
        else
            return @"Joinable Schools";
    } else
        return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (sectionCount == 2) {
        switch (indexPath.section) {
            case 0:
                return [self mySchoolCellWith:tableView at:indexPath.row];
            case 1:
            default:
                return [self otherSchoolCellWith:tableView at:indexPath.row];
        }
    } else if (sectionCount == 1) {
        if (rowcount0 > 0)
            return [self mySchoolCellWith:tableView at:indexPath.row];
        else
            return [self otherSchoolCellWith:tableView at:indexPath.row];
    } else
        return nil;
}

- (SchoolInfoCell *)mySchoolCellWith:(UITableView *)tableView at:(NSInteger)rowIndex {
    
    static NSString *CellIdentifier = @"SchoolInfoCell";
    SchoolInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SchoolInfoCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.school = [data0 objectAtIndex:rowIndex];
    cell.Info_SchoolName.text = cell.school.name;
    cell.Info_SchoolID.text = [cell.school.website absoluteString];
    cell.backgroundColor = [BTColor BT_white:1];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (SchoolInfoCell *)otherSchoolCellWith:(UITableView *)tableView at:(NSInteger)rowIndex {
    
    static NSString *CellIdentifier = @"SchoolInfoCell";
    SchoolInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SchoolInfoCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.school = [data1 objectAtIndex:rowIndex];
    cell.Info_SchoolName.text = cell.school.name;
    cell.Info_SchoolID.text = [cell.school.website absoluteString];
    cell.backgroundColor = [BTColor BT_white:1];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (auth) {
        CourseCreateViewController *courseCreateController = [[CourseCreateViewController alloc] initWithNibName:@"CourseCreateViewController" bundle:nil];
        courseCreateController.schoolId = ((SchoolInfoCell *) [self.tableview cellForRowAtIndexPath:indexPath]).school.id;
        courseCreateController.schoolName = ((SchoolInfoCell *) [self.tableview cellForRowAtIndexPath:indexPath]).school.name;
        courseCreateController.prfName = [BTUserDefault getUser].full_name;
        [self.navigationController pushViewController:courseCreateController animated:YES];
    } else {
    }
}

@end
