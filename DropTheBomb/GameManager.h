#import <Foundation/Foundation.h>
#import "Game.h"

@interface GameManager : NSObject

+(instancetype)sharedManager;

-(Game*)parseGameWithDictionary:(NSDictionary*)dictionary;
-(NSArray*)parseGamesWithDictionaryArray:(NSArray*)list;

@end
