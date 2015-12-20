//
//  C4QSavedCatFactsTableViewController.m
//  
//
//  Created by Elber Carneiro on 12/19/15.
//
//

#import "C4QSavedCatFactsTableViewController.h"

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
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        NSMutableArray* savedCatFactsCopy = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"catFactsKey"] mutableCopy];
        [savedCatFactsCopy removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:savedCatFactsCopy forKey:@"catFactsKey"];
        
        self.savedCatFacts = savedCatFactsCopy;
        [self.tableView reloadData];
    }
}

@end
