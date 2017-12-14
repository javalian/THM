
#import <UIKit/UIKit.h>
#import "Break.h"
#import "MBProgressHUD.h"

@interface MyBreaksViewController : UIViewController
{
    
    
}

@property Break *firstBreak;
@property Break *lunch;
@property Break *secondBreak;

@property IBOutlet UIButton *firstBreakButton;
@property IBOutlet UIButton *lunchButton;
@property IBOutlet UIButton *secondBreakButton;

@property IBOutlet UILabel *firstBreakLabel;
@property IBOutlet UILabel *lunchLabel;
@property IBOutlet UILabel *secondBreakLabel;

@property IBOutlet UILabel *firstBreakTimerLabel;
@property IBOutlet UILabel *lunchTimerLabel;
@property IBOutlet UILabel *secondBreakTimerLabel;

@property MBProgressHUD *progressIndicator;

@property NSTimer *breakTimer;

- (IBAction)requestFirstBreak:(id)sender;
- (IBAction)toggleLunch:(id)sender;
- (IBAction)requestSecondBreak:(id)sender;

- (void)onCurrentBreaksChanged:(NSNotification *)notification;
- (void)refreshData;
- (void)updateBadge;

- (IBAction)refreshManually:(id)sender;

- (void)startTimer:(UILabel *)label timedBreak:(Break *)timedBreak;
- (void)stopTimer;

@end
