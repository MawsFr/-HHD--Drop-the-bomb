#import <Foundation/Foundation.h>
#import "OMPromises.h"

@interface LocationManager : NSObject

+(instancetype)sharedManager;
-(OMPromise*) fetchUserLocation;

@end
