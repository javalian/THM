
#import "CancelMoveViewController.h"
#import "AppDelegate.h"
#import "CancelModel.h"

@implementation CancelMoveViewController

@synthesize transportWorkOrderId;
@synthesize textView;

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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        //listen to notification center for app delegate to signal data has changed
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkStatusChangedToNotAvailable:) name:@"networkStatusChangedToNotAvailable" object:nil];
    }
    return self;
}

- (void)onNetworkStatusChangedToNotAvailable:(NSNotification *)notification
{
    //hide keyboard
    [[self view] endEditing:TRUE];
}

- (void)viewDidLoad
{
    //call super
    [super viewDidLoad];
    
    //set background
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-pattern.png"]]];
    
    self.navigationController.navigationBar.translucent = FALSE;
}

- (void)viewDidAppear:(BOOL)animated
{
    //set focus
    [[self textView] becomeFirstResponder];
}

- (void)cancelMove:(id)sender
{
    //create model
    CancelModel *model = [[CancelModel alloc] init];
    
    //set properties
    [model setTransportWorkOrderId:[self transportWorkOrderId]];
    [model setReason:[[self textView] text]];
    
    //create dictionary
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[model transportWorkOrderId], @"transportWorkOrderId", [model reason], @"reason", nil];
    
    //make post
    [[AppDelegate sharedRestRequest] performPost:@"/transportworkorder/cancel" jsonData:dictionary error:nil];
    
    //call app delegate to refresh
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] refreshMoves];
    
    //pop this view controller
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //see if we want to return by checking range
    if([text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound) { return YES; }
    
    //resign view as first responder
    [[self textView] resignFirstResponder];
    
    //send back no
    return NO;
}

@end
