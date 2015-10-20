//
//  MarketingDetailViewController.m
//  ClarksCollection
//
//  Created by Openly on 18/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "MarketingDetailViewController.h"
#import "ManagedImage.h"
#import "MarketingMaterial.h"
#import "TemplatizedData.h"
#import "ClarksFonts.h"
#import "UILabel+dynamicSizeMe.h"
#import <MediaPlayer/MediaPlayer.h>


@interface MarketingDetailViewController () {
    NSMutableArray *listOfPlayers;
}

@end

@implementation MarketingDetailViewController  {
    int nCurrImageIdx;
    BOOL viewLoaded;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        viewLoaded = false;
    }
    return self;
}


-(void) tapDetected:(id)sender{
    NSInteger tid = ((UIControl *) sender).tag - 100;;
    
    MPMoviePlayerController *moviePlayerController = (MPMoviePlayerController *)[listOfPlayers objectAtIndex:tid];
    
    [moviePlayerController play];
    
}

-(void) displayItem {
    // Do any additional setup after loading the view.
    if(!viewLoaded || self.theMarketingData == nil)
        return;
    
    int frameHeight = 1100;
    if(self.theMarketingData.isTemplatized == NO) {
        self.theScrollView.hidden = YES;
        self.theSwipeView.hidden = NO;
    } else {
        self.theScrollView.hidden = NO;
        self.theSwipeView.hidden = YES;
        CGRect frame = CGRectMake(0, 0, 1024, [self.theMarketingData.templatizedData count]*frameHeight + 130);
        
        self.theScrollView.frame = frame;
        self.theScrollView.contentSize = CGSizeMake(self.view.frame.size.width, (120 +[self.theMarketingData.templatizedData count]*frameHeight));
        self.heading1.text = self.theMarketingData.heading;
        self.subHeading1.text = self.theMarketingData.subHeading;
        
        self.heading1.font = [ClarksFonts clarksSansProThin:40];
        self.subHeading1.font = [ClarksFonts clarksNarzissMediumBd:40];
    }
    
    int i = 0, tid = 100;;

    
    UILabel *header;
    UITextView *description;
    ManagedImage *imgBig;
    ManagedImage *imgSmall;
    UIView *tmp;
    for(TemplatizedData *theTemplatizedData in self.theMarketingData.templatizedData) {
        
        imgBig = [[ManagedImage alloc]initWithFrame:CGRectMake(0,150+(frameHeight *i),1024,652)];
        [imgBig loadImage:theTemplatizedData.bigImage];
        imgBig.contentMode = UIViewContentModeScaleAspectFit;
        
        if(i%2 == 0) {
            tmp = [[UIView alloc]initWithFrame:CGRectMake(30, 750 +(i*frameHeight), 464, 500)];
            imgSmall =[[ManagedImage alloc]initWithFrame:CGRectMake(500,892+(frameHeight *i),440,295)];
        } else {
            tmp = [[UIView alloc]initWithFrame:CGRectMake(458, 756 +(i*frameHeight), 464, 500)];
            imgSmall =[[ManagedImage alloc]initWithFrame:CGRectMake(20,892+(frameHeight *i),440,295)];
        }
        
        header = [[UILabel alloc]initWithFrame:CGRectMake(64, 0, 390, 140)];
        [header setNumberOfLines:2];
        description =[[UITextView alloc]initWithFrame:CGRectMake(64, 132, 390, 300)];
  
        header.font = [ClarksFonts clarksSansProThin:40.0f];
        description.font = [ClarksFonts clarksSansProLight:16.0f];
        
        [imgSmall loadImage:theTemplatizedData.thumbImage];
        imgSmall.contentMode = UIViewContentModeScaleAspectFit;
        
        header.text = theTemplatizedData.headLine;
        
        if ([header.text isEqualToString:@"[blank]"]) {
            header.hidden = YES;
        }
        
        
        description.text = theTemplatizedData.detailLine;
//        description.lineBreakMode = NSLineBreakByWordWrapping;
//        description.numberOfLines = 0;
//        [description resizeToFit];
        
        tmp.backgroundColor = [UIColor whiteColor];
        [tmp addSubview:header];
        [tmp addSubview:description];
        
       
        
        if([theTemplatizedData.thumbVideo length] > 2) {
            NSString *moviePath = theTemplatizedData.thumbVideo;
            MPMoviePlayerController *moviePlayerController;

            NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
            moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
            [moviePlayerController.view setFrame:imgSmall.frame];  // player's frame must match parent's
            [imgSmall addSubview:moviePlayerController.view];
            
            // Configure the movie player controller
            moviePlayerController.controlStyle = MPMovieControlStyleNone;
            [listOfPlayers addObject:moviePlayerController];

            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [button addTarget:self
                       action:@selector(tapDetected:)
             forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"" forState:UIControlStateNormal];
            button.frame = imgSmall.frame;
            button.tag = tid;
            tid++;
            [self.theScrollView addSubview:button];
        }

        
        [self.theScrollView addSubview:imgBig];
        [self.theScrollView addSubview:tmp];
        [self.theScrollView addSubview:imgSmall];
        
        i++;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    viewLoaded = YES;
    [self displayItem];
    //self.theSwipeView.vertical = YES;
    listOfPlayers = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView{
    return [self.theMarketingData.detailImages count];
}


- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    MarketingMaterial *theMarketingMaterial = self.theMarketingData;
    if (view == nil) {
        CGRect frame = CGRectMake(0, 0, 1024, 704);
        view = [[ManagedImage alloc] initWithFrame: frame];
    }
    NSString *strImgName = [theMarketingMaterial.detailImages objectAtIndex:index];
        
    ((ManagedImage *)view).image = [UIImage imageNamed:@"translucent"];
    [((ManagedImage *)view) loadImage:strImgName];
    ((ManagedImage *)view).contentMode = UIViewContentModeScaleAspectFit;
    return view;
}



@end
