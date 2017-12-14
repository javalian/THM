
#import "DelayReason.h"

@implementation DelayReason

@synthesize transportDelayReasonId;
@synthesize description;

- (id) initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	
    if (self)
	{
        [self setTransportDelayReasonId:[dictionary objectForKey:@"transportWorkOrderDelayReasonId"]];
        [self setDescription:[dictionary objectForKey:@"description"]];
	}
    
    return self;
}

@end
