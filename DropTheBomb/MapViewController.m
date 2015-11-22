//
//  MapViewController.m
//  DropTheBomb
//
//  Created by Aurélie Digeon on 13/09/2014.
//  Copyright (c) 2014 Laurent Thiebault. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "LocationManager.h"
#import "NetworkConstants.h"
#import "OMPromises.h"
#import "AFNetworking.h"
#import "UserManager.h"
#import "OpenUDID.h"
#import "User.h"
#import "EndGameViewController.h"

@interface MapViewController () <CLLocationManagerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIButton *bombButton;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSArray* users;
@property (strong, nonatomic) NSArray* bombableUser;
@property (strong, nonatomic) CLLocation* userLocation;
@property (strong, nonatomic) NSMutableDictionary* annotationPoints;

@property (assign, nonatomic) BOOL hasBomb;

@property (weak, nonatomic) IBOutlet UIImageView *hasBombImage;
@property (weak, nonatomic) IBOutlet UIImageView *canDropBombImage;

@property (strong, nonatomic) AFHTTPRequestOperationManager* networkingManager;

@property (strong, nonatomic) NSArray* listedUsers;

@property (strong, nonatomic) NSTimer* refreshTimer;

@property (strong, nonatomic) NSDate* gameEndDate;

@property (assign, nonatomic) int remainingSeconds;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.showsUserLocation = YES;
    
    self.annotationPoints = [[NSMutableDictionary alloc]init];
    
    [self prepareLocation];
    [self prepareNetworking];
}


- (void)decrementCountdown:(NSTimer*) timer {
    if(self.remainingSeconds <= 0) {
        [timer invalidate];
        [self endGame];
        return;
    }
    
    int minutes = self.remainingSeconds / 60;
    int seconds = self.remainingSeconds % 60;
    
    self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    self.remainingSeconds--;
}

- (void)endGame {
    [self performSegueWithIdentifier:@"endGameSegue" sender:nil];
}

- (void)setGameEndDate:(NSDate *)gameEndDate {
    _gameEndDate = gameEndDate;
    
    self.remainingSeconds = [self.gameEndDate timeIntervalSinceNow] - (120 * 60);
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(decrementCountdown:) userInfo:nil repeats:YES];
}


-(void)setUserLocation:(CLLocation *)userLocation {
    _userLocation = userLocation;
    self.mapView.region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.02, 0.02));
}

#pragma mark - Location Manager

- (void)prepareLocation {
    [[[LocationManager sharedManager] fetchUserLocation] fulfilled:^(CLLocation* location) {
        self.userLocation = location;
    }];
}

#pragma mark - Networking

-(void)prepareNetworking {
    self.networkingManager = [AFHTTPRequestOperationManager manager];
    [self fetchGameInfos];
    [self updateUserInfos];
}

-(void)fetchGameInfos {
    NSDictionary* parameters = @{@"gameId": self.game.gameId};
    
    [self.networkingManager GET:kGamesInfosURL
                     parameters:parameters
                        success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                            [self handleUpdateWithResponseDic:responseObject];
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            
                        }];
}

