//

//  Item.h

//  Clarks Collection

//

//  Created by Openly on 04/09/2014.

//  Copyright (c) 2014 Openly. All rights reserved.

//



#import <Foundation/Foundation.h>

#import "ItemColor.h"



@interface Item : NSObject
- (Item *) initWithDict: (NSDictionary *) dict;

@property BOOL imageDownloaded;
@property NSString *name;
@property NSString *image;
@property BOOL has360;
@property NSString *fit;
@property NSString *size;
@property NSString *sole;
@property NSString *construction;
@property NSString *lining;
@property NSString *sock;
@property NSMutableArray *profile;
@property NSString *upperMaterial;
@property NSString *material;
@property NSMutableArray *collaborations;
@property NSMutableArray *additionalFeature;
@property NSMutableArray *tradingEvent;
@property NSMutableArray *fitOptions;
@property NSMutableArray *gender;
@property NSMutableArray *tier ;
@property BOOL isFeatured;
@property BOOL isGA;
@property BOOL warmLined;
@property BOOL agion;
@property BOOL xlEtralight;
@property BOOL waveWalk;
@property BOOL vibram;
@property BOOL unstructured;
@property BOOL goretex;
@property BOOL softwear;
@property BOOL clarksPlus;
@property BOOL activeAirVent;
@property BOOL activeAir;
@property BOOL pigskin;
@property NSString* heelHeight;
@property NSArray *colors;
@property NSString *collectionName;
@property NSString *assortmentName ;
@property BOOL isSelected;
@property NSMutableArray *technologies;
@property NSMutableArray *mustHaves;

-(void) markItemAsSelected;
-(void) markItemAsDeselected;
@end



