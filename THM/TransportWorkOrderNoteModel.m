
#import "TransportWorkOrderNoteModel.h"

@implementation TransportWorkOrderNoteModel

@synthesize transportWorkOrderId;
@synthesize transporterId;
@synthesize noteMessage;

- (id) initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	
    if (self)
	{
		[self setTransportWorkOrderId:[dictionary objectForKey:@"transportWorkOrderId"]];
		[self setTransporterId:[dictionary objectForKey:@"transporterId"]];
        [self setNoteMessage:[dictionary objectForKey:@"noteMessage"]];
	}
    
    return self;
}

@end
