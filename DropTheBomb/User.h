//
//  User.h
//  DropTheBomb
//
//  Created by Aurélie Digeon on 13/09/2014.
//  Copyright (c) 2014 Laurent Thiebault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface User : NSObject

@property(nonatomic, strong) NSString* userId;
@property(nonatomic, strong) NSString* userName;
@property(nonatomic, strong) CLLocation* location;
@property(nonatomic, assign) BOOL hasBomb;

@end
