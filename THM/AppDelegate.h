
#import <UIKit/UIKit.h>
#import <RestLibrary/RestRequest.h>
#import <CoreLocation/CoreLocation.h>

@class Transporter;

@interface AppDelegate : UIResponder <UIApplicationDelegate, RestRequestDelegate, CLLocationManagerDelegate>
{
    
}

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) CLLocationManager *locationManager;
@property Transporter *authenticatedTransporter;
@property UIView *overlayView;
@property NSMutableArray *currentMoves;
@property NSMutableArray *currentMessages;
@property NSMutableArray *currentBreaks;
@property double dataRefreshInterval;

- (NSString *)getProtocol;
- (NSString *)getHost;
- (void)setHost:(NSString *)newHost;
- (NSString *)getSecurityToken;
- (NSString *)getSecurityTokenQueryKey;

- (void)networkStatusChanged:(BOOL)networkIsAvailable;

+ (RestRequest *)sharedRestRequest;
+ (Transporter *)sharedAuthenticatedTransporter;

+ (NSMutableArray *)sharedCurrentMoves;
+ (NSMutableArray *)sharedCurrentMessages;
+ (NSMutableArray *)sharedCurrentBreaks;

- (void)initializeAllTabs;
- (void)refreshAllTabs;
- (void)refreshAllTabsWithSleep;

- (void)movesThreadMain;
- (void)refreshMoves;
- (void)refreshMovesFinishedWithData;

- (void)messagesThreadMain;
- (void)refreshMessages;
- (void)refreshMessagesFinishedWithData;

- (void)breaksThreadMain;
- (void)refreshBreaks;
- (void)refreshBreaksFinishedWithData;

@end