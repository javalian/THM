
#import "MessageContractModel.h"

@implementation MessageContractModel

@synthesize clientToken;
@synthesize messageText;

- (id) initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	
    if (self)
	{
		[self setClientToken:[dictionary objectForKey:@"clientToken"]];
		[self setMessageText:[dictionary objectForKey:@"messageText"]];
	}
    
    return self;
}

@end
