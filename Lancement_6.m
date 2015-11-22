//
//  Lancement_6.m
//  DropTheBomb
//
//  Created by Bylaurent_MacBook on 13/09/2014.
//  Copyright (c) 2014 Laurent Thiebault. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "Lancement_6.h"
#import "AFNetworking.h"
#import "NetworkConstants.h"
#import "OpenUDID.h"
#import "LocationManager.h"
#import "WaitingViewController.h"
#import "GameManager.h"

@interface Lancement_6 ()

@property (nonatomic , strong) NSString* playersCount;
@property (nonatomic , strong) NSString* duration;

@property (strong, nonatomic) AFHTTPRequestOperationManager* networkingManager;
@property (strong,nonatomic) Game* game;

@end

@implementation Lancement_6

-(void)viewDidLoad {
    [self prepareNetworking];
}

-(IBAction)unwindModalController:(UIStoryboardSegue*) segue {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buttonDuration5:(id)sender {
    self.duration = @"5";
}
- (IBAction)buttonDuration10:(id)sender {
    self.duration = @"10";
}
- (IBAction)buttonDuration15:(id)sender {
    self.duration = @"15";
}
- (IBAction)buttonDuration20:(id)sender {
    self.duration = @"20";
}
- (IBAction)buttonPlayersCount4:(id)sender {
    self.playersCount = @"4";
}
- (IBAction)buttonPlayersCount7:(id)sender {
    self.playersCount = @"7";
}
- (IBAction)buttonPlayersCount8:(id)sender {
    self.playersCount = @"8";
}
- (IBAction)buttonPlayersCount5:(id)sender {
    self.playersCount = @"5";
}
- (IBAction)createGame:(id)sender {
    if(self.duration==nil || self.playersCount==nil) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Erreur" message:@"Merci de renseigner le nombre joueurs et la durée !" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    
    
    [self sendCreateGame];
}

-(void)prepareNetworking {
    self.networkingManager = [AFHTTPRequestOperationManager manager];
}

-(void)sendCreateGame {
    [[[LocationManager sharedManager] fetchUserLocation] fulfilled : ^(CLLocation* location) {
        
        NSString* latitudeString = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        NSString* longitudeString = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
        
        NSDictionary* parameters = @{@"owner": [OpenUDID value],
                                     @"duration": self.duration,
                                     @"maxUsers": self.playersCount,
                                     @"latitude": latitudeString,
                                     @"longitude": longitudeString};
        
        [self.networkingManager POST:kCreateUrl
                          parameters:parameters
                             success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                                 self.game = [[GameManager sharedManager]parseGameWithDictionary:responseObject];
                                 [self performSegueWithIdentifier:@"createSegue" sender:nil];
                             }
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 
                             }];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"createSegue"]) {
        WaitingViewController* vc = segue.destinationViewController;
        vc.game = self.game;
    }
}


@end
