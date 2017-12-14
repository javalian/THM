
#import "CancelModel.h"

@implementation CancelModel

@synthesize transportWorkOrderId;
@synthesize reason;

- (id) initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	
    if (self)
	{
		[self setTransportWorkOrderId:[dictionary objectForKey:@"transportWorkOrderId"]];
		[self setReason:[dictionary objectForKey:@"reason"]];
	}
    
    return self;
}

@end
