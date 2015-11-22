//
//  EndGameViewController.h
//  DropTheBomb
//
//  Created by Aurélie Digeon on 14/09/2014.
//  Copyright (c) 2014 Laurent Thiebault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "NetworkConstants.h"
#import "AFNetworking.h"
#import "User.h"


@interface EndGameViewController : UIViewController

@property(nonatomic, strong) Game* game;
@property(nonatomic, strong) User* looser;

@end
