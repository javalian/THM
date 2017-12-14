
#import "MoveDetailViewController.h"
#import "AddDelayViewController.h"
#import "AddNoteViewController.h"
#import "SendMessageViewController.h"
#import "CancelMoveViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MoveDetailViewController ()

@end

@implementation MoveDetailViewController

@synthesize delegate;

@synthesize swipeGestureRecognizer;

@synthesize move;

@synthesize urgencyIndicatorView;

@synthesize transportWorkOrderIdLabel;
@synthesize statusLabel;
@synthesize serviceTypeLabel;
@synthesize transportTypeLabel;
@synthesize patientNameLabel;
@synthesize patientGenderLabel;
@synthesize patientMedicalRecordNumberLabel;
@synthesize patientHomeAreaLabel;
@synthesize fromAreaLabel;
@synthesize toAreaLabel;
@synthesize equipmentLabel;
@synthesize serviceLevelAgreementLabel;
@synthesize timeRequestedLabel;
@synthesize timeAssignedLabel;
@synthesize timeAcknowledgedLabel;
@synthesize timeNeededLabel;
@synthesize timeStartedLabel;
@synthesize roundTripLabel;
@synthesize descriptionLabel;
@synthesize timeClosedLabel;

@synthesize containerView;

@synthesize startCompleteButton;
@synthesize addRemoveDelayButton;

- (void)loadView
{
    [super loadView];
    
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
    
    if ([sysVersion floatValue] >= 7.0) {
        UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 43.0f, 44.0f)];
        UIImage *backImage = [[UIImage imageNamed:@"back-button-redux.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [backButton setBackgroundImage:backImage  forState:UIControlStateNormal];
        [backButton setTitle:@"" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backButtonItem;
    }
}

-(void) popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self move] != nil)
	{
        //NSString *patientHomeArea = [NSString stringWithString:[move patientHomeArea]];
        //NSString *fromArea = [NSString stringWithString:[move fromArea]];
        //NSString *toArea = [NSString stringWithString:[move toArea]];
        
        //patientHomeArea = [self wrapText:patientHomeArea];
        //fromArea = [self wrapText:fromArea];
        //toArea = [self wrapText:toArea];
        
		//set labels
        [[self patientNameLabel] setText:[NSString stringWithFormat:@"%@", [move patientName]]];
        [[self patientGenderLabel] setText:[NSString stringWithFormat:@"%@", [move patientGender]]];
        [[self patientMedicalRecordNumberLabel] setText:[NSString stringWithFormat:@"%@", [move patientMedicalRecordNumber]]];
        //[[self patientHomeAreaLabel] setText:[NSString stringWithFormat:@"%@", patientHomeArea]];
        [[self patientHomeAreaLabel] setText:[NSString stringWithFormat:@"%@", [move patientHomeArea]]];
        
        //[[self serviceTypeLabel] setText:[NSString stringWithFormat:@"%@", [move serviceType]]];
        [[self transportTypeLabel] setText:[NSString stringWithFormat:@"%@", [move transportType]]];
        
        //[[self fromAreaLabel] setText:[NSString stringWithFormat:@"%@", fromArea]];
        //[[self toAreaLabel] setText:[NSString stringWithFormat:@"%@", toArea]];
        [[self fromAreaLabel] setText:[NSString stringWithFormat:@"%@", [move fromArea]]];
        [[self toAreaLabel] setText:[NSString stringWithFormat:@"%@", [move toArea]]];
        [[self equipmentLabel] setText:[NSString stringWithFormat:@"%@", [move equipment]]];
        //[[self timeNeededLabel] setText:[NSString stringWithFormat:@"Time Needed: %@", [move timeNeeded]]];
        [[self descriptionLabel] setText:[NSString stringWithFormat:@"%@", [move description]]];
        
        CGRect frame = self.patientHomeAreaLabel.frame;
        frame.size.height = 60;
        self.patientHomeAreaLabel.frame = frame;
        
        
        //set the urgency indicator
        NSString *urgency = [move getUrgency];
        
        //check if
        if([urgency isEqualToString:@"Bad"]) { [[self urgencyIndicatorView] setImage:[UIImage imageNamed:@"ui-bad"]]; }
        else if([urgency isEqualToString:@"Caution"]) { [[self urgencyIndicatorView] setImage:[UIImage imageNamed:@"ui-caution"]]; }
        else if([urgency isEqualToString:@"Good"]) { [[self urgencyIndicatorView] setImage:[UIImage imageNamed:@"ui-good"]]; }
        else { [[self urgencyIndicatorView] setImage:[UIImage imageNamed:@"ui-blank"]]; }
    }
    
    //set background
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-pattern.png"]]];
    
    //set view border
    self.containerView.layer.borderWidth = 1.0f;
    self.containerView.layer.borderColor = [[UIColor colorWithRed:0.914 green:0.922 blue:0.922 alpha:1] CGColor];
    
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
    
    self.navigationController.navigationBar.translucent = FALSE;

