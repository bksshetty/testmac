//
//  AppDelegate.m
//  ClarksCollection
//
//  Created by Openly on 25/09/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "AppDelegate.h"
#import "MixPanelUtil.h"
#import "ImageDownloadManager.h"
#import "ImageDownloader.h"
#import "ClarksColors.h"
#import "ItemColor.h"
#import "ListItem.h"
#import "Lists.h"
#import "User.h"
#import "DiscoverCollection.h"
#import "API.h"
#import "LoginViewController.h"
#import "ClarksUI.h"
#import "DataReader.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.firstLaunch = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"firstLaunch"];
    [self.window setTintColor:[UIColor whiteColor]];
    [[UITextField appearance] setTintColor:[ClarksColors clarksMediumGrey]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(startupTasks) userInfo:nil repeats:NO];
    [Fabric with:@[[Crashlytics class]]];

    return YES;
    // comment 
}

-(void) startupTasks{
    NSLog(@"Doing startup tasks");
    [Crashlytics startWithAPIKey:@"b433afd2053bd1c6b8f6f3a283c46f07d6ad6821"];
    [[MixPanelUtil instance] track:@"app_start"];
    // Override point for customization after application launch.
    // [self tryUpdate];+
    [self doUpdateLists];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[ImageDownloader instance] reActivate];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) downloadProductInfo:(BOOL) updateLocalData onComplete:(void(^)(void)) handler{
    [self downloadProductInfo:updateLocalData showAlert:YES onComplete:handler];
}

-(void) downloadProductInfo:(BOOL) updateLocalData showAlert: (BOOL)showAlert onComplete:(void(^)(void)) handler {
    NSArray *paths = NSSearchPathForDirectoriesInDomains
                            (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/data.json",
                                documentsDirectory];
    NSDictionary *data = [DataReader read];
    self.minAppVersion = [[data valueForKey:@"minimum_app_version"] doubleValue] ;
    NSLog(@"%f", self.minAppVersion);
    NSInteger deviceVersion = [[data valueForKey:@"version"] integerValue];
    self.dataState = VersionCheck;
    [[API instance] get:@"products-version"  onComplete:^(NSDictionary  *results) {
        if(results != nil) {
            NSInteger serverVersion =[[results valueForKey:@"version"] integerValue];
            if(serverVersion > deviceVersion) {
                self.dataState = DataIsDownloading;
                [[API instance] getOnlyData:@"products"  onComplete:^(NSData  *results) {
                    BOOL status = [results writeToFile:fileName atomically:YES];
                    NSLog(@"writing to file %d",status);
                    if (self.firstLaunch == 0) {
                        LoginViewController* loginVC = (LoginViewController*) self.window.rootViewController;
                        [loginVC hideLoading];
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New catalogue available"
                                                                  message:@"In order to complete update, you need to logout. "
                                                                  delegate:self
                                                                  cancelButtonTitle:@"Not now"
                                                                  otherButtonTitles:@"Logout",nil];
                        [alert show];
                    }
                    self.dataState = DataDownloaded;
                    handler();
                        
                    return;
                }];
            }else {
                if (self.firstLaunch == 0) {
                    LoginViewController* loginVC = (LoginViewController*) self.window.rootViewController;
                    [loginVC hideLoading];
                }
                if(updateLocalData == NO){
                    if (showAlert) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Catalogue is current"
                                                                    message:@"Your catalogue is up to date"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Close"
                                                          otherButtonTitles:nil];
                        [alert show];
                    }
                    handler();
                }
                self.dataState = DataIsCurrent;
            }
        }
    }];
    if(updateLocalData)
        [ImageDownloadManager preload];
}

- (void) tryUpdate{
    NSLog(@"Trying to fetch new data.");
    [self downloadProductInfo:NO showAlert:NO onComplete:^{
        [NSTimer scheduledTimerWithTimeInterval:(15.0f*60) target:self selector:@selector(tryUpdate) userInfo:nil repeats:NO];
    }];
}

