#import <Foundation/Foundation.h>

@class User;

@interface UserManager : NSObject

+(instancetype)sharedManager;

-(User*)userForDictionary:(NSDictionary*)dictionary;
-(NSArray*)usersWithDictionaryArray:(NSArray*)list;

@end
