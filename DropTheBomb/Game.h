#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Game : NSObject

@property(nonatomic, strong) NSNumber* gameId;
@property(nonatomic, strong) NSString* ownerName;
@property(nonatomic, strong) CLLocation* location;
@property(nonatomic, strong) NSNumber* currentUserCount;
@property(nonatomic, strong) NSNumber* maxUserCount;
@property(nonatomic, strong) NSNumber* duration;

@end
