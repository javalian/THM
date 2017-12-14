
#import <Foundation/Foundation.h>

@interface Transporter : NSObject <RestObjectDelegate>
{
	
}

@property NSNumber *transporterId;
@property NSString *transporterCode;
@property NSString *fullName;
@property NSString *imageUrl;

- (id) initWithDictionary:(NSDictionary *)dictionary;

+ (BOOL)authenticate:(NSString *)transporterCode password:(NSString *)password;

+ (Transporter *)get:(NSString *)transporterCode;

+ (NSMutableArray *)getMoves:(NSString *)transporterCode;
+ (NSMutableArray *)getMessages:(NSString *)transporterCode;
+ (NSMutableArray *)getBreaks:(NSString *)transporterCode;

- (NSMutableArray *)moves;
- (NSMutableArray *)messages;
- (NSMutableArray *)breaks;

@end
