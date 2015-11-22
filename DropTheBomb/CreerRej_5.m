//
//  CreerRej_5.m
//  DropTheBomb
//
//  Created by Bylaurent_MacBook on 13/09/2014.
//  Copyright (c) 2014 Laurent Thiebault. All rights reserved.
//

#import "CreerRej_5.h"

@interface CreerRej_5 ()

@end

@implementation CreerRej_5

-(IBAction)unwindModalController:(UIStoryboardSegue*) segue {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
