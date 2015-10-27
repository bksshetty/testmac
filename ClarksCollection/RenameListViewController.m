//
//  RenameListViewController.m
//  ClarksCollection
//
//  Created by Openly on 21/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "RenameListViewController.h"
#import "ClarksFonts.h"
#import "ClarksColors.h"
#import "ClarksUI.h"
#import "AppDelegate.h"

@interface RenameListViewController ()

@end

@implementation RenameListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [ClarksColors clarkLightGrey] ;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.preloadedOrAssortmentEdit == TRUE){
        self.lblRename.text = @"Edit List" ;
        [self.btnRenamee setTitle:@"DUPLICATE" forState:UIControlStateNormal];
        [self.btnRenamee setTitle:@"DUPLICATE" forState:UIControlStateHighlighted];
        [self.btnRenamee setTitle:@"DUPLICATE" forState:UIControlStateDisabled];
        
        appDelegate.preloadedOrAssortmentEdit = FALSE ;
        
    }else{
        self.lblRename.text = @"Rename List" ;
        [self.preLoadedEditText1 setHidden:YES];
        [self.preLoadedEditText2 setHidden:YES];
        [self.btnRenamee setTitle:@"RENAME" forState:UIControlStateNormal];
        [self.btnRenamee setTitle:@"RENAME" forState:UIControlStateHighlighted];
        [self.btnRenamee setTitle:@"RENAME" forState:UIControlStateDisabled];
        
    }
    
    // Do any additional setup after loading the view.
    
    self.preLoadedEditText1.textColor = [ClarksColors clarksBlack];
    self.preLoadedEditText2.textColor = [ClarksColors clarksBlack];
    self.btnRenamee.layer.borderWidth = 1 ;
    self.btnRenamee.layer.borderColor = [ClarksColors clarksButtonGreen].CGColor ;
    self.btnRenamee.alpha = 0.5 ;
    self.lblRename.font = [ClarksFonts clarksSansProThin:40.0f];
    self.txtField.font =[ClarksFonts clarksSansProThin:20.0f];
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 17, 20)];
    [self.txtField setLeftViewMode:UITextFieldViewModeAlways];
    self.txtField.backgroundColor = [UIColor whiteColor] ;
    
    UIColor *color = [ClarksColors clarksMediumGrey];
    
    [self.txtField setLeftView:spacerView2];
    self.txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name your list" attributes:@{NSForegroundColorAttributeName:color}];
    self.txtField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void) repositionButtons
{
    CGRect f = self.lblRename.frame;
    [ClarksUI reposition:self.lblRename x:f.origin.x y:66];
    
    f = self.preLoadedEditText1.frame;
    [ClarksUI reposition:self.preLoadedEditText1 x:f.origin.x y:130];
    
    f = self.preLoadedEditText2.frame;
    [ClarksUI reposition:self.preLoadedEditText2 x:f.origin.x y:155];
    
    f = self.txtField.frame;
    [ClarksUI reposition:self.txtField x:f.origin.x y:188];
    
    f = self.btnRenamee.frame;
    [ClarksUI reposition:self.btnRenamee x:f.origin.x y:264];

}

-(void) unRepositionButtons
{
    CGRect f = self.lblRename.frame;
    [ClarksUI reposition:self.lblRename x:f.origin.x y:66+135];
    
    f = self.preLoadedEditText1.frame;
    [ClarksUI reposition:self.preLoadedEditText1 x:f.origin.x y:130+135];
    
    f = self.preLoadedEditText2.frame;
    [ClarksUI reposition:self.preLoadedEditText2 x:f.origin.x y:155+135];

    
    f = self.txtField.frame;
    [ClarksUI reposition:self.txtField x:f.origin.x y:188+135];
    
    
    f = self.btnRenamee.frame;
    [ClarksUI reposition:self.btnRenamee x:f.origin.x y:264+135];
}

- (IBAction)doRenameLIst:(id)sender {
    [self.view endEditing:YES];
    [self.txtField resignFirstResponder];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.isDuplicate) {
        [appDelegate.listofList addObject:self.list];
        self.index = (int)[appDelegate.listofList count] - 1;
    }
    Lists *listToBeRenamed = [appDelegate.listofList objectAtIndex:self.index];
    
    BOOL uniqueListName = YES;
    
    NSString *newListName = [self.txtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for(Lists *theList in appDelegate.listofList) {
        if([theList.listName isEqualToString:newListName]) {
            uniqueListName = NO;
            break;
        }
    }
    
    if(uniqueListName == NO){
        NSString *message= [NSString stringWithFormat:@"%@ already exits",newListName];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already exists"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    listToBeRenamed.listName = newListName;
    [appDelegate saveList];
    [self goBack];
}

-(void)goBack {
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (IBAction)doNothing:(id)sender {
    [self goBack];
}


- (IBAction)onValueChanged:(id)sender {
    NSString *newListName = [self.txtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([newListName length] >0){
        self.btnRenamee.enabled = YES;
        self.btnRenamee.alpha = 1;
    }else{
        self.btnRenamee.enabled = NO;
        self.btnRenamee.alpha = 0.5;
    }
}


- (IBAction)onEditingBegin:(id)sender {
    [self repositionButtons];
}

- (IBAction)onEditingEnded:(id)sender {
    [self unRepositionButtons];
}


@end
