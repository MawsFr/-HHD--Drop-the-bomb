#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationManager () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocation* userlocation;
@property (strong, nonatomic) CLLocationManager* locationManager;

@property (strong, nonatomic) OMDeferred* firstLocationDeffered;

@end

@implementation LocationManager

- (id)init {
    if(self = [super init]) {
        self.firstLocationDeffered = [[OMDeferred alloc]init];
        
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        [self.locationManager startUpdatingLocation];
    }
    
    return self;
}

+ (instancetype)sharedManager {
    static LocationManager* instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    
    return instance;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if([locations count] > 0) {
        CLLocation* location = locations[0];
        self.userlocation = location;
        
        if(self.firstLocationDeffered.state == OMPromiseStateUnfulfilled) {
            [self.firstLocationDeffered fulfil:nil];
        }
    }
}

- (OMPromise*) fetchUserLocation {
    return [self.firstLocationDeffered then:^id(id result) {
        return self.userlocation;
    }];
}


@end
