//
//  ContactViewController.m
//  SB
//
//  Created by serlight on 12/5/14.
//  Copyright (c) 2014 soubu. All rights reserved.
//

#import "ContactViewController.h"
#import "Contact.h"
#import "NameIndex.h"
#import "ContactTableViewCell.h"
#import "ChatViewController.h"
#import "User.h"
#import "ShopViewController.h"
#import "AddFriendViewController.h"


@interface ContactViewController () <ContactCellDelegate, UISearchBarDelegate>{
    NSMutableArray *contactList;
    NSMutableArray *contactData;
    NSMutableArray *sectionTitles;
    NSIndexPath *expandIndexPath;
    BOOL isFirst;
    BOOL bSearch;
    NSMutableArray *searchContactList;
}

@end

@implementation ContactViewController

static UILocalizedIndexedCollation *theCollation;

- (void)viewDidLoad {
    [super viewDidLoad];
    isFirst = YES;
    sectionTitles = [NSMutableArray array];
    theCollation = [UILocalizedIndexedCollation currentCollation];
    UINib *nib = [UINib nibWithNibName:@"ContactTableViewCell" bundle:nil];
    [_contactView registerNib:nib forCellReuseIdentifier:@"contactCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutNotifier) name:LogOutNotifier object:nil];
    UIBarButtonItem *rightItem =  [[UIBarButtonItem alloc] initWithTitle:@"添加好友"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(addFriendTouch:)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"同步"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self action:@selector(syncContact)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)addFriendTouch:(id)sender {
    AddFriendViewController *vc = (AddFriendViewController *)[[AppDelegate sharedDelegate].secondStoryboard instantiateViewControllerWithIdentifier:@"AddFriendViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)syncContact {
    bSearch = NO;
    [self showHudInView:self.view hint:@"获取通讯录"];
    [Contact getFriendList:nil
                  callback:^(ResponseType responseType, id responseObj) {
                      [self hideHud];
                      isFirst = NO;
                      contactList = [responseObj mutableCopy];
                      [self serlizeName];
                      [_friendTableView reloadData];
                  }];
}

- (void)logOutNotifier {
    isFirst = YES;
    bSearch = NO;
    contactList = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    if (isFirst) {
        [self syncContact];
    }
}

- (void)serlizeName {
    contactData = [NSMutableArray array];
    sectionTitles = [NSMutableArray array];
    NSMutableArray *temp = [NSMutableArray array];
    
    NSInteger i= 0;
    NSArray *tempContactList = contactList;
    if (bSearch) {
        tempContactList = searchContactList;
    }
    for (NSDictionary *contact in tempContactList) {
        NameIndex *index = [[NameIndex alloc] init];
        NSString *firstName = contact[@"name"];
        index.firstName = firstName;
        index.originIndex = i;
        i ++;
        [temp addObject:index];
    }
    
    for (NameIndex *index in temp) {
        NSInteger sect = [theCollation sectionForObject:index collationStringSelector:@selector(getFirstName)];
        index.sectionNum = sect;
    }
    
    NSInteger maxSection = [theCollation sectionTitles].count;
    NSMutableArray *sectionArrays = [NSMutableArray array];
    for (int i = 0; i < maxSection; i ++) {
        NSMutableArray *sectionArray = [NSMutableArray array];
        [sectionArrays addObject:sectionArray];
    }
    
    for (NameIndex *contact in temp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:contact.sectionNum] addObject:contact];
    }
    i =0;
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray
                                            collationStringSelector:@selector(getFirstName)];
        if (sortedSection.count != 0) {
            NSString *title = [[UILocalizedIndexedCollation currentCollation] sectionTitles][i];
            [sectionTitles addObject:title];
            [contactData addObject:sortedSection];
        }
        i++;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return sectionTitles[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return contactData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (contactData.count == 0) {
        return 0;
    }
    return [contactData[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    NameIndex *index = contactData[indexPath.section][indexPath.row];
    NSArray *tempContactList = contactList;
    if (bSearch) {
        tempContactList = searchContactList;
    }
    cell.contactInfo = tempContactList[index.originIndex];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    if ([indexPath compare:expandIndexPath] == NSOrderedSame) {
        expandIndexPath = nil;
    } else {
        expandIndexPath = indexPath;
    }
    [tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath compare:expandIndexPath] == NSOrderedSame) {
        return 120;
    }
    return 60;
}

#pragma mark ContactCellDelegate

- (void)pushToChatViewController:(NSDictionary *)contactInfo {
    ChatViewController *chatView = [[ChatViewController alloc] initWithChatter:contactInfo[@"logid"] isGroup:NO];
    chatView.title = contactInfo[@"name"];
    self.hidesBottomBarWhenPushed = YES;
    UINavigationController *nav = (UINavigationController *)self.tabBarController.selectedViewController;
    self.tabBarController.selectedViewController.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:chatView animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

- (void)pushToShopViewController:(NSDictionary *)contactInfo {
    ShopViewController *shop = [[AppDelegate sharedDelegate].secondStoryboard instantiateViewControllerWithIdentifier:@"ShopViewController"];
    self.hidesBottomBarWhenPushed = YES;
    shop.userId = contactInfo[@"logid"];
    [self.navigationController pushViewController:shop  animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)deleContact:(NSIndexPath *)path {
    NameIndex *index = contactData[path.section][path.row];
    NSArray *tempContactList = contactList;
    if (bSearch) {
        tempContactList = searchContactList;
    }
    NSDictionary *contactInfo = tempContactList[index.originIndex];
    [self showHudInView:self.view hint:@"删除好友"];
    [User deleteOneFriend:contactInfo[@"logid"] block:^(ResponseType responseType, id responseObj) {
        [self hideHud];
        if (bSearch) {
            [searchContactList removeObjectAtIndex:index.originIndex];
        } else {
            [contactList removeObjectAtIndex:index.originIndex];
        }
        [self serlizeName];
        [_contactView reloadData];
    }];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![NSString bNoEmpty:searchBar.text]) {
        bSearch = NO;
        [self syncContact];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    bSearch = YES;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"logid contains[c] %@", searchBar.text];
    searchContactList = [[contactList filteredArrayUsingPredicate:predicate] mutableCopy];
    [self serlizeName];
    [_friendTableView reloadData];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
}

@end
