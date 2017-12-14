
#import <UIKit/UIKit.h>

@interface CancelMoveViewController : UIViewController <UITextViewDelegate>
{
    
}

@property NSNumber *transportWorkOrderId;
@property IBOutlet UITextView *textView;

- (IBAction)cancelMove:(id)sender;

@end
