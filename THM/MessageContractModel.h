
#import <Foundation/Foundation.h>

@interface MessageContractModel : NSObject
{
    
}

@property NSString *clientToken;
@property NSString *messageText;

- (id) initWithDictionary:(NSDictionary *)dictionary;

@end
