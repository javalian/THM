
#import <Foundation/Foundation.h>

@interface TransportWorkOrderNoteModel : NSObject
{
    
}

@property NSNumber *transportWorkOrderId;
@property NSNumber *transporterId;
@property NSString *noteMessage;

- (id) initWithDictionary:(NSDictionary *)dictionary;

@end
