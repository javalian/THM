
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MyMessagesViewController : UITableViewController
{
    
}

@property (nonatomic, strong) NSMutableArray *viewedMessages;
@property BOOL isEditing;
@property MBProgressHUD *progressIndicator;

- (void)onCurrentMessagesChanged:(NSNotification *)notification;
- (void)refreshData;
- (void)refreshDataWithSleep;
- (void)updateBadge;

- (IBAction)refreshManually:(id)sender;

@end
