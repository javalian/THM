
#import <UIKit/UIKit.h>
#import <UIKit/UIColor.h>
#import <RestLibrary/Reachability.h>

@interface SettingsViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>

@property UIAlertView *alert;
@property IBOutlet UILabel *loggedInAs;
@property IBOutlet UITextField *webServicesURL;


- (IBAction)logOut:(id)sender;
- (IBAction)webServicesUrlEditingEnded:(UITextField *)sender;
- (IBAction)modifyRESTWebServiceURL:(id)sender;
- (void)handlePaswordEntry;

@end
