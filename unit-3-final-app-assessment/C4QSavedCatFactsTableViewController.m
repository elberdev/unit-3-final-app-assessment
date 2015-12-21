//
//  C4QSavedCatFactsTableViewController.m
//  
//
//  Created by Elber Carneiro on 12/19/15.
//
//

#import "C4QSavedCatFactsTableViewController.h"

#define CAT_FACTS_KEY @"catFactsKey"

@interface C4QSavedCatFactsTableViewController ()

@end

@implementation C4QSavedCatFactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.savedCatFacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.savedCatFacts[indexPath.row];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        NSMutableArray* savedCatFactsCopy = [[[NSUserDefaults standardUserDefaults] arrayForKey:CAT_FACTS_KEY] mutableCopy];
        [savedCatFactsCopy removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:savedCatFactsCopy forKey:CAT_FACTS_KEY];
        
        self.savedCatFacts = savedCatFactsCopy;
        [self.tableView reloadData];
    }
}

@end
