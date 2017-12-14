
#import "AddDelayViewController.h"
#import "AppDelegate.h"
#import "DelayReason.h"

@implementation AddDelayViewController

@synthesize transportWorkOrderId;
@synthesize delayReasons;
@synthesize picker;

@synthesize move;

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
    
    //make request
	NSArray *results = [[AppDelegate sharedRestRequest] performGet:@"/transportworkorderdelay/getreasons" error:nil];
    
    //create moves array
	[self setDelayReasons:[[NSMutableArray alloc] initWithCapacity:20]];
    
    //loop and create models
    for(long counter = 0; counter < [results count]; counter++)
    {
        //get dictionary for item
        NSDictionary *dictionary = [results objectAtIndex:counter];
        
        //create item
        DelayReason *reason = [[DelayReason alloc] initWithDictionary:dictionary];
        
        //add to array
        [[self delayReasons] addObject:reason];
    }
    
    //set background
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-pattern.png"]]];
    
    //blank out navigation back button title as we have a custom button
    self.navigationItem.backBarButtonItem.title = @" ";
    
    self.navigationController.navigationBar.translucent = FALSE;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[self delayReasons] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[[self delayReasons] objectAtIndex:row] description];
}

- (IBAction)addDelayAction:(id)sender
{
    //get reason
    DelayReason *reason = [[self delayReasons] objectAtIndex:[picker selectedRowInComponent:0]];
    
    //make request
	[[AppDelegate sharedRestRequest] performGet:[NSString stringWithFormat:@"/transportworkorderdelay/createdelay/%@/%@", [self transportWorkOrderId], [reason transportDelayReasonId]] error:nil];

    //set model
    [move setIsDelayed:@"true"];
    
    //go back to detail
    [self.navigationController popViewControllerAnimated:YES];
}

@end
