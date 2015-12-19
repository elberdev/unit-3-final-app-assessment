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
#import <AFNetworking/AFNetworking.h>

#define CAT_API_URL @"http://catfacts-api.appspot.com/api/facts?number=100"

@interface C4QCatFactsTableViewController ()

@property (strong, nonatomic) NSMutableArray *catFacts;

@end

@implementation C4QCatFactsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self retrieveCatFacts];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 12.0;
}

- (void)retrieveCatFacts {
    
    self.catFacts = [[NSMutableArray alloc] init];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/javascript"];
     
    [manager GET:CAT_API_URL
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     
             self.catFacts = [responseObject objectForKey:@"facts"];
              
             //NSLog(@"%@", self.catFacts);
             
             [self.tableView reloadData];
         }
      
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     
             NSLog(@"%@", error.userInfo);
         }
      
     ];
}

- (void)save:(UIButton *)sender {
    
    CGPoint point = [self.tableView convertPoint:CGPointZero fromView:sender];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *savedCatFacts = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"catFactsKey"]];
    NSLog(@"SAVED: %@", savedCatFacts);
    
    if (savedCatFacts == NULL) {
        
        savedCatFacts = [[NSMutableDictionary alloc] init];
    }
    
    [savedCatFacts setObject:self.catFacts[indexPath.row] forKey:self.catFacts[indexPath.row]];
    NSLog(@"UPDATED: %@", savedCatFacts);
    
    NSString *catFactsKey = @"catFactsKey";
    [defaults setObject:savedCatFacts forKey:catFactsKey];
    
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
    C4QCatFactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"catCell"];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"C4QCatFactsTableViewCell" bundle:nil] forCellReuseIdentifier:@"catCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"catCell"];
    }
    
    cell.catFactLabel.text = self.catFacts[indexPath.row];
    [cell.saveFactButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"detailSegueIdentifier" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    C4QCatFactsDetailViewController *detailVC = [segue destinationViewController];
    
    detailVC.catFact = self.catFacts[indexPath.row];
}

@end
