
#import "AppDelegate.h"
#import "Transporter.h"

@implementation Transporter

@synthesize transporterId;
@synthesize transporterCode;
@synthesize fullName;
@synthesize imageUrl;

- (id) initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	
    if (self) 
	{
        [self setTransporterId:[dictionary objectForKey:@"transporterId"]];
        [self setTransporterCode:[dictionary objectForKey:@"transporterCode"]];
        [self setFullName:[dictionary objectForKey:@"fullName"]];
        [self setImageUrl:[dictionary objectForKey:@"imageUrl"]];
	}
    
    return self;
}

+ (BOOL)authenticate:(NSString *)transporterCode password:(NSString *)password
{
	//make request
	NSDictionary *result = [[AppDelegate sharedRestRequest] performGet:[NSString stringWithFormat:@"/transporter/authenticate/%@/%@", transporterCode, password] error:nil];
    
    //if we have something then send back ok
    return result != nil;
}

+ (Transporter *)get:(NSString *)transporterCode
{
    return [[AppDelegate sharedRestRequest] perform:[NSString stringWithFormat:@"/transporter/get/%@", transporterCode] method:@"GET" jsonData:nil className:@"Transporter" error:nil];
}

+ (NSMutableArray *)getMoves:(NSString *)transporterCode
{
    return [[AppDelegate sharedRestRequest] performGetWithClassName:[NSString stringWithFormat:@"/transporter/getmoves/%@", transporterCode] className:@"Move" error:nil];
}

+ (NSMutableArray *)getMessages:(NSString *)transporterCode
{
    return [[AppDelegate sharedRestRequest] performGetWithClassName:[NSString stringWithFormat:@"/transporter/getmessages/%@", transporterCode] className:@"Message" error:nil];
}

+ (NSMutableArray *)getBreaks:(NSString *)transporterCode
{
    return [[AppDelegate sharedRestRequest] performGetWithClassName:[NSString stringWithFormat:@"/transporter/getbreaks/%@", transporterCode] className:@"Break" error:nil];
}

- (NSMutableArray *)moves
{
    return [Transporter getMoves:[self transporterCode]];
}

- (NSMutableArray *)messages
{
    return [Transporter getMessages:[self transporterCode]];
}

- (NSMutableArray *)breaks
{
    return [Transporter getBreaks:[self transporterCode]];
}

@end