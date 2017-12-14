
#import <AudioToolbox/AudioToolbox.h>
#import "MyMessagesViewController.h"
#import "MyMessagesCell.h"
#import "Message.h"
#import "AppDelegate.h"
#import "ViewMessageViewController.h"

@implementation MyMessagesViewController

@synthesize viewedMessages;
@synthesize isEditing;
@synthesize progressIndicator;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        //listen to notification center for app delegate to signal data has changed
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurrentMessagesChanged:) name:@"currentMessagesChanged" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    //call super
    [super viewDidLoad];
    
    //get viewed messages
    NSArray *savedViewedMessagesArray = [[NSUserDefaults standardUserDefaults] objectForKey:[self getPersistentStoreKey]];
    
    //check if we have it
    if(!savedViewedMessagesArray)
    {
        [self setViewedMessages:[[NSMutableArray alloc] initWithCapacity:15]];
    }
    else
    {
        [self setViewedMessages:[[NSMutableArray alloc] initWithArray:savedViewedMessagesArray]];
    }
	
    self.navigationController.navigationBar.translucent = FALSE;
    
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
    UIImage *addImage;
    UIImage *refreshImage;
    
    if ([sysVersion floatValue] >= 7.0) {
        //create add image
        addImage = [[UIImage imageNamed:@"add-button-redux2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        //create add image
        refreshImage = [[UIImage imageNamed:@"refresh-button-redux.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    else {
        //create add image
        addImage = [[UIImage imageNamed:@"add-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        //create add image
        refreshImage = [[UIImage imageNamed:@"refresh-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    
    //set bar button item background
    [self.navigationItem.rightBarButtonItem setBackgroundImage:addImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationItem.rightBarButtonItem setBackgroundImage:addImage forState:UIControlEventTouchDown barMetrics:UIBarMetricsDefault];
    
    //set bar button item background
    [self.navigationItem.leftBarButtonItem setBackgroundImage:refreshImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationItem.leftBarButtonItem setBackgroundImage:refreshImage forState:UIControlEventTouchDown barMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated
{
    //refresh data
    [self refreshData];
}

- (void)onCurrentMessagesChanged:(NSNotification *)notification
{
    //refresh data
    [self refreshData];
}

- (void)refreshManually:(id)sender
{
    //create hud progress indicator
    [self setProgressIndicator:[[MBProgressHUD alloc] initWithView:self.navigationController.view]];
    
    //add as subview
	[self.navigationController.view addSubview:[self progressIndicator]];
	
	//set properties
	[[self progressIndicator] setMode:MBProgressHUDModeIndeterminate];
	
	// myProgressTask uses the HUD instance to update progress
	[[self progressIndicator] showWhileExecuting:@selector(refreshAllTabsWithSleep) onTarget:[[UIApplication sharedApplication] delegate] withObject:nil animated:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
	//remove hud from screen and kill it
	[[self progressIndicator] removeFromSuperview];
	[self setProgressIndicator:nil];
}

- (void)refreshDataWithSleep
{
    //check flag
    if(self.isEditing) { return; }
    
    //hacky but need to sleep here so progress indicators are useful and let user know
    //something is actually happening when the app is refreshed for data
    [NSThread sleepForTimeInterval:.75];
    
    //call refresh
    [self refreshData];
}

- (void)refreshData
{
    //check flag
    if(self.isEditing) { return; }
    
    //reload the table
    [[self tableView] reloadData];
    
    //update tab badge
    [self updateBadge];
}

- (void)updateBadge
{
    //set counter for badge
    int newItemCount = 0;
    
    //set current item count
    int currentCount = [[[[[[self tabBarController] tabBar] items] objectAtIndex:1] badgeValue] integerValue];
    
    //loop current items
    for (Message *message in [AppDelegate sharedCurrentMessages])
    {
        //check all items
        if ([[self viewedMessages] containsObject:[message messageId]])
        {
            //already seen
        }
        else
        {
            //check if message was sent by authenticated user
            if([[message sentById] isEqualToNumber:[[AppDelegate sharedAuthenticatedTransporter] transporterId]])
            {
                //don't increment counter for items sent by person
            }
            else
            {
                //increment counter
                newItemCount++;
            }
        }
    }
    
    //show badge
    if(newItemCount > 0)
    {
        //show badge
        [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%d", newItemCount]];
        
        //see if we have to play sound
        if(newItemCount > currentCount)
        {
            //play sound
            AudioServicesPlaySystemSound(1007);
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[AppDelegate sharedCurrentMessages] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //get custom cell from custom class
	MyMessagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyMessagesCell"];
    
	//get the message
    Message *message = [[AppDelegate sharedCurrentMessages] objectAtIndex:[indexPath row]];
	
	//set the cell properties
    [[cell sentFromLabel] setText:[NSString stringWithFormat:@"Sent From: %@", [message sentByName]]];
    [[cell sentToLabel] setText:[NSString stringWithFormat:@"Sent To: %@", [message sentToName]]];
    [[cell messageLabel] setText:[NSString stringWithFormat:@"%@", [message messageText]]];
    
	//send it back
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.00;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	//check which segue it is
	if ([segue.identifier isEqualToString:@"ShowMessageDetail"])
	{
		//grab the move detail controller
		ViewMessageViewController *viewController  = segue.destinationViewController;
		
		//set ourselves to be the delegate for the detail view controller
		//viewController.delegate = self;
		
		//get index path for touched cell
		NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
		
		//get the move out of the array using the index path row as pointer
		Message *message = [[AppDelegate sharedCurrentMessages] objectAtIndex:indexPath.row];
		
		//set the detail view controller player to edit which lets it know we're in edit mode instead of add
		viewController.message = message;
        
        //get the app delegate
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //see if the move is already in viewed items
        if([[self viewedMessages] containsObject:[message messageId]])
        {
            //they've already viewed this item so no need to do anything
        }
        else
        {
            if([[message sentById] isEqualToNumber:[[appDelegate authenticatedTransporter] transporterId]])
            {
                //don't increment counter for items sent by person
            }
            else
            {
                //get current badge count
                NSString *badgeCount = [[[[[self tabBarController] tabBar] items] objectAtIndex:1] badgeValue];
                
                //see if one
                if([badgeCount isEqualToString:@"1"])
                {
                    //set to empty string to clear out
                    badgeCount = nil;
                }
                else
                {
                    //decrement by one
                    badgeCount = [NSString stringWithFormat:@"%i", [badgeCount intValue] - 1];
                }
                
                //decrement badge counter
                [[[[[self tabBarController] tabBar] items] objectAtIndex:1] setBadgeValue:badgeCount];
            }
        }
        
        //add this item to viewed moves
        [[self viewedMessages] addObject:[message messageId]];
        
        //save viewed messages
        [[NSUserDefaults standardUserDefaults] setObject:[self viewedMessages] forKey:[self getPersistentStoreKey]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	//check editing style for delete only
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		//segue to reply message
        [self performSegueWithIdentifier:@"ShowNewMessage" sender:self];
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Reply";
}

- (NSString *)getPersistentStoreKey
{
    return [NSString stringWithFormat:@"%@%@", @"VIEWED_MSGS_", [[AppDelegate sharedAuthenticatedTransporter] transporterCode]];
}

@end
