
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;
@synthesize locationManager;
@synthesize currentMoves;
@synthesize currentMessages;
@synthesize currentBreaks;
@synthesize authenticatedTransporter;
@synthesize overlayView;
@synthesize dataRefreshInterval;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    //need to initialize static object in shared rest request in order to get reachability going
    [AppDelegate sharedRestRequest];
    
    //setup host domain in user preferences
    if ([self getHost] == NULL) {
        [self setHost:@"thmios.cadencehealth.org"];
    }
    
    //set up nav bar appearance
    [self customizeNavigationAppearance];
    
    //create overlay view
    [self setOverlayView:[[UIView alloc] initWithFrame:CGRectMake(0,0,320,480)]];
    
    //set properties
    [[self overlayView] setBackgroundColor:[UIColor blackColor]];
    [[self overlayView] setAlpha:0.0];
    [[self overlayView] setOpaque:NO];
    
    //create label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 280, 200)];
    
    //set properties
    [label setText:@"No network connection available.  The THM application will become active when you are connected to a WIFI or cellular network."];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setNumberOfLines:0];
    
    //add to overlay
    [[self overlayView] addSubview:label];
    
    //create spinner
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    //set location
    spinner.center = CGPointMake(160, 310);

    //set color
    spinner.color = [UIColor whiteColor];

    //add to overlay
    [[self overlayView] addSubview:spinner];

    //start the spinner
    [spinner startAnimating];

    //set data refresh interval
    [self setDataRefreshInterval:30];
    
    //initialize data arrays
    [self setCurrentMoves:[[NSMutableArray alloc] initWithCapacity:5]];
    [self setCurrentMessages:[[NSMutableArray alloc] initWithCapacity:10]];
    [self setCurrentBreaks:[[NSMutableArray alloc] initWithCapacity:5]];
    
    //create thread that will check for moves
    NSThread *movesThread = [[NSThread alloc] initWithTarget:self selector:@selector(movesThreadMain) object:nil];
    
    //create thread that will check for messages
    NSThread *messagesThread = [[NSThread alloc] initWithTarget:self selector:@selector(messagesThreadMain) object:nil];
    
    //create thread that will check for breaks
    NSThread *breaksThread = [[NSThread alloc] initWithTarget:self selector:@selector(breaksThreadMain) object:nil];
    
    //start threads
    [movesThread start];
    [messagesThread start];
    [breaksThread start];
    
    //create location manager
    [self setLocationManager:[[CLLocationManager alloc] init]];
     
    //set delegate
    [[self locationManager] setDelegate:self];
     
    //only applies when in foreground otherwise it is very significant changes
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //set distance filter for 10 foot accuracy
    [locationManager setDistanceFilter:10.0f];
    [locationManager setDesiredAccuracy:10.0f];
    
    //start monitoring.  note that the method startUpdatingLocation is a potential battery drain and calling for startMonitoringSignificantLocationChanges will
    //have much less battery drain on the device.  when we want to track transporter location down to the second/foot then switch this to use startUpdatingLocation.
    [locationManager startUpdatingLocation];
    
    //send back ok
    return YES;
}


