
#import <Foundation/Foundation.h>

@interface DelayReason : NSObject
{
    
}

@property NSNumber *transportDelayReasonId;
@property NSString *description;

- (id) initWithDictionary:(NSDictionary *)dictionary;

@end
