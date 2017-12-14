
#import <UIKit/UIKit.h>
#import "THMBorderedView.h"

@interface MyMovesCell : UITableViewCell
{
    
}

@property (nonatomic, strong) IBOutlet UIImageView *urgencyIndicatorView;
@property (nonatomic, strong) IBOutlet UIImageView *viewedIndicatorImageView;

@property (nonatomic, strong) IBOutlet UIImageView *startedImageView;
@property (nonatomic, strong) IBOutlet UIImageView *delayedImageView;
@property (nonatomic, strong) IBOutlet UIImageView *equipmentImageView;
@property (nonatomic, strong) IBOutlet UIImageView *transporterImageView;
@property (nonatomic, strong) IBOutlet UIImageView *notesImageView;

@property (nonatomic, strong) IBOutlet UILabel *patientNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *fromAreaLabel;
@property (nonatomic, strong) IBOutlet UILabel *toAreaLabel;

@end
