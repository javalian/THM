
#import <UIKit/UIKit.h>
#import "THMTextView.h"

@interface SendMessageViewController : UIViewController <UITextViewDelegate>
{
    
}

@property IBOutlet THMTextView *textView;

- (IBAction)sendMessage:(id)sender;

@end
