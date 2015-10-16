//
//  ViewController.h
//  ScrollViews
//
//  Created by Matt Galloway on 29/02/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemColor.h"

@interface ViewController : UIViewController <UIScrollViewDelegate>{
    ItemColor *theColor;
    int imageIdx;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
-(void) setColor :(ItemColor *) color andImgIdx: (int) imgIdx;
@end
