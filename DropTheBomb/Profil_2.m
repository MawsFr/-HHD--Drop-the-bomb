//
//  Profil_2.m
//  DropTheBomb
//
//  Created by Bylaurent_MacBook on 13/09/2014.
//  Copyright (c) 2014 Laurent Thiebault. All rights reserved.
//

#import "Profil_2.h"

@interface Profil_2 ()

@end

@implementation Profil_2

-(IBAction)unwindModalController:(UIStoryboardSegue*) segue {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
