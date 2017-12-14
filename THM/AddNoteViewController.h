
#import <UIKit/UIKit.h>

@interface AddNoteViewController : UIViewController <UITextViewDelegate>
{
    
}

@property NSNumber *transportWorkOrderId;
@property IBOutlet UITextView *textView;

- (IBAction)addNote:(id)sender;

@end
