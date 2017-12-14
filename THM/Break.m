
#import "Break.h"

@implementation Break

@synthesize breakId;
@synthesize transporterId;
@synthesize breakType;
@synthesize started;
@synthesize ended;

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
	
    if (self)
	{
		[self setValuesForKeysWithDictionary:dictionary];
	}
    
    return self;
}

@end
