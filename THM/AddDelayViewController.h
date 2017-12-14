
#import <UIKit/UIKit.h>
#import "Move.h"

@interface AddDelayViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    
}

@property NSNumber *transportWorkOrderId;
@property (nonatomic, strong) NSMutableArray *delayReasons;
@property IBOutlet UIPickerView *picker;

@property Move *move;

- (IBAction)addDelayAction:(id)sender;

@end
