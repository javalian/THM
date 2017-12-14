
#import <Foundation/Foundation.h>

@interface Message : NSObject
{
    
}

@property NSNumber *messageId;
@property NSNumber *sentById;
@property NSString *sentByType;
@property NSNumber *sentToId;
@property NSString *sentToType;
@property NSString *messageText;
@property NSString *created;
@property NSString *sentByName;
@property NSString *sentToName;

- (id) initWithDictionary:(NSDictionary *)dictionary;

@end
