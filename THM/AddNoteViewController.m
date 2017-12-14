
#import "AddNoteViewController.h"
#import "AppDelegate.h"
#import "TransportWorkOrderNoteModel.h"
#import <QuartzCore/QuartzCore.h>

@implementation AddNoteViewController

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
    [super viewDidLoad];
    
    //set background
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-pattern.png"]]];
    
    //blank out navigation back button title as we have a custom button
    self.navigationItem.backBarButtonItem.title = @" ";
    
    self.navigationController.navigationBar.translucent = FALSE;
}

- (void)viewDidAppear:(BOOL)animated
{
    //set focus
    [[self textView] becomeFirstResponder];
}

- (IBAction)addNote:(id)sender
{
    //get the app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //create model
    TransportWorkOrderNoteModel *model = [[TransportWorkOrderNoteModel alloc] init];
    
    //set properties
    [model setTransportWorkOrderId:[self transportWorkOrderId]];
    [model setTransporterId:[[appDelegate authenticatedTransporter] transporterId]];
    [model setNoteMessage:[[self textView] text]];
    
    //create dictionary
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[model transportWorkOrderId], @"transportWorkOrderId", [model transporterId], @"transporterId", [model noteMessage], @"noteMessage", nil];
    
    //make post
    [[AppDelegate sharedRestRequest] performPost:@"/transportworkorder/addnote" jsonData:dictionary error:nil];
    
    //pop this view controller
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }
    
    [[self textView] resignFirstResponder];
    return NO;
}

@end
