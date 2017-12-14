
#import "LogInViewController.h"
#import "AppDelegate.h"
#import "Transporter.h"

@implementation LogInViewController

@synthesize authenticatingLabel;

@synthesize userNameField;
@synthesize passwordField;

@synthesize navigationBar;

@synthesize progressIndicator;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        //listen to notification center for app delegate to signal data has changed
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkStatusChangedToNotAvailable:) name:@"networkStatusChangedToNotAvailable" object:nil];
    }
    return self;
}

- (void)onNetworkStatusChangedToNotAvailable:(NSNotification *)notification
{
    //hide keyboard
    [[self view] endEditing:TRUE];
}

- (void)viewDidLoad
{
    //set background
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-pattern.png"]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    //stop progress indicator
    [[self progressIndicator] stopAnimating];
}

- (void)viewDidAppear:(BOOL)animated
{
    //set focus and show keyboard
    [[self userNameField] becomeFirstResponder];
}

- (void)authenticate
{
    //start progress indicator
    [[self progressIndicator] startAnimating];
    
    //run this as background in case of long running connection to network call
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        //hacky but need to sleep here so progress indicators are useful and let user know
        //something is actually happening when the app is refreshed for data
        [NSThread sleepForTimeInterval:.75];
        
        //authenticate to server
        if([Transporter authenticate:[[self userNameField] text] password:[[self passwordField] text]])
        {
            //call updating ui and other stuff on main thread
            [self performSelectorOnMainThread:@selector(onSuccessfulAuthentication) withObject:nil waitUntilDone:YES];
        }
        else
        {
            //call updating ui and other stuff on main thread
            [self performSelectorOnMainThread:@selector(onFailedAuthentication) withObject:nil waitUntilDone:YES];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //stop progress indicator
            [[self progressIndicator] stopAnimating];
        });
    });
}

- (void)onSuccessfulAuthentication
{
    //get the app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //get authenticated transporter
    Transporter *transporter = [Transporter get:[[self userNameField] text]];
    
    //set the transporter id in app delegate for use by other view controllers
    [appDelegate setAuthenticatedTransporter:transporter];
    
    //clear out fields
    [[self userNameField] setText:@""];
    [[self passwordField] setText:@""];
    
    //segue to the actual app
    [self performSegueWithIdentifier:@"ShowLocation" sender:self];
}

- (void)onFailedAuthentication
{
    //stop progress indicator
    [[self progressIndicator] stopAnimating];
    
    //create alert that user name / password didn't work
    UIAlertView *error = [[UIAlertView alloc] initWithTitle: @"Log On Error" message: @"Your user name or password is incorrect." delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
    
    //show it
    [error show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if([self userNameField] == textField)
	{
		//change focus to password
		[[self passwordField] becomeFirstResponder];
	}
	if([self passwordField] == textField)
	{
		//hide keyboard
		[textField resignFirstResponder];
		
		//do authentication
		[self authenticate];
	}
	
	//don't allow return
    return NO;
}

@end
