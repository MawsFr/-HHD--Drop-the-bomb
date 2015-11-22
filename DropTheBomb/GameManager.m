#import "GameManager.h"

@implementation GameManager

+ (instancetype)sharedManager {
    static GameManager* instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    
    return instance;
}


-(Game*)parseGameWithDictionary:(NSDictionary*)dictionary {
    Game* game = [[Game alloc]init];
    
    game.gameId = [dictionary objectForKey:@"gameID"];
    game.ownerName = [dictionary objectForKey:@"owner"];
    
    float latitude = [[dictionary objectForKey:@"latitude"] floatValue];
    float longitude = [[dictionary objectForKey:@"longitude"] floatValue];
    game.location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    game.maxUserCount = [dictionary objectForKey:@"maxUsers"];
    game.currentUserCount = [dictionary objectForKey:@"currentUsers"];
    game.duration = [dictionary objectForKey:@"duration"];
    
    return game;
}

-(NSArray*)parseGamesWithDictionaryArray:(NSArray*)list {
    NSMutableArray* gameList = [[NSMutableArray alloc]init];
    
    [list enumerateObjectsUsingBlock:^(NSDictionary* dic, NSUInteger idx, BOOL *stop) {
        [gameList addObject:[self parseGameWithDictionary:dic]];
    }];
    
    return gameList;
}

@end
