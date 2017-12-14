
#import <Foundation/Foundation.h>

@interface Move : NSObject <RestObjectDelegate>
{
	
}

@property NSNumber *transportWorkOrderId;
@property NSString *status;
@property NSString *serviceType;
@property NSString *transportType;
@property NSString *patientName;
@property NSString *patientGender;
@property NSString *patientMedicalRecordNumber;
@property NSString *patientHomeArea;
@property NSString *fromArea;
@property NSString *toArea;
@property NSString *equipment;
@property NSNumber *serviceLevelAgreement;
@property NSString *timeRequested;
@property NSString *timeAssigned;
@property NSString *timeAcknowledged;
@property NSString *timeNeeded;
@property NSString *timeStarted;
@property BOOL roundTrip;
@property NSString *description;
@property NSString *timeClosed;
@property NSString *isDelayed;
@property NSString *transporters;

- (id) initWithDictionary:(NSDictionary *)dictionary;

- (void)start;
- (void)close;
- (void)removeDelay;

- (void)addNote:(NSString *)noteMessage;
- (void)cancel:(NSString *)reason;

- (BOOL)isStarted;

- (BOOL)hasBeenStarted;
- (BOOL)hasBeenDelayed;
- (BOOL)hasEquiment;
- (BOOL)hasAnotherTransporter;
- (BOOL)hasNotes;

- (NSString *)getUrgency;

@end
