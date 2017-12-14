
#import <UIKit/UIKit.h>
#import "Message.h"
#import "THMTextView.h"

@interface ViewMessageViewController : UIViewController
{
    
}

@property Message *message;

@property IBOutlet UILabel *fromLabel;
@property IBOutlet UILabel *dateLabel;
@property IBOutlet THMTextView *messageLabel;

@end
