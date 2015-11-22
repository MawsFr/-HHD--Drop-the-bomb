//
//  Classement_3.m
//  DropTheBomb
//
//  Created by Bylaurent_MacBook on 13/09/2014.
//  Copyright (c) 2014 Laurent Thiebault. All rights reserved.
//

#import "Classement_3.h"

@interface Classement_3 ()
@property (weak, nonatomic) IBOutlet UIButton *bombButton;

@end

@implementation Classement_3


-(IBAction)unwindModalController:(UIStoryboardSegue*) segue {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
