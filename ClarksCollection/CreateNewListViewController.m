//
//  CreateNewListViewController.m
//  ClarksCollection
//
//  Created by Openly on 05/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "CreateNewListViewController.h"
#import "ClarksFonts.h"
#import "ClarksColors.h"
#import "AppDelegate.h"
#import "Lists.h"
#import "ClarksUI.h"
#import "User.h"
#import "API.h"


@interface CreateNewListViewController ()

@end

@implementation CreateNewListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lblCreateNewList.font = [ClarksFonts clarksSansProThin:40.0f];
    self.txtListName.font =[ClarksFonts clarksSansProThin:20.0f];
    UIView *spacerView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 17, 20)];
    [self.txtListName setLeftViewMode:UITextFieldViewModeAlways];
    
    
    UIColor *color = [ClarksColors clarksMediumGrey];
    
    [self.txtListName setLeftView:spacerView2];
    self.txtListName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name your list" attributes:@{NSForegroundColorAttributeName:color}];
    self.txtListName.delegate = self;
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

- (IBAction)onEditingBegin:(id)sender {
    self.txtListName.autocapitalizationType = UITextAutocapitalizationTypeWords  ;
    [self repositionButtons];
}

-(void) repositionButtons
{
    CGRect f = self.lblCreateNewList.frame;
    [ClarksUI reposition:self.lblCreateNewList x:f.origin.x y:76];
    
    f = self.txtListName.frame;
    [ClarksUI reposition:self.txtListName x:f.origin.x y:168];
    
    
    f = self.btnCreate.frame;
    [ClarksUI reposition:self.btnCreate x:f.origin.x y:244];
}

-(void) unRepositionButtons
{
    CGRect f = self.lblCreateNewList.frame;
    [ClarksUI reposition:self.lblCreateNewList x:f.origin.x y:76+135];
    
    f = self.txtListName.frame;
    [ClarksUI reposition:self.txtListName x:f.origin.x y:168+135];
    
    
    f = self.btnCreate.frame;
    [ClarksUI reposition:self.btnCreate x:f.origin.x y:244+135];
}

- (IBAction)onEditingEnded:(id)sender {
    self.txtListName.autocapitalizationType = UITextAutocapitalizationTypeWords  ;
    [self unRepositionButtons];
}


- (IBAction)onCreateNewList:(id)sender {
    [self.view endEditing:YES];
    self.txtListName.autocapitalizationType = UITextAutocapitalizationTypeWords  ;
    NSString *newListName = [self.txtListName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BOOL uniqueListName = YES;
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
    
    Lists *newList = [[Lists alloc]init];
    newList.listName = newListName;
    
    [appDelegate.listofList addObject:newList];
    
    // add the currlist to the listofLists and mark the list as active
    [appDelegate saveList];    
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSString *)readFile:(NSString *)fileName

{
    NSLog(@"readFile");
    
    NSString *appFile = fileName;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:appFile])
    {
        NSError *error= NULL;
        NSString *resultData = [NSString stringWithContentsOfFile: appFile encoding: NSUTF8StringEncoding error: &error];
        if (error == NULL)
            return resultData;
    }
    return NULL;
}

- (IBAction)onValueChanged:(id)sender {
    
    NSString *newListName = [self.txtListName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //NSString *newListName = [[[newListName substringToIndex:1] uppercaseString] stringByAppendingString:[newListName substringFromIndex:1]];
    
    //newListName
        if([newListName length] >0)
        self.btnCreate.enabled = YES;
    else
        self.btnCreate.enabled = NO;
}
@end
