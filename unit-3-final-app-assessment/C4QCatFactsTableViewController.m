//
//  C4QCatsTableViewController.m
//  unit-3-final-assessment
//
//  Created by Michael Kavouras on 12/17/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

#import "C4QCatFactsTableViewController.h"
#import "C4QCatFactsTableViewCell.h"
#import "C4QCatFactsDetailViewController.h"
#import "C4QSavedCatFactsTableViewController.h"
#import <AFNetworking/AFNetworking.h>

#define CAT_API_URL @"http://catfacts-api.appspot.com/api/facts?number=100"
#define CAT_FACTS_KEY @"catFactsKey"
#define DETAIL_SEGUE_IDENTIFIER @"detailSegueIdentifier"
#define CAT_CELL_IDENTIFIER @"catCell"

@interface C4QCatFactsTableViewController ()

@property (strong, nonatomic) NSMutableArray *catFacts;
@property (strong, nonatomic) NSMutableArray *savedCatFacts;

@end

@implementation C4QCatFactsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.catFacts = [[NSMutableArray alloc] init];
    self.savedCatFacts = [[NSMutableArray alloc] init];
    
    [self retrieveOnlineCatFacts];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 12.0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self retrieveSavedCatFacts];
    [self.tableView reloadData];
}

- (void)retrieveOnlineCatFacts {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/javascript"];
     
    [manager GET:CAT_API_URL
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     
             self.catFacts = [responseObject objectForKey:@"facts"];
             
             [self.tableView reloadData];
         }
      
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     
             NSLog(@"%@", error.userInfo);
         }
      
     ];
}

- (void)retrieveSavedCatFacts {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //[defaults removeObjectForKey:@"catFactsKey"];
    
    self.savedCatFacts = [NSMutableArray arrayWithArray:[defaults objectForKey:CAT_FACTS_KEY]];
    NSLog(@"SAVED: %@", self.savedCatFacts);
}

- (void)save:(UIButton *)sender {
    
    CGPoint point = [self.tableView convertPoint:CGPointZero fromView:sender];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    [self.savedCatFacts addObject:self.catFacts[indexPath.row]];
    NSLog(@"UPDATED: %@", self.savedCatFacts);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.savedCatFacts forKey:CAT_FACTS_KEY];
    
    [self.tableView reloadData];
    
    [self catAlert];
}

- (void)catAlert {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Saved"
                                                                   message:@"New cat fact saved!"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.catFacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    C4QCatFactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CAT_CELL_IDENTIFIER];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"C4QCatFactsTableViewCell" bundle:nil] forCellReuseIdentifier:CAT_CELL_IDENTIFIER];
        cell = [tableView dequeueReusableCellWithIdentifier:CAT_CELL_IDENTIFIER];
    }
    
    cell.catFactLabel.text = self.catFacts[indexPath.row];
    
    if ([self.savedCatFacts containsObject:cell.catFactLabel.text]) {
        cell.saveFactButton.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.saveFactButton.hidden = NO;
        [cell.saveFactButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:DETAIL_SEGUE_IDENTIFIER sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:DETAIL_SEGUE_IDENTIFIER]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        C4QCatFactsDetailViewController *detailVC = [segue destinationViewController];
        detailVC.catFact = self.catFacts[indexPath.row];
        
    } else {
        
        C4QSavedCatFactsTableViewController *savedTVC = [segue destinationViewController];
        savedTVC.savedCatFacts = self.savedCatFacts;
    }
}

@end
