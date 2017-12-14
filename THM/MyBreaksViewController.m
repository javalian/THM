
#import "MyBreaksViewController.h"
#import "AppDelegate.h"
#import "MessageContractModel.h"
#import "Break.h"
#import "MBProgressHUD.h"

@implementation MyBreaksViewController

@synthesize firstBreak;
@synthesize lunch;
@synthesize secondBreak;

@synthesize firstBreakButton;
@synthesize lunchButton;
@synthesize secondBreakButton;

@synthesize firstBreakLabel;
@synthesize lunchLabel;
@synthesize secondBreakLabel;

@synthesize firstBreakTimerLabel;
@synthesize lunchTimerLabel;
@synthesize secondBreakTimerLabel;

@synthesize breakTimer;

@synthesize progressIndicator;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        //listen to notification center for app delegate to signal data has changed
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurrentBreaksChanged:) name:@"currentBreaksChanged" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    //call super
    [super viewDidLoad];
    
    //set background
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-pattern.png"]]];
    
    self.navigationController.navigationBar.translucent = FALSE;
    
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
    UIImage *refreshImage;
    
    if ([sysVersion floatValue] >= 7.0) {
        //create add image
        refreshImage = [[UIImage imageNamed:@"refresh-button-redux.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    else {
        //create add image
        refreshImage = [[UIImage imageNamed:@"refresh-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    //set bar button item background
    [self.navigationItem.leftBarButtonItem setBackgroundImage:refreshImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationItem.leftBarButtonItem setBackgroundImage:refreshImage forState:UIControlEventTouchDown barMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated
{
    //refresh data
    [self refreshData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //clear badge
    [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:nil];
}

- (void)onCurrentBreaksChanged:(NSNotification *)notification
{
    //refresh data
    [self refreshData];
}

- (void)refreshManually:(id)sender
{
    //create hud progress indicator
    [self setProgressIndicator:[[MBProgressHUD alloc] initWithView:self.navigationController.view]];
    
    //add as subview
	[self.navigationController.view addSubview:[self progressIndicator]];
	
	//set properties
	[[self progressIndicator] setMode:MBProgressHUDModeIndeterminate];
	
	// myProgressTask uses the HUD instance to update progress
	[[self progressIndicator] showWhileExecuting:@selector(refreshAllTabsWithSleep) onTarget:[[UIApplication sharedApplication] delegate] withObject:nil animated:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
	//remove hud from screen and kill it
	[[self progressIndicator] removeFromSuperview];
	[self setProgressIndicator:nil];
}

- (void)refreshData
{
    //get the breaks collection from the app delegate
    for (Break *b in [AppDelegate sharedCurrentBreaks])
    {
        //check which break it is
        if([b.breakType isEqualToString:@"FirstBreak"])
        {
            if([b.ended isEqualToString:@""])
            {
                //on first break set label
                [firstBreakLabel setText:@"You are currently on your first break."];
                
                //show countdown timer
                if(![self breakTimer])
                {
                    if([self firstBreakTimerLabel])
                    {
                        [self startTimer:[self firstBreakTimerLabel] timedBreak:b];
                    }
                }
            }
            else
            {
                [firstBreakLabel setText:@"You have already taken your first break."];
            }
            
            //hide button 
            [firstBreakButton setHidden:YES];
        }
        else if ([b.breakType isEqualToString:@"Lunch"])
        {
            if([b.ended isEqualToString:@""])
            {
                [lunchLabel setText:@"You are currently taking your lunch."];
                
                //show countdown timer
                if(![self breakTimer])
                {
                    if([self lunchTimerLabel])
                    {
                        [self startTimer:[self lunchTimerLabel] timedBreak:b];
                    }
                }
            }
            else
            {
                [lunchLabel setText:@"You have already taken your lunch."];
                
                //stop countdown timer
                if([self breakTimer])
                {
                    [self stopTimer];
                }
                
                //create date formatter
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                
                //set format
                [dateFormat setDateFormat:@"MM/dd/yyyy h:mm:ss a"];
                
                //get dates
                NSDate *started = [dateFormat dateFromString:b.started];
                NSDate *ended = [dateFormat dateFromString:b.ended];
                
                //output formatter
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                
                [df setDateFormat:@"h:mm a"];
                
                //set label
                [[self lunchTimerLabel] setText:[NSString stringWithFormat:@"From %@ to %@", [df stringFromDate:started], [df stringFromDate:ended]]];
            }
            
            //hide button
            [lunchButton setHidden:YES];
        }
        else if ([b.breakType isEqualToString:@"SecondBreak"])
        {
            if([b.ended isEqualToString:@""])
            {
                [secondBreakLabel setText:@"You are currently on your second break."];
            }
            else
            {
                [secondBreakLabel setText:@"You have already taken your second break."];
            }
            
            //hide button
            [secondBreakButton setHidden:YES];
        }
    }
    
    //update badge by checking if any break information has changed
    [self updateBadge];
}

- (void)updateBadge;
{
    //if initial call don't need to do anything
    if(![self firstBreak])
    {
        for (Break *b in [AppDelegate sharedCurrentBreaks])
        {
            //check which break it is
            if([b.breakType isEqualToString:@"FirstBreak"])
            {
                //set to local for next compare
                [self setFirstBreak:b];
            }
            else if ([b.breakType isEqualToString:@"Lunch"])
            {
                //set to local for next compare
                [self setLunch:b];
            }
            else if ([b.breakType isEqualToString:@"SecondBreak"])
            {
                //set to local for next compare
                [self setSecondBreak:b];
            }
        }
        
        //get out
        return;
    }
    
    //set up counter for changes
    int changeCount = 0;
    
    //loop breaks
    for (Break *b in [AppDelegate sharedCurrentBreaks])
    {
        //check which break it is
        if([b.breakType isEqualToString:@"FirstBreak"])
        {
            //compare
            if(![[b started] isEqualToString:[[self firstBreak] started]] || ![[b ended] isEqualToString:[[self firstBreak] ended]]) { changeCount++; }
            
            //set to local for next compare
            [self setFirstBreak:b];
        }
        else if ([b.breakType isEqualToString:@"Lunch"])
        {
            //compare
            if(![[b started] isEqualToString:[[self lunch] started]] || ![[b ended] isEqualToString:[[self lunch] ended]]) { changeCount++; }
            
            //set to local for next compare
            [self setLunch:b];
        }
        else if ([b.breakType isEqualToString:@"SecondBreak"])
        {
            //compare
            if(![[b started] isEqualToString:[[self secondBreak] started]] || ![[b ended] isEqualToString:[[self secondBreak] ended]]) { changeCount++; }
            
            //set to local for next compare
            [self setSecondBreak:b];
        }
    }
    
    //see if there were any changes
    if(changeCount > 0)
    {
        //update badge
        [[[[[self tabBarController] tabBar] items] objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%d", changeCount]];
    }
}

- (IBAction)requestFirstBreak:(id)sender
{
    //get the app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //create message contract model
    MessageContractModel *model = [[MessageContractModel alloc] init];
    
    //set properties
    [model setClientToken:[[appDelegate authenticatedTransporter] transporterCode]];
    [model setMessageText:@"I am requesting my first break."];
    
    //create dictionary
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[model clientToken], @"clientToken", [model messageText], @"messageText", nil];
    
    //make post
    [[AppDelegate sharedRestRequest] performPost:@"/message/send" jsonData:dictionary error:nil];
    
    //hide button
    [firstBreakButton setHidden:YES];
    
    //set label
    [firstBreakLabel setText:@"You have requested your first break."];
}

- (IBAction)toggleLunch:(id)sender
{
    //get the app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //get current transporter code
    NSString *transporterCode = [[appDelegate authenticatedTransporter] transporterCode];
    
    //make request
	[[AppDelegate sharedRestRequest] performGet:[NSString stringWithFormat:@"/break/togglelunch/%@", transporterCode] error:nil];
    
    //hide button
    [lunchButton setHidden:YES];
    
    //set label
    [lunchLabel setText:@"You are currently taking your lunch."];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] refreshBreaks];
    
    /*
    if([[[lunchButton titleLabel] text] isEqualToString:@"End Lunch"])
    {
        //hide button
        [lunchButton setHidden:YES];
        
        [lunchLabel setText:@"You have already taken your lunch."];
        
        return;
    }
     */
    
    //set button text
    //[lunchButton setTitle:@"End Lunch" forState:UIControlStateNormal];
    //[lunchButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    //set label
    //[lunchLabel setText:@"You are currently taking your lunch."];

}

-(IBAction)requestSecondBreak:(id)sender
{
    //get the app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //create message contract model
    MessageContractModel *model = [[MessageContractModel alloc] init];
    
    //set properties
    [model setClientToken:[[appDelegate authenticatedTransporter] transporterCode]];
    [model setMessageText:@"I am requesting my second break."];
    
    //create dictionary
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[model clientToken], @"clientToken", [model messageText], @"messageText", nil];
    
    //make post
    [[AppDelegate sharedRestRequest] performPost:@"/message/send" jsonData:dictionary error:nil];
    
    //hide button
    [secondBreakButton setHidden:YES];
    
    //set label
    [secondBreakLabel setText:@"You have requested your second break."];
}

- (void)startTimer:(UILabel *)label timedBreak:(Break *)timedBreak
{
    //create dictionary
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    
    //set break and label
    if(label) { [userInfo setObject:label forKey:@"label"]; }
    [userInfo setObject:timedBreak forKey:@"timedBreak"];
    
    //create timer
    [self setBreakTimer:[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick:) userInfo:userInfo repeats:YES]];
}

- (void)stopTimer
{
    [[self breakTimer] invalidate];
}

- (void) tick:(NSTimer *)timer
{
    //get user info
    NSDictionary *userInfo = [timer userInfo];
    
    //get break
    Break *timedBreak = (Break *)[userInfo objectForKey:@"timedBreak"];
    
    //get label
    UILabel *label = (UILabel *)[userInfo objectForKey:@"label"];
    
    //break total time allowed
    double breakTotalTimeAllowed = 0.0;
    
    //calculate total time allowed for break (15 for breaks 30 for lunch
    if([timedBreak.breakType isEqualToString:@"Lunch"])
    {
        //30 mins for lunch
        breakTotalTimeAllowed = 30.0 * 60.00;
    }
    else
    {
        //15 mins for breaks
        breakTotalTimeAllowed = 15.0 * 60.00;
    }
    
    //create date formatter
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    //set format
    [dateFormat setDateFormat:@"MM/dd/yyyy h:mm:ss a"];
    
    //get dates
    NSDate *started = [dateFormat dateFromString:[timedBreak started]];
    NSDate *finished = [started dateByAddingTimeInterval:breakTotalTimeAllowed];
    
    //calc diff
    NSTimeInterval timeLeft = [finished timeIntervalSinceNow];
    
    //if negative then lunch should be over
    if(timeLeft < 0)
    {
        //set label
        [label setText:[NSString stringWithFormat:@"Time Left: %02d:%02d", 0, 0]];
        
        //stop timer
        [self stopTimer];
        
        //get out
        return;
    }
    
    //get parts
    int hours = timeLeft / 3600;
    int minutes = (timeLeft - (hours*3600)) / 60;
    int seconds = (int)timeLeft % 60;
    
    //validate
    if(label)
    {
        //write to label
        [label setText:[NSString stringWithFormat:@"Time Left: %02d:%02d", minutes, seconds]];
    }
}



@end