//    if ([sysVersion floatValue] >= 7.0) {
//        //create button image for navigation bar back button
//        UIImage *navigationBackButtonImage = [[UIImage imageNamed:@"back-button-redux.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//        
//        self.navigationController.navigationBar.backIndicatorImage = navigationBackButtonImage;
//        self.navigationController.navigationBar.backIndicatorTransitionMaskImage = navigationBackButtonImage;
//        [self.navigationItem.leftBarButtonItem setBackgroundImage:navigationBackButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [self.navigationItem.leftBarButtonItem setBackgroundImage:navigationBackButtonImage forState:UIControlEventTouchDown barMetrics:UIBarMetricsDefault];
//    }
    
    //blank out navigation back button title as we have a custom button
    self.navigationItem.backBarButtonItem.title = @" ";

    //get the app delegate
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    int leftOffset = [sysVersion floatValue] >= 7.0 ? -5 : -8;
    
    
    //need to adjust padding on mutliline text fields to get it to align correctly
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(-5,leftOffset,0,0);
    
    //set to labels
    [[self patientHomeAreaLabel] setContentInset:edgeInsets];
    [[self fromAreaLabel] setContentInset:edgeInsets];
    [[self toAreaLabel] setContentInset:edgeInsets];
    [[self descriptionLabel] setContentInset:edgeInsets];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 110, 297, 1)];
    lineView.backgroundColor = [UIColor colorWithHue:0.000 saturation:0.000 brightness:0.937 alpha:1];
    [self.view addSubview:lineView];
    
    
    [self setSwipeGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)]];
     
    [[self swipeGestureRecognizer] setDirection:(UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionUp)];
     
    
    [[self view] addGestureRecognizer:[self swipeGestureRecognizer]];
}
     
- (void)swipeLeft
{
    NSLog(@"LEFT");
}

- (void)viewWillAppear:(BOOL)animated
{
    //check it
    if([move isStarted])
    {
        //set button label
        [startCompleteButton setTitle:@"Complete Move" forState:UIControlStateNormal];
        [startCompleteButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    }
    else
    {
        //set button label
        [startCompleteButton setTitle:@"Start Move" forState:UIControlStateNormal];
        [startCompleteButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    }
    
    //check it
    if([[move isDelayed] isEqualToString:@"true"])
    {
        //set button label
        [addRemoveDelayButton setTitle:@"Remove Delay" forState:UIControlStateNormal];
        [addRemoveDelayButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    }
    else
    {
        //set button label
        [addRemoveDelayButton setTitle:@"Add Delay" forState:UIControlStateNormal];
        [addRemoveDelayButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    }
    
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[navigationController.navigationBar subviews] makeObjectsPerformSelector:@selector(setNeedsDisplay)];
//    });
//}


- (IBAction)startCompleteAction:(id)sender
{
    //check it
    if([move isStarted])
    {
        //complete
        [move close];
        
        //call delegate
        [self.delegate moveDetailViewControllerDidCompleteWorkOrder];
        
        //pop view controller back to moves list
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        //start
        [move start];
        
        //call delegate
        [self.delegate moveDetailViewControllerDidStartWorkOrder];
        
        //switch title
        [startCompleteButton setTitle:@"Complete Move" forState:UIControlStateNormal];
        [startCompleteButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        
        //pop view controller back to moves list
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)addRemoveDelayAction:(id)sender
{
    //check it
    if([[move isDelayed] isEqualToString:@"true"])
    {
        //complete
        [move removeDelay];
        
        //call delegate
        [self.delegate moveDetailViewControllerDidRemoveDelay];
        
        //flip model flag
        [move setIsDelayed:@"false"];
        
        //set button label
        [addRemoveDelayButton setTitle:@"Add Delay" forState:UIControlStateNormal];
        [addRemoveDelayButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    }
    else
    {
        //bounce to seque
        [self performSegueWithIdentifier:@"ShowAddDelay" sender:self];
    }
}

- (IBAction)addNote:(id)sender
{
    //bounce to seque
    [self performSegueWithIdentifier:@"ShowAddNote" sender:self];
}

- (IBAction)cancelMove:(id)sender
{
    //bounce to seque
    [self performSegueWithIdentifier:@"ShowCancelMove" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	//check which segue it is
	if ([segue.identifier isEqualToString:@"ShowAddDelay"])
	{
		//grab the move detail controller
		AddDelayViewController *viewController  = segue.destinationViewController;
		
		//set the detail view controller player to edit which lets it know we're in edit mode instead of add
		viewController.transportWorkOrderId = move.transportWorkOrderId;
        viewController.move = move;
	}
    if ([segue.identifier isEqualToString:@"ShowAddNote"])
	{
		//grab the move detail controller
		AddNoteViewController *viewController  = segue.destinationViewController;
		
		//set the detail view controller player to edit which lets it know we're in edit mode instead of add
		viewController.transportWorkOrderId = move.transportWorkOrderId;
	}
    if ([segue.identifier isEqualToString:@"ShowCancelMove"])
	{
		//grab the move detail controller
		CancelMoveViewController *viewController  = segue.destinationViewController;
		
		//set the detail view controller player to edit which lets it know we're in edit mode instead of add
		viewController.transportWorkOrderId = move.transportWorkOrderId;
	}
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    NSLog(@"Swipe received.");
}

- (NSString *)wrapText:(NSString *)text
{
    if (text.length > 30) {
        NSMutableString * str = [NSMutableString stringWithString:text];
        [str insertString:@"\r" atIndex:29];
        text = [str copy];
    }
    
    return text;
}

@end