- (void) doUpdateLists{
    [NSTimer scheduledTimerWithTimeInterval:(15.0f*60) target:self selector:@selector(updateLists) userInfo:nil repeats:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView firstOtherButtonIndex]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Logout" object:nil userInfo:nil];
    }
}
-(void)saveList {
    NSString *trimmerUserName = [[User current].name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *listName = [NSString stringWithFormat:@"%@-ClarksList.txt",trimmerUserName];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:listName];
    [NSKeyedArchiver archiveRootObject:self.listofList toFile:appFile];
}

- (void)updateLists{
    NSString *trimmerUserName = [[User current].name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *listName = [NSString stringWithFormat:@"%@-ClarksList.txt",trimmerUserName];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:listName];
    NSData *data = [NSData dataWithContentsOfFile:appFile];
    NSString *content = [data base64EncodedStringWithOptions:0];
    
    if(content != nil){
        [[API instance] post:@"update-lists"
                      params:@{@"listsData": content
                               }
                  onComplete:^(NSDictionary *results) {
                      
                      if(results == nil) {
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                          message:@"No network connectivity or server down"
                                                                         delegate:self
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                          [alert show];
                          return;
                      }
                      //NSString *strMsg;
                      NSString *strResult = [results valueForKey:@"status"];
                      if ([strResult isEqualToString:@"success"]) {
                          NSLog(@"Success!!!");
                      }
                      else{
                          NSLog(@"Failed");
                      }
                  }];
    }

}

-(void)restoreList {
    NSString *trimmerUserName = [[User current].name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSString *listName = [NSString stringWithFormat:@"%@-ClarksList.txt",trimmerUserName];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:listName];
    self.listofList = [NSKeyedUnarchiver unarchiveObjectWithFile:appFile];
    NSLog(@"%@", self.listofList);
    Lists *listItem ;
    for (listItem in self.listofList){
        [listItem sort] ;
        NSLog(@"%@", listItem);
    }
    
    if(self.listofList == nil)
        self.listofList = [[NSMutableArray alloc]initWithCapacity:1];
    self.activeList = nil;
    self.filtereditemArray = nil;
}

-(void) markListAsActive:(Lists *)theList {
    // First reset the selection from the current active list
    self.activeList = theList;
    [self reconcileFilteredArrayWithActiveList];
}




-(void) removeItemColorFromActiveList:(Item *)theItem itemColor:(ItemColor *)theColor {
    Lists *activeList = self.activeList;
    
    if(activeList != nil) {
        [activeList deleteItemColorFromList:theColor.colorId];
        [self saveList];
    }
    
    // If no color selected
    ItemColor *theItemColor;
    for(theItemColor in theItem.colors) {
        if([theItemColor.colorId isEqualToString:theColor.colorId])
            theItemColor.isSelected = NO;
    }
    
    // if any color still selected
    BOOL anyColorSelected = NO;
    for(theItemColor in theItem.colors) {
        if(theItemColor.isSelected ) {
            anyColorSelected = YES;
            break;
        }
    }
    if(anyColorSelected)
        theItem.isSelected = YES;
    else
        theItem.isSelected = NO;
}
-(void) reconcileFilteredArrayWithActiveList {
    
    Item *theItem;
    ItemColor *theColor;
    // first mark everything as unselected
    for( theItem in self.filtereditemArray) {
        for (theColor in theItem.colors) {
            theColor.isSelected = NO;
        }
        theItem.isSelected = NO;
    }
    
    Lists *theList = self.activeList;
    if ( (self.filtereditemArray != nil) && (theList != nil)) {
        for (ListItem *theListItem in theList.listOfItems) {
            for( Item *theItem in self.filtereditemArray) {
                for (ItemColor *theColor in theItem.colors) {
                    if([theColor.colorId isEqualToString:theListItem.itemNumber]) {
                        theColor.isSelected = YES;
                        theItem.isSelected = YES;
                    }
                }
            }
        }
    }
}

- (void) application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"Background fetch starting. Background fetch call...");
    [[ImageDownloader instance] doNextDownloads];
//    completionHandler(UIBackgroundFetchResultNewData);
}

- (void) application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler{
    NSLog(@"Image downloaded. handleEventsForBackgroundURLSession call....");
    completionHandler();
}

@end
