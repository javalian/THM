
#import <UIKit/UIKit.h>
#import "THMTextField.h"

@interface LogInViewController : UIViewController

@property IBOutlet UILabel *authenticatingLabel;

@property IBOutlet THMTextField *userNameField;
@property IBOutlet THMTextField *passwordField;

@property IBOutlet UINavigationBar *navigationBar;

@property IBOutlet UIActivityIndicatorView *progressIndicator;

- (void)authenticate;

@end
