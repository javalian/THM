
#import "AppDelegate.h"
#import "Move.h"

@implementation Move

@synthesize transportWorkOrderId;
@synthesize status;
@synthesize serviceType;
@synthesize transportType;
@synthesize patientName;
@synthesize patientGender;
@synthesize patientMedicalRecordNumber;
@synthesize patientHomeArea;
@synthesize fromArea;
@synthesize toArea;
@synthesize equipment;
@synthesize serviceLevelAgreement;
@synthesize timeRequested;
@synthesize timeAssigned;
@synthesize timeAcknowledged;
@synthesize timeNeeded;
@synthesize timeStarted;
@synthesize roundTrip;
@synthesize description;
@synthesize timeClosed;
@synthesize isDelayed;
@synthesize transporters;

- (id) initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	
    if (self) 
	{
        [self setTransportWorkOrderId:[dictionary objectForKey:@"transportWorkOrderId"]];
        [self setStatus:[dictionary objectForKey:@"status"]];
        [self setServiceType:[dictionary objectForKey:@"serviceType"]];
        [self setTransportType:[dictionary objectForKey:@"transportType"]];
        [self setPatientName:[dictionary objectForKey:@"patientName"]];
        [self setPatientGender:[dictionary objectForKey:@"patientGender"]];
        [self setPatientMedicalRecordNumber:[dictionary objectForKey:@"patientMedicalRecordNumber"]];
        [self setPatientHomeArea:[dictionary objectForKey:@"patientHomeArea"]];
        [self setFromArea:[dictionary objectForKey:@"fromArea"]];
        [self setToArea:[dictionary objectForKey:@"toArea"]];
        [self setEquipment:[dictionary objectForKey:@"equipment"]];
        [self setServiceLevelAgreement:[dictionary objectForKey:@"serviceLevelAgreement"]];
        [self setTimeRequested:[dictionary objectForKey:@"timeRequested"]];
        [self setTimeAssigned:[dictionary objectForKey:@"timeAssigned"]];
        [self setTimeAcknowledged:[dictionary objectForKey:@"timeAcknowledged"]];
        [self setTimeNeeded:[dictionary objectForKey:@"timeNeeded"]];
        [self setTimeStarted:[dictionary objectForKey:@"timeStarted"]];
        [self setRoundTrip:(BOOL)[dictionary objectForKey:@"roundTrip"]];
        [self setDescription:[dictionary objectForKey:@"description"]];
        [self setTimeClosed:[dictionary objectForKey:@"timeClosed"]];
        [self setIsDelayed:[dictionary objectForKey:@"isDelayed"]];
        [self setTransporters:[dictionary objectForKey:@"transporters"]];
	}
    
    return self;
}

- (void)start
{
    //make request
	[[AppDelegate sharedRestRequest] performGet:[NSString stringWithFormat:@"/transportworkorder/start/%@", [self transportWorkOrderId]] error:nil];
}

- (void)close
{
    //make request
	[[AppDelegate sharedRestRequest] performGet:[NSString stringWithFormat:@"/transportworkorder/close/%@", [self transportWorkOrderId]] error:nil];
}

- (void)removeDelay
{
    //make request
	[[AppDelegate sharedRestRequest] performGet:[NSString stringWithFormat:@"/transportworkorderdelay/removedelay/%@", [self transportWorkOrderId]] error:nil];
}

- (void)addNote:(NSString *)noteMessage
{
    
    
}

- (void)cancel:(NSString *)reason
{
    
    
}

- (BOOL)isStarted
{
    if([[self timeStarted] length] == 0)
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}

- (BOOL)hasBeenStarted
{
    return [[self timeStarted] length] > 0;
}

- (BOOL)hasBeenDelayed
{
    return [[self isDelayed] isEqualToString:@"true"];
}

- (BOOL)hasEquiment
{
    return ![[self equipment] isEqualToString:@"None"];
}

- (BOOL)hasAnotherTransporter
{
    return !([[self transporters] rangeOfString:@"/"].location == NSNotFound);
}

- (BOOL)hasNotes
{
    return ![[self description] isEqualToString:@""];
}

- (NSString *)getUrgency
{
    //create date formatter
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    //set format
    [dateFormat setDateFormat:@"MM/dd/yyyy h:mm a"];
    
    //get dates
    NSDate *now = [NSDate date];
    NSDate *needed = [dateFormat dateFromString:[self timeNeeded]];
    
    //calc diff
    NSTimeInterval distanceBetweenDates = [needed timeIntervalSinceDate:now];
    
    //figure out minutes
    int minutes = floor(distanceBetweenDates / 60);

    //figure out what to send back
    if(minutes <= 5)
    {
        return @"Bad";
    }
    else if (minutes <= 10)
    {
        return @"Caution";
    }
    else
    {
        return @"Good";
    }
}

@end