- (void) customizeNavigationAppearance
{
    //set navigation bar appearance throughout the app
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigation-background.png"] forBarMetrics:UIBarMetricsDefault];
    
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
    UIImage *navigationBackButtonImage;
    
    if ([sysVersion floatValue] >= 7.0) {
        //create button image for navigation bar back button
        navigationBackButtonImage = [[UIImage imageNamed:@"back-button-redux.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
        //set bar button image - have to do for both normal state and touch down
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:navigationBackButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:navigationBackButtonImage forState:UIControlEventTouchDown barMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackIndicatorImage:navigationBackButtonImage];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:navigationBackButtonImage];
    }
    else {
        //create button image for navigation bar back button
        navigationBackButtonImage = [[UIImage imageNamed:@"back-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];

        //set bar button image - have to do for both normal state and touch down
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:navigationBackButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:navigationBackButtonImage forState:UIControlEventTouchDown barMetrics:UIBarMetricsDefault];
    }
    
    
}

+ (RestRequest *)sharedRestRequest
{
    //create request
    static RestRequest *request;
    
    //lock it
    @synchronized(self)
    {
        //lazy load it here
        if(!request)
        {
            //create request
            request = [[RestRequest alloc] initWithDelegate:((AppDelegate *)[[UIApplication sharedApplication] delegate])];
        }
    }
    
    //send it back
    return request;
}

+ (Transporter *)sharedAuthenticatedTransporter
{
    return [((AppDelegate *)[[UIApplication sharedApplication] delegate]) authenticatedTransporter];
}

+ (NSMutableArray *)sharedCurrentMoves
{
    return [((AppDelegate *)[[UIApplication sharedApplication] delegate]) currentMoves];
}

+ (NSMutableArray *)sharedCurrentMessages
{
    return [((AppDelegate *)[[UIApplication sharedApplication] delegate]) currentMessages];
}

+ (NSMutableArray *)sharedCurrentBreaks
{
    return [((AppDelegate *)[[UIApplication sharedApplication] delegate]) currentBreaks];
}

- (NSString *)getProtocol
{
    return @"https";
}

- (NSString *)getHost
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *servicesURL = [defaults objectForKey:@"webServicesURL"];
    
    return servicesURL;

    //return @"thmios.cadencehealth.org";
}

- (void)setHost:(NSString *)newHost
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:newHost forKey:@"webServicesURL"];
}

- (NSString *)getSecurityToken
{
    if([self authenticatedTransporter])
    {
        return [[self authenticatedTransporter] transporterCode];
    }
    else
    {
        return [RestRequest defaultSecurityToken];
    }
}

- (NSString *)getSecurityTokenQueryKey
{
    return @"clientToken";
}

- (void)networkStatusChanged:(BOOL)networkIsAvailable
{
    //check if network connection
    if(networkIsAvailable == NO)
    {
        //get main window
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        
        //notify listeners that no network is available.  most controllers will use this to hide the keyboard before overlay is rendered visible
        [[NSNotificationCenter defaultCenter] postNotificationName:@"networkStatusChangedToNotAvailable" object:self];
        
        //check if view is already shown by interrogating alpha value (set initially to 0.0 and when removed to 0.0)
        if([[self overlayView] alpha] == 0.0)
        {
            //insert view over window
            [mainWindow insertSubview:[self overlayView] aboveSubview:mainWindow];
            
            //animate alpha of view to fade in
            [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{ [[self overlayView] setAlpha:.85]; } completion:^(BOOL finished) { }];
        }
    }
    else
    {
        //animate alpha of view to fade out and remove overlay from window
        [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{ [[self overlayView] setAlpha:0.0]; } completion:^(BOOL finished){ [[self overlayView] removeFromSuperview]; }];
    }
}



- (void)initializeAllTabs
{
    //refresh moves
    [self refreshMoves];
    
    //refresh messages
    [self refreshMessages];
    
    //refresh breaks
    [self refreshBreaks];
}


- (void)refreshAllTabs
{
    //refresh moves
    [self refreshMoves];
    
    //refresh messages
    [self refreshMessages];
    
    //refresh breaks
    [self refreshBreaks];
}

- (void)refreshAllTabsWithSleep
{
    //hacky but need to sleep here so progress indicators are useful and let user know
    //something is actually happening when the app is refreshed for data
    [NSThread sleepForTimeInterval:.75];
    
    //refresh
    [self refreshAllTabs];
}


- (void)movesThreadMain
{
    //continue to run thread throughout application
    while(true)
    {
        //refresh moves
        [self refreshMoves];

        //sleep until next refresh
        [NSThread sleepForTimeInterval:[self dataRefreshInterval]];
    }
}

