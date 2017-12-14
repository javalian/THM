
#import "ViewMessageViewController.h"

@implementation ViewMessageViewController

@synthesize message;

@synthesize fromLabel;
@synthesize dateLabel;
@synthesize messageLabel;

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
    //call super
    [super viewDidLoad];
    
    //set background
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-pattern.png"]]];
    
    //set data
    if([self message] != nil)
    {
        [[self fromLabel] setText:[NSString stringWithFormat:@"Sent From: %@", [[self message] sentByName]]];
        [[self dateLabel] setText:[NSString stringWithFormat:@"Sent at %@", [[self message] created]]];
        [[self messageLabel] setText:[[self message] messageText]];
    }
    
    self.navigationController.navigationBar.translucent = FALSE;
}

@end