//
//  SousAccueil_0.m
//  DropTheBomb
//
//  Created by Bylaurent_MacBook on 13/09/2014.
//  Copyright (c) 2014 Laurent Thiebault. All rights reserved.
//

#import "SousAccueil_0.h"

#import "AFNetworking.h"
#import "NetworkConstants.h"
#import "OpenUDID.h"

@interface SousAccueil_0 ()
@property (weak, nonatomic) IBOutlet UITextField *pseudoTextField;
@property (strong, nonatomic) NSUserDefaults* userDefaults;

@property (strong, nonatomic) AFHTTPRequestOperationManager* networkingManager;

@end

@implementation SousAccueil_0

-(void)viewDidLoad {
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* username = [self.userDefaults stringForKey:@"username"];
    
    if (username) {
        self.pseudoTextField.text = username;
    }
    
    [self prepareNetworking];
}

-(IBAction)returnKeyButton1:(id)sender{
    [sender resignFirstResponder];
}

- (IBAction)connectUser:(id)sender {
    NSString* userName = self.pseudoTextField.text;
    
    if([userName length] == 0) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Erreur" message:@"Merci de renseigner un pseudo !" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    
    [self.userDefaults setObject:userName forKey:@"username"];
    
    [self sendConnectRequest];
}

-(void)prepareNetworking {
    self.networkingManager = [AFHTTPRequestOperationManager manager];
}

-(void)sendConnectRequest {
    NSDictionary* parameters = @{@"userId": [OpenUDID value],
                                 @"pseudo": self.pseudoTextField.text
                                 };
    
    [self.networkingManager POST:kConnectURL
                      parameters:parameters
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             [self performSegueWithIdentifier:@"connectSegue" sender:nil];
    }
                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
