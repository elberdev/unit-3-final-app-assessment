//
//  C4QCatFactDetailViewController.m
//  unit-3-final-app-assessment
//
//  Created by Michael Kavouras on 12/18/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

#import "C4QCatFactsDetailViewController.h"
#import <SDWebImage/SDWebImageDownloader.h>
#import <AFNetworking/AFNetworking.h>

#define CAT_GIF_URL @"http://api.giphy.com/v1/gifs/search?q=funny+cat&api_key=dc6zaTOxFJmzC"

@interface C4QCatFactsDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *catFactLabel;
@property (weak, nonatomic) IBOutlet UIImageView *catImageView;

@end

@implementation C4QCatFactsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.catFactLabel.text = self.catFact;
    
    [self loadImage];

}

- (void)loadImage {
    
    [self fetchRandomImageURL];
}

- (void)fetchRandomImageURL {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:CAT_GIF_URL
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSArray *data = responseObject[@"data"];
             NSDictionary *random = data[arc4random_uniform((uint32_t)data.count)];
             NSDictionary *images = random[@"images"];
             NSDictionary *fixedHeightStill = images[@"fixed_height_still"];
             NSString *urlString = fixedHeightStill[@"url"];
             
             NSLog(@"%@", urlString);
             
             [self asyncImageLoad:urlString];
             
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             NSLog(@"%@", error.userInfo);
         }
     
     ];
}

- (void)asyncImageLoad:(NSString *)urlString {
    
        NSURL *url = [NSURL URLWithString:urlString];
    
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:url
                                                            options:0
                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             // progression tracking code
         }
                                                          completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
         {
             if (image && finished)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     self.catImageView.image = image;
                     [self.view setNeedsDisplay];
                 });
             }
         }];
}

@end
