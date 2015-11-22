#import "GamesTableViewController.h"
#import "NetworkConstants.h"
#import "AFNetworking.h"
#import "GameManager.h"
#import "GameTableViewCell.h"
#import "LocationManager.h"
#import "WaitingViewController.h"

@interface GamesTableViewController () <UITableViewDataSource>

@property (strong, nonatomic) AFHTTPRequestOperationManager* networkingManager;

@property (strong, nonatomic) NSArray* games;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GamesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareNetworking];
}

#pragma mark - Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.games.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GameTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"gameCellIdentifier" forIndexPath:indexPath];
    
    cell.game = [self.games objectAtIndex:indexPath.row];
    
    return cell;

}

#pragma mark - Networking 

-(void)prepareNetworking {
    self.networkingManager = [AFHTTPRequestOperationManager manager];
    
    [self fetchGames];
}

-(void)fetchGames {
   [[[LocationManager sharedManager] fetchUserLocation] fulfilled:^(CLLocation* location) {
       NSString* latitudeText = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
       NSString* longitudeText = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
       
       NSDictionary* parameters = @{@"latitude": latitudeText,
                                    @"longitude": longitudeText};
       
       [self.networkingManager POST:kGamesListURL
                         parameters:parameters
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                self.games = [[GameManager sharedManager]parseGamesWithDictionaryArray:responseObject];
                                [self.tableView reloadData];
                                
                            }
                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                
                            }];
       
   }];
}

-(IBAction)unwindController:(UIStoryboardSegue*) segue {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"waitingViewControllerSegue"]) {
        GameTableViewCell* cell = sender;
        
        WaitingViewController* vc = segue.destinationViewController;
        vc.game = cell.game;
    }
}

@end
