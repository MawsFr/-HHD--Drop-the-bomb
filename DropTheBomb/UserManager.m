#import "UserManager.h"
#import "User.h"

@interface UserManager ()

@property(nonatomic, strong) NSMutableDictionary* userDictionary;

@end

@implementation UserManager

+ (instancetype)sharedManager {
    static UserManager* instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    
    return instance;
}

- (id)init {
    if(self = [super init]) {
        self.userDictionary = [[NSMutableDictionary alloc]init];
    }
    
    return self;
}

-(User*)userForDictionary:(NSDictionary*)dictionary {
    User* user = [self.userDictionary objectForKey:[dictionary objectForKey:@"id"]];
    
    if(user == nil) {
        user = [[User alloc]init];
        
        user.userId = [dictionary objectForKey:@"id"];
        user.userName = [dictionary objectForKey:@"pseudo"];
        
        [self.userDictionary setObject:user forKey:[dictionary objectForKey:@"id"]];
    }
    
    float latitude = [[dictionary objectForKey:@"latitude"] floatValue];
    float longitude = [[dictionary objectForKey:@"longitude"] floatValue];
    user.location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    user.hasBomb = [[dictionary objectForKey:@"hasBomb"] boolValue];
    
    return user;
}

-(NSArray*)usersWithDictionaryArray:(NSArray*)list {
    NSMutableArray* userList = [[NSMutableArray alloc]init];
    
    [list enumerateObjectsUsingBlock:^(NSDictionary* dic, NSUInteger idx, BOOL *stop) {
        [userList addObject:[self userForDictionary:dic]];
    }];
    
    return userList;
}


@end
