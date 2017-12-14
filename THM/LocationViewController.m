
#import "LocationViewController.h"
#import "AppDelegate.h"

@implementation LocationViewController

- (IBAction)setLocationCdh:(id)sender
{
    //mark on duty
    [self markOnDuty];
    
    //set location
    [[AppDelegate sharedRestRequest] performGet:[NSString stringWithFormat:@"/transporter/setlocation/%@/1", [[AppDelegate sharedAuthenticatedTransporter] transporterCode]] error:nil];
    
    //segue to app
    [self performSegueWithIdentifier:@"ShowApp" sender:self];
}

- (IBAction)setLocationDelnor:(id)sender
{
    //mark on duty
    [self markOnDuty];
    
    //set location
    [[AppDelegate sharedRestRequest] performGet:[NSString stringWithFormat:@"/transporter/setlocation/%@/3", [[AppDelegate sharedAuthenticatedTransporter] transporterCode]] error:nil];
    
    //segue to app
    [self performSegueWithIdentifier:@"ShowApp" sender:self];
}

- (void)markOnDuty
{
    [[AppDelegate sharedRestRequest] performGet:[NSString stringWithFormat:@"/transporter/markonduty/%@", [[AppDelegate sharedAuthenticatedTransporter] transporterCode]] error:nil];
}

@end