-(void)handleUpdateWithResponseDic:(NSDictionary*)dictionary {
    NSArray* usersArray = [dictionary objectForKey:@"users"];
    if([dictionary objectForKey:@"endDate"] && !self.gameEndDate) {
        NSString* dateText = [dictionary objectForKey:@"endDate"];
        self.gameEndDate = [NSDate dateWithTimeIntervalSince1970:[dateText doubleValue]];
    }
    
    self.users = [[UserManager sharedManager] usersWithDictionaryArray:usersArray];
    
    [self.users enumerateObjectsUsingBlock:^(User* user, NSUInteger idx, BOOL *stop) {
        if(![user.userId isEqual:[OpenUDID value]]) {
            BOOL shouldAddOnMap = NO;
            
            MKPointAnnotation* pointAnnotation = [self.annotationPoints objectForKey:user.userId];
            if(!pointAnnotation) {
                pointAnnotation = [[MKPointAnnotation alloc]init];
                shouldAddOnMap = YES;
                
                [self.annotationPoints setObject:pointAnnotation forKey:user.userId];
            }
            
            pointAnnotation.coordinate = user.location.coordinate;
            pointAnnotation.title = user.userName;
            
            if(shouldAddOnMap) {
                [self.mapView addAnnotation:pointAnnotation];
            }
        }
    }];
    
    [self updateBombableUser];
    
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(fetchGameInfos)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)updateBombableUser {
    [[[LocationManager sharedManager] fetchUserLocation]fulfilled:^(CLLocation* location) {
        NSMutableArray* bombableUsers = [[NSMutableArray alloc]init];
        [self.users enumerateObjectsUsingBlock:^(User* user, NSUInteger idx, BOOL *stop) {
            if([user.userId isEqual: [OpenUDID value]]) {
                self.hasBomb = user.hasBomb;
                
                return;
            }
            
            CLLocationDistance distance = [location distanceFromLocation: user.location];
            if(distance <= 30) {
                [bombableUsers addObject:user];
            }
        }];
        
        self.bombableUser = [bombableUsers copy];
        
        if(self.hasBomb) {
            self.hasBombImage.hidden = NO;
            
            if(self.bombableUser.count > 0) {
                self.canDropBombImage.hidden = NO;
                self.bombButton.enabled = YES;
            }
            else {
                self.canDropBombImage.hidden = YES;
                self.bombButton.enabled = NO;
            }
        }
        else {
            self.hasBombImage.hidden = YES;
            self.canDropBombImage.hidden = YES;
            self.bombButton.enabled = NO;
        }
    }];
}

-(void)updateUserInfos {
    [[[LocationManager sharedManager] fetchUserLocation]fulfilled:^(CLLocation* location) {
        NSString* latitudeString = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        NSString* longitudeString = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
        
        NSDictionary* parameters = @{@"userId": [OpenUDID value],
                                     @"latitude": latitudeString,
                                     @"longitude": longitudeString};
        
        [self.networkingManager POST:kUpdateUserInfosUrl
                         parameters:parameters
                            success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                                [NSTimer scheduledTimerWithTimeInterval:3.0
                                                                 target:self
                                                               selector:@selector(updateUserInfos)
                                                               userInfo:nil
                                                                repeats:NO];
                            }
                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                
                            }];
    }];
}

- (IBAction)askPersonToBomb:(id)sender {
    if(self.bombableUser.count == 1) {
        [self bombUser:self.bombableUser.firstObject];
    }
    else {
        self.listedUsers = [self.bombableUser copy];
        
        UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"Qui sera touché ?" delegate:self cancelButtonTitle:@"Annuler" destructiveButtonTitle:nil otherButtonTitles: nil];
        
        [self.bombableUser enumerateObjectsUsingBlock:^(User* user, NSUInteger idx, BOOL *stop) {
            [actionSheet addButtonWithTitle:user.userName];
        }];
        
        [actionSheet showInView:self.view];
    }
}

- (void)bombUser:(User*)user {
    NSDictionary* parameters = @{@"as": [OpenUDID value],
                                 @"to": user.userId};
    [self.networkingManager POST:kBombingUrl
                      parameters:parameters
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    }
                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (User*)hasBombUser {
    User* __block hasBombUser;
    
    [self.users enumerateObjectsUsingBlock:^(User* user, NSUInteger idx, BOOL *stop) {
        if(user.hasBomb) {
            hasBombUser = user;
        }
    }];
    
    return hasBombUser;
}

#pragma mark - action sheet delegate 

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) return;
    
    User* user = [self.listedUsers objectAtIndex:(buttonIndex - 1)];
    [self bombUser:user];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"endGameSegue"]) {
        EndGameViewController* vc = segue.destinationViewController;
        vc.game = self.game;
        vc.looser = [self hasBombUser];
    }
}

@end
