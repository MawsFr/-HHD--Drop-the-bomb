#import "GameTableViewCell.h"
#import "LocationManager.h"

@interface GameTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;
@property (weak, nonatomic) IBOutlet UILabel *playersLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end

@implementation GameTableViewCell

- (void)setGame:(Game *)game {
    _game = game;
    
    NSString* ownerString = [NSString stringWithFormat:@"Créé par: %@", game.ownerName];
    self.ownerLabel.text = ownerString;
    
    NSString* playersString = [NSString stringWithFormat:@"Nombre de joueurs: %@/%@", game.currentUserCount, game.maxUserCount];
    self.playersLabel.text = playersString;
    
    self.durationLabel.text = [NSString stringWithFormat:@"Temps de jeu: %@ minutes", game.duration];
    
    [[[LocationManager sharedManager] fetchUserLocation] fulfilled:^(CLLocation* location) {
        CLLocationDistance distance = [location distanceFromLocation:game.location];
        int roundedDistance = distance;
        self.distanceLabel.text = [NSString stringWithFormat:@"%dm", roundedDistance];
    }];
}

@end
