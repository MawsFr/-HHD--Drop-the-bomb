#import "WaitingViewController.h"
#import "NetworkConstants.h"
#import "AFNetworking.h"
#import "UserManager.h"
#import "OpenUDID.h"
#import "LocationManager.h"
#import "MapViewController.h"

@interface WaitingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *playersCountLabel;
@property (strong, nonatomic) AFHTTPRequestOperationManager* networkingManager;
@property (strong, nonatomic) NSTimer* refreshTimer;
@property (nonatomic) BOOL isReady;

@end

@implementation WaitingViewController

- (void)viewDidLoad {
    self.playersCountLabel.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [self prepareNetworking];

}

-(void)prepareNetworking {
    self.networkingManager = [AFHTTPRequestOperationManager manager];
    
    [self joinGame];
    [self fetchGameInfos];
}

-(void)handleUpdateWithResponseDic:(NSDictionary*)dictionary {
    NSArray* usersArray = [dictionary objectForKey:@"users"];
    NSArray* users = [[UserManager sharedManager] usersWithDictionaryArray:usersArray];
    
    self.playersCountLabel.text = [NSString stringWithFormat:@"%lu / %@", (unsigned long)users.count, self.game.maxUserCount];
    self.playersCountLabel.hidden = NO;
    
    if(users.count >= [self.game.maxUserCount unsignedIntegerValue]) {
        if(!self.isReady) {
            self.isReady = YES;
            [self performSegueWithIdentifier:@"startGameSegue" sender:nil];
        }
    } else {
        self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                             target:self
                                                           selector:@selector(fetchGameInfos)
                                                           userInfo:nil
                                                            repeats:NO];
    }
}

-(void)joinGame {
    [[[LocationManager sharedManager] fetchUserLocation] fulfilled:^(CLLocation* location) {
        NSNumber* latitude = [NSNumber numberWithFloat:location.coordinate.latitude];
        NSNumber* longitude = [NSNumber numberWithFloat:location.coordinate.longitude];
        
        NSDictionary* parameters = @{
                                     @"gameId": self.game.gameId,
                                     @"userId": [OpenUDID value],
                                     @"latitude": latitude,
                                     @"longitude": longitude
                                     };
        
        [self.networkingManager POST:kJoinURL
                          parameters:parameters
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 
                             }
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 
                             }];
    }];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"startGameSegue"]) {
        MapViewController* vc = segue.destinationViewController;
        vc.game = self.game;
    }
}

@end
