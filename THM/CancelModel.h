
#import <Foundation/Foundation.h>

@interface CancelModel : NSObject
{
    
}

@property NSNumber *transportWorkOrderId;
@property NSString *reason;

- (id) initWithDictionary:(NSDictionary *)dictionary;

@end
