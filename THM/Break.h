
#import <Foundation/Foundation.h>

@interface Break : NSObject
{
    
}

@property NSNumber *breakId;
@property NSNumber *transporterId;
@property NSString *breakType;
@property NSString *started;
@property NSString *ended;

- (id) initWithDictionary:(NSDictionary *)dictionary;

@end
