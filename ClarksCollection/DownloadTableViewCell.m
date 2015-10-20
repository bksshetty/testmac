//
//  DownloadTableViewCell.m
//  ClarksCollection
//
//  Created by Abhilash Hebbar on 27/05/15.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import "DownloadTableViewCell.h"
#import "ClarksColors.h"
#import "Reachability.h"

@implementation DownloadTableViewCell{
    DownloadItem *theItem;
}

- (void)awakeFromNib {
    [NSTimer
        scheduledTimerWithTimeInterval:1.0f
        target:self
        selector:@selector(refresh)
        userInfo:nil repeats:YES];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)pauseDownload:(id)sender {
    [theItem pause];
}

- (IBAction)cancelDownload:(id)sender {
    [theItem cancel];
}

- (IBAction)startDownload:(id)sender {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection] ;
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    self.counter = 0 ;
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"You must be connected to the internet to download."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    if (theItem.status == PAUSED) {
        [theItem resume];
    }else{
        [theItem start];
    }
    [self refresh];
}

-(void) setItem:(DownloadItem *) item{
    theItem = item;
    [self refresh];
}

- (void) refresh{
    self.titleLabel.text = theItem.title;
    self.productCountLabel.hidden = YES;
    
    if (theItem.status == DOWLOADING || theItem.status == INIT_DOWNLOAD) {
        self.downloadBtn.hidden = YES;
        
        self.downloadProgress.hidden = NO;
        self.pauseBtn.hidden = NO;
        self.stopBtn.hidden = NO;
        
        self.downloadProgress.progress = [theItem completedPercentage];
        
    }else{
        self.downloadBtn.hidden = NO;
        
        self.downloadProgress.hidden = YES;
        self.pauseBtn.hidden = YES;
        self.stopBtn.hidden = YES;
        
        if (theItem.status == NOT_STARTED || theItem.status == STOPPED) {
            [self.downloadBtn setTitle:@"DOWNLOAD" forState:UIControlStateNormal];
            [self.downloadBtn setTitle:@"DOWNLOAD" forState:UIControlStateHighlighted];
            self.downloadBtn.enabled = YES;
            self.downloadBtn.backgroundColor = [ClarksColors clarksButtonGreen];
        }else if (theItem.status == PAUSED){
            [self.downloadBtn setTitle:@"RESUME" forState:UIControlStateNormal];
            [self.downloadBtn setTitle:@"RESUME" forState:UIControlStateHighlighted];
            self.downloadBtn.enabled = YES;
            self.downloadBtn.backgroundColor = [ClarksColors clarksButtonGreen];
        }else{
            self.downloadBtn.hidden = NO;
            self.downloadBtn.backgroundColor = [UIColor grayColor];
            self.downloadBtn.enabled = NO;
            [self.downloadBtn setTitle:@"DOWNLOADED" forState:UIControlStateDisabled];
            [self.downloadBtn setTitle:@"DOWNLOADED" forState:UIControlStateNormal];
            [self.downloadBtn setTitle:@"DOWNLOADED" forState:UIControlStateHighlighted];
        }
    }
    
    
}
@end
