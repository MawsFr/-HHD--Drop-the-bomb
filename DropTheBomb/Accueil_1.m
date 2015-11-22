//
//  Accueil_1.m
//  DropTheBomb
//
//  Created by Bylaurent_MacBook on 13/09/2014.
//  Copyright (c) 2014 Laurent Thiebault. All rights reserved.
//

#import "Accueil_1.h"
#import "CreerRej_5.h"

@interface Accueil_1 ()

@end

@implementation Accueil_1


-(IBAction)goToGame {
    UIStoryboard* gameStoryboard = [UIStoryboard storyboardWithName:@"Game" bundle:nil];
    CreerRej_5* createGameVC = [gameStoryboard instantiateInitialViewController];
    
    [self.navigationController pushViewController:createGameVC animated:YES];
}

@end
