
#import "Message.h"

@implementation Message

@synthesize messageId;
@synthesize sentToId;
@synthesize sentToType;
@synthesize sentById;
@synthesize sentByType;
@synthesize messageText;
@synthesize created;
@synthesize sentByName;
@synthesize sentToName;

- (id) initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	
    if (self)
	{
        [self setMessageId:[dictionary objectForKey:@"messageId"]];
        [self setSentToId:[dictionary objectForKey:@"sentToId"]];
        [self setSentToType:[dictionary objectForKey:@"sentToType"]];
        [self setSentById:[dictionary objectForKey:@"sentById"]];
        [self setSentByType:[dictionary objectForKey:@"sentByType"]];
        [self setMessageText:[dictionary objectForKey:@"messageText"]];
        [self setCreated:[dictionary objectForKey:@"created"]];
        [self setSentByName:[dictionary objectForKey:@"sentByName"]];
        [self setSentToName:[dictionary objectForKey:@"sentToName"]];
	}
    
    return self;
}

@end
