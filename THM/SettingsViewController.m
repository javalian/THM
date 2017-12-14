
#import "SettingsViewController.h"
#import "AppDelegate.h"

@implementation SettingsViewController

@synthesize alert;
@synthesize loggedInAs;
@synthesize webServicesURL;

- (void)viewDidLoad
{
    //call super
    [super viewDidLoad];
	
    //set background
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-pattern.png"]]];
    
    //get the app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //set currently logged in as
    self.loggedInAs.text = [NSString stringWithFormat:@"You are logged in as %@.", [[appDelegate authenticatedTransporter] fullName]];
    
    //set the user default for the REST web services domain to the view
    self.webServicesURL.text = [appDelegate getHost];
    
}

- (IBAction)logOut:(id)sender
{
    //get the app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //mark off duty on server
    [[AppDelegate sharedRestRequest] performGet:[NSString stringWithFormat:@"/transporter/markoffduty/%@", [[AppDelegate sharedAuthenticatedTransporter] transporterCode]] error:nil];
    
    //blank current transporter code
    [appDelegate setAuthenticatedTransporter:nil];
    
    //go back to log in screen
	[[self.presentingViewController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)webServicesUrlEditingEnded:(UITextField *)sender {
    //get the app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //if the new domain is reachable then reset the host variable
    if([[AppDelegate sharedRestRequest] isValidDomain:[webServicesURL text] transporterCode:[[AppDelegate sharedAuthenticatedTransporter] transporterCode]]) {
        
        //set the host to the new web services URL entered by the user
        [appDelegate setHost:webServicesURL.text];
        
        //set the backgroud of the web services URL back to white
        webServicesURL.backgroundColor = [UIColor whiteColor];
        
        //disable the field to prevent further editing
        webServicesURL.enabled = FALSE;
        
        return;
    }
    
    //if the domain is unreachable, then display an error to the user
    self.alert = [[UIAlertView alloc] initWithTitle:@"Invalid Services URL"
                                            message:@"The URL you have entered does not have any of the THM services."
                                           delegate:self
                                  cancelButtonTitle:@"Reset URL"
                                  otherButtonTitles:@"Re-enter URL", nil];
    
    [self.alert show];
    
}

- (IBAction)modifyRESTWebServiceURL:(id)sender {
    //Display alert message
    self.alert = [[UIAlertView alloc] initWithTitle:@"Password"
                                            message:nil
                                           delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"OK", nil];

    self.alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    
    [self.alert textFieldAtIndex:0].delegate = self;
    
    [self.alert show];
    
}

- (void)handlePaswordEntry
{
    UITextField *password = [self.alert textFieldAtIndex:0];
    
    //if the correct password enable the webs services URL field for editing and set focus to it
    if ([[password text] isEqual: @"7429"]) {
        [self.alert dismissWithClickedButtonIndex:1 animated:YES];
        
        webServicesURL.enabled = TRUE;
        [webServicesURL becomeFirstResponder];
    }
    else {
        [self.alert dismissWithClickedButtonIndex:1 animated:YES];
        
        //display a message to the user to let them know that the password is incorrect
        self.alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Password"
                                                message:@"The password you entered is incorrect."
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles: nil];
        
        [self.alert show];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if([self webServicesURL] == textField)
	{
		//hide keyboard
		[textField resignFirstResponder];
	
        return YES;
    }
    else if (self.alert != nil)
    {
        if ([self.alert.title isEqualToString:@"Password"] && [self.alert textFieldAtIndex:0] == textField) {
            //[self.alert dismissWithClickedButtonIndex:1 animated:YES];
            [self handlePaswordEntry];
        }
    }
	
	//don't allow return
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    NSString *alertTitle = alertView.title;
    
    if ([alertTitle isEqualToString:@"Password"]) {  //if the alert message being processed is the Password alert view
        if ([buttonTitle isEqualToString:@"OK"]) {
            [self handlePaswordEntry];
        }
    }
    else if ([alertTitle isEqualToString:@"Invalid Services URL"]) {  //if the alert message being processed is the Invalid Services URL alert view
        if ([buttonTitle isEqualToString:@"Reset URL"]) {
            //get the app delegate
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            //get the current host and set the web services URL field to it
            webServicesURL.text = [appDelegate getHost];
            
            //set the backgroud of the web services URL back to white
            webServicesURL.backgroundColor = [UIColor whiteColor];
            
            //disable the web services URL field
            webServicesURL.enabled = FALSE;
        }
        else if ([buttonTitle isEqualToString:@"Re-enter URL"]) {
            //set the backgroud of the web services URL field to red to indicate incorrect URL
            webServicesURL.backgroundColor = [UIColor redColor];
            
            //set focus to the web services URL field
            [webServicesURL becomeFirstResponder];
        }
    }
    
}

@end
