
#import <UIKit/UIKit.h>
#import "MoveDetailViewController.h"
#import "MBProgressHUD.h"

@interface MyMovesViewController : UITableViewController <MoveDetailViewControllerDelegate>
{
    
}

@property (nonatomic, strong) NSMutableArray *viewedMoves;
@property BOOL isEditing;
@property MBProgressHUD *progressIndicator;

- (void)onCurrentMovesChanged:(NSNotification *)notification;
- (void)refreshData;
- (void)refreshDataWithSleep;
- (void)updateBadge;

- (IBAction)refreshManually:(id)sender;

@end