- (void)refreshMoves
{
    //check that authenticated
    if([self authenticatedTransporter])
    {
        //set up error
        NSError *error = nil;
        
        //make request
        NSMutableArray *moves = [[self authenticatedTransporter] moves];
        
        //check for problems
        if(error) { }
        
        //validate - will be nil when network is down or some other problem
        if(moves)
        {
            //set to local
            [self setCurrentMoves:moves];
            
            //need to call our finished method on the main thread so that the NSNotification will go out over
            //the main ui thread.  this will prevent problems in the view controllers with accessing data on
            //a background thread.
            [self performSelectorOnMainThread:@selector(refreshMovesFinishedWithData) withObject:nil waitUntilDone:YES];
        }
    }
}

- (void)refreshMovesFinishedWithData
{
    //double check we're on the main thread here
    if (![NSThread isMainThread])
    {
        //this recursively calls self on main thread as _cmd is interal pointer to the current method call
        [self performSelectorOnMainThread:_cmd withObject:nil waitUntilDone:YES];
    }
    
    //notify listeners
    [[NSNotificationCenter defaultCenter] postNotificationName:@"currentMovesChanged" object:self];
}






- (void)messagesThreadMain
{
    //continue to run thread throughout application
    while(true)
    {
        //refresh messages
        [self refreshMessages];
        
        //sleep until next refresh
        [NSThread sleepForTimeInterval:[self dataRefreshInterval]];
    }
}

- (void)refreshMessages
{
    //check that authenticated
    if([self authenticatedTransporter])
    {
        //set up error
        NSError *error = nil;
        
        //make request
        NSMutableArray *messages = [[self authenticatedTransporter] messages];
        
        //check for problems
        if(error) { }
        
        //validate
        if(messages)
        {
            //set to local
            [self setCurrentMessages:messages];
            
            //need to call our finished method on the main thread so that the NSNotification will go out over
            //the main ui thread.  this will prevent problems in the view controllers with accessing data on
            //a background thread.
            [self performSelectorOnMainThread:@selector(refreshMessagesFinishedWithData) withObject:nil waitUntilDone:YES];
        }
    }
}

- (void)refreshMessagesFinishedWithData
{
    //double check we're on the main thread here
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:_cmd withObject:nil waitUntilDone:YES];
    }
    
    //notify listeners
    [[NSNotificationCenter defaultCenter] postNotificationName:@"currentMessagesChanged" object:self];
}








- (void)breaksThreadMain
{
    //continue to run thread throughout application
    while(true)
    {
        //refresh moves
        [self refreshBreaks];
        
        //sleep until next refresh
        [NSThread sleepForTimeInterval:[self dataRefreshInterval]];
    }
}

- (void)refreshBreaks
{
    //check that authenticated
    if([self authenticatedTransporter])
    {
        //set up error
        NSError *error = nil;
        
        //make request
        NSMutableArray *breaks = [[self authenticatedTransporter] breaks];
        
        //check for problems
        if(error) { }
        
        //validate
        if(breaks)
        {
            //set to local
            [self setCurrentBreaks:breaks];
            
            //need to call our finished method on the main thread so that the NSNotification will go out over
            //the main ui thread.  this will prevent problems in the view controllers with accessing data on
            //a background thread.
            [self performSelectorOnMainThread:@selector(refreshBreaksFinishedWithData) withObject:nil waitUntilDone:YES];
        }
    }
}

- (void)refreshBreaksFinishedWithData
{
    //double check we're on the main thread here
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:_cmd withObject:nil waitUntilDone:YES];
    }
    
    //notify listeners
    [[NSNotificationCenter defaultCenter] postNotificationName:@"currentBreaksChanged" object:self];
}


     
     
     
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //get coordinates
    CLLocationCoordinate2D currentCoordinates = newLocation.coordinate;
    
    NSLog(@"Location updated...");
    NSLog(@"Entered new Location with the coordinates Latitude: %f Longitude: %f", currentCoordinates.latitude, currentCoordinates.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Unable to start location manager. Error:%@", [error description]);
}

@end
