//
//  SchoolView.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 1. 23..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SchoolChooseViewController.h"
#import "UIViewController+Bttendance.h"
#import "CourseCreateViewController.h"

@interface SchoolChooseViewController ()

@end

@implementation SchoolChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftMenu:LeftMenuType_Back];
    
    rowcount0 = 0;
    rowcount1 = 0;
    sectionCount = 0;
    sortedSchools = [[NSMutableArray alloc] init];
    searchedSchools = [[NSMutableArray alloc] init];
    data0 = [[NSMutableArray alloc] init];
    data1 = [[NSMutableArray alloc] init];
    
    [self.createSchoolBt setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:1.0]] forState:UIControlStateNormal];
    [self.createSchoolBt setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateHighlighted];
    [self.createSchoolBt setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateSelected];
    [self.createSchoolBt setTitle:NSLocalizedString(@"찾고있는 학교나 단체가 목록에 없나요?", nil) forState:UIControlStateNormal];
    
    [BTDatabase getSchoolsWithData:^(NSArray *schools) {
        [self reloadTable:schools];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification Handlers
- (void)keyboardDidShow:(NSNotification *)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.view setFrame:CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height - kbSize.height - 64)];
    [self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    [self.view setFrame:CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height - 64)];
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 275, 44)];
    self.searchbar.keyboardType = UIKeyboardTypeAlphabet;
    self.searchbar.barTintColor = [UIColor navy:1.0];
    self.searchbar.searchTextPositionAdjustment = UIOffsetMake(0, 0);
    self.searchbar.barStyle = UIBarStyleDefault;
    self.searchbar.placeholder = NSLocalizedString(@"Search", nil);
    self.searchbar.delegate = self;
    self.navigationItem.titleView = self.searchbar;
    
    [BTAPIs allSchoolsAtSuccess:^(NSArray *schools) {
        [self reloadTable:schools];
    } failure:^(NSError *error) {
    }];
}

- (void)reloadTable:(NSArray *)schools {
    if (schools == nil) {
        return;
    }
    
    NSArray *sorting = [schools sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSInteger first = ((School *)a).courses_count;
        NSInteger second = ((School *)b).courses_count;
        if (first < second)
            return (NSComparisonResult)NSOrderedDescending;
        else
            return (NSComparisonResult)NSOrderedAscending;
    }];
    sortedSchools = [NSMutableArray arrayWithArray:sorting];
    
    NSArray *userschoollist = [[BTDatabase getUser] getAllSchools];
    data0 = [[NSMutableArray alloc] init];
    data1 = [[NSMutableArray alloc] init];
    if (userschoollist.count != 0) {
        for (int i = 0; i < sortedSchools.count; i++) {
            Boolean joined = false;
            for (int j = 0; j < userschoollist.count; j++) {
                NSInteger schoolID = ((School *)[sortedSchools objectAtIndex:i]).id;
                NSInteger userschoolID = ((SimpleSchool *)[userschoollist objectAtIndex:j]).id;
                if (schoolID == userschoolID) {
                    joined = true;
                    break;
                }
            }
            
            if (joined)
                [data0 addObject:[sortedSchools objectAtIndex:i]];
            else
                [data1 addObject:[sortedSchools objectAtIndex:i]];
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
        data1 = [NSMutableArray arrayWithArray:sortedSchools];
        rowcount1 = data1.count;
        sectionCount = 1;
        [self.tableview reloadData];
    }
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchbar.text.length == 0)
        return sectionCount;
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchbar.text.length != 0)
        return [searchedSchools count];
    else if (sectionCount == 2) {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchbar.text.length != 0)
        return [self searchedSchoolCellWith:tableView at:indexPath.row];
    else if (sectionCount == 2) {
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

- (SchoolInfoCell *)searchedSchoolCellWith:(UITableView *)tableView at:(NSInteger)rowIndex {
    
    static NSString *CellIdentifier = @"SchoolInfoCell";
    SchoolInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SchoolInfoCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.school = [searchedSchools objectAtIndex:rowIndex];
    cell.Info_SchoolName.text = cell.school.name;
    cell.Info_SchoolID.text = [NSString stringWithFormat:NSLocalizedString(@"%d Courses", nil)
                               , cell.school.courses_count];
    cell.backgroundColor = [UIColor white:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.arrow.hidden = YES;
    
    return cell;
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
    cell.Info_SchoolID.text = [NSString stringWithFormat:NSLocalizedString(@"%d Courses", nil)
                               , cell.school.courses_count];
    cell.backgroundColor = [UIColor white:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.arrow.hidden = YES;
    
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
    cell.Info_SchoolID.text = [NSString stringWithFormat:NSLocalizedString(@"%d Courses", nil)
                               , cell.school.courses_count];
    cell.backgroundColor = [UIColor white:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.arrow.hidden = YES;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *cell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    cell.backgroundColor = [UIColor grey:1.0];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(14, 8, 280, 14)];
    title.font = [UIFont boldSystemFontOfSize:12];
    title.textColor = [UIColor silver:1.0];
    [cell addSubview:title];
    
    if (self.searchbar.text.length != 0)
        title.text = NSLocalizedString(@"Searched Schools", nil);
    else if (sectionCount == 2) {
        switch (section) {
            case 0:
                title.text = NSLocalizedString(@"My Schools", nil);
                break;
            case 1:
            default:
                title.text = NSLocalizedString(@"Other Schools", nil);
                break;
        }
    } else if (sectionCount == 1) {
        if (rowcount0 > 0)
            title.text = NSLocalizedString(@"My Schools", nil);
        else
            title.text = NSLocalizedString(@"Other Schools", nil);
    } else
        cell.frame = CGRectMake(0, 0, 320, 0);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate chosenSchool:((SchoolInfoCell *) [self.tableview cellForRowAtIndexPath:indexPath]).school];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma IBAction
- (IBAction)createSchool:(id)sender {
    SchoolCreateViewController *createSchool = [[SchoolCreateViewController alloc] initWithNibName:@"SchoolCreateViewController" bundle:nil];
    createSchool.delegate = self;
    [self.navigationController pushViewController:createSchool animated:YES];
}

#pragma SchoolCreateViewControllerDelegate
- (void)createdSchool:(School *)created {
    [self.delegate chosenSchool:created];
}

#pragma UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *search = [self.searchbar.text lowercaseString];
    searchedSchools = [[NSMutableArray alloc] init];
    for (School *school in sortedSchools)
        if ([[school.name lowercaseString] rangeOfString:search].length != 0)
            [searchedSchools addObject:school];
    [self.tableview reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

@end
