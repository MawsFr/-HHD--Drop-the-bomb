//
//  EndGameViewController.m
//  DropTheBomb
//
//  Created by Aurélie Digeon on 14/09/2014.
//  Copyright (c) 2014 Laurent Thiebault. All rights reserved.
//

#import "EndGameViewController.h"
#import "OpenUDID.h"

@interface EndGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelGagnePerdu;
@property (weak, nonatomic) IBOutlet UILabel *labelPasses;
@property (weak, nonatomic) IBOutlet UILabel *labelScore;

@property (strong, nonatomic) AFHTTPRequestOperationManager* networkingManager;

@end

@implementation EndGameViewController


-(void)viewDidAppear:(BOOL)animated {
    [self prepareNetworking];
    
    if(self.looser.userId == [OpenUDID value]) {
        self.labelGagnePerdu.text = @"Vous avez perdu...";
    } else {
        self.labelGagnePerdu.text = [NSString stringWithFormat:@"%@ a perdu !", self.looser.userName];
    }
    
    [self getScore];
}

-(void)getScore{
    NSDictionary* parameters = @{@"gameId": self.game.gameId,
                                 @"userId": [OpenUDID value]};
    
    [self.networkingManager POST:kGameOver
                      parameters:parameters
                         success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                             if(![[responseObject objectForKey:@"score"] isEqual: [NSNull null]]) {
                                 NSString* scroreString = [NSString stringWithFormat:@"%d", [[responseObject objectForKey:@"score"]intValue]];
                                 self.labelScore.text = scroreString;
                             }
                             if(![[responseObject objectForKey:@"passe"] isEqual: [NSNull null]]) {
                                 NSString* passeString = [NSString stringWithFormat:@"%d", [[responseObject objectForKey:@"passe"]intValue]];
                                 self.labelPasses.text = passeString;
                             }
                         }
                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            
                         }];
}

- (void)setLooser:(User *)looser {
    _looser = looser;
}

-(void)prepareNetworking {
    self.networkingManager = [AFHTTPRequestOperationManager manager];
}
- (IBAction)returnToHome:(id)sender {
    NSArray* vcs = self.navigationController.viewControllers;
    NSArray* newVcs = @[vcs[0], vcs[1]];
    
    [self.navigationController setViewControllers:newVcs animated:YES];
}

@end
