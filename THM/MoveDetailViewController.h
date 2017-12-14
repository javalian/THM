
#import <UIKit/UIKit.h>
#import "Move.h"

@protocol MoveDetailViewControllerDelegate <NSObject>

- (void)moveDetailViewControllerDidStartWorkOrder;
- (void)moveDetailViewControllerDidCompleteWorkOrder;
- (void)moveDetailViewControllerDidAddDelay;
- (void)moveDetailViewControllerDidRemoveDelay;

@end

@interface MoveDetailViewController : UIViewController
{
    
}

@property (nonatomic, weak) id <MoveDetailViewControllerDelegate> delegate;

@property IBOutlet UISwipeGestureRecognizer *swipeGestureRecognizer;

@property Move *move;

@property (nonatomic, strong) IBOutlet UIImageView *urgencyIndicatorView;

@property IBOutlet UILabel *transportWorkOrderIdLabel;
@property IBOutlet UILabel *statusLabel;
@property IBOutlet UILabel *serviceTypeLabel;
@property IBOutlet UILabel *transportTypeLabel;
@property IBOutlet UILabel *patientNameLabel;
@property IBOutlet UILabel *patientGenderLabel;
@property IBOutlet UILabel *patientMedicalRecordNumberLabel;
@property IBOutlet UITextView *patientHomeAreaLabel;
@property IBOutlet UITextView *fromAreaLabel;
@property IBOutlet UITextView *toAreaLabel;
@property IBOutlet UILabel *equipmentLabel;
@property IBOutlet UILabel *serviceLevelAgreementLabel;
@property IBOutlet UILabel *timeRequestedLabel;
@property IBOutlet UILabel *timeAssignedLabel;
@property IBOutlet UILabel *timeAcknowledgedLabel;
@property IBOutlet UILabel *timeNeededLabel;
@property IBOutlet UILabel *timeStartedLabel;
@property IBOutlet UILabel *roundTripLabel;
@property IBOutlet UITextView *descriptionLabel;
@property IBOutlet UILabel *timeClosedLabel;

@property IBOutlet UIView *containerView;

@property IBOutlet UIButton *startCompleteButton;
@property IBOutlet UIButton *addRemoveDelayButton;

- (IBAction)startCompleteAction:(id)sender;
- (IBAction)addRemoveDelayAction:(id)sender;
- (IBAction)addNote:(id)sender;
- (IBAction)cancelMove:(id)sender;

@end

