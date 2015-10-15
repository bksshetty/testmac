//
//  Image360ViewController.m
//  ClarksCollection
//
//  Created by Openly on 31/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "Image360ViewController.h"
#import "ImageDownloader.h"
#import "ClarksUI.h"

@interface Image360ViewController ()

@end

@implementation Image360ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *loadingView = [ClarksUI showLoader:self.view];
    
    [self loadAllImages:[self.itemColor.images360 mutableCopy] onComplete:^(NSMutableArray *theImages) {
        images = theImages;
        [loadingView removeFromSuperview];
        
        curImage = 0;
        
        UIPanGestureRecognizer *panRec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(imagePan:)];
        [self.imageView addGestureRecognizer:panRec];
        
        self.imageView.image = [UIImage imageWithData:images[curImage]];
    }];
}

- (void) loadAllImages: (NSMutableArray *)images360 onComplete:(void(^)(NSMutableArray *))handler{
    NSMutableArray *allImages = [[NSMutableArray alloc] init];
    if ([images360 count] < 1) {
        handler(allImages);
        return;
    }
    NSString *nextImage = [images360 firstObject];
    
    [images360 removeObjectAtIndex:0];
    
    [[ImageDownloader instance] priorityDownload:nextImage onComplete:^(NSData *theData) {
        if(theData != nil)
            [allImages addObject:theData];
        
        [self loadAllImages:images360 onComplete:^(NSArray *others) {
            [allImages addObjectsFromArray:others];
            handler(allImages);
        }];
    }];
}

- (void) swipeLeft{
    NSLog(@"Left swipe");
    curImage++;
    if(curImage >= [images count]){
        curImage = 0;
    }
    self.imageView.image = [UIImage imageWithData:images[curImage]];
}

- (void) swipeRight{
    NSLog(@"Right swipe");
    curImage--;
    if(curImage < 0){
        curImage = (int)[images count] - 1;
    }
        self.imageView.image = [UIImage imageWithData:images[curImage]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) imagePan :(UIPanGestureRecognizer *) sender{
    CGPoint pnt = [sender translationInView:self.imageView];
    float x = pnt.x;
    
    static float prevX;

    if (x > prevX + 20) {
        [self swipeRight];
    }else if(x < prevX - 20){
        [self swipeLeft];
    }
    
    if (x > prevX + 20 || x < prevX - 20) {
        prevX = x;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
