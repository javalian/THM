
#import <AudioToolbox/AudioToolbox.h>
#import "AppDelegate.h"
#import "MyMovesViewController.h"
#import "MyMovesCell.h"
#import "MoveDetailViewController.h"
#import "MBProgressHUD.h"

@implementation MyMovesViewController

@synthesize viewedMoves;
@synthesize isEditing;
@synthesize progressIndicator;

- (void)viewDidLoad
{
    //call super
	[super viewDidLoad];
	
    //listen to notification center for app delegate to signal data has changed
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurrentMovesChanged:) name:@"currentMovesChanged" object:nil];
    
    //get viewed messages
    NSArray *savedViewedMovesArray = [[NSUserDefaults standardUserDefaults] objectForKey:[self getPersistentStoreKey]];
    
	//check if we have it
    if(!savedViewedMovesArray)
    {
        [self setViewedMoves:[[NSMutableArray alloc] initWithCapacity:15]];
    }
    else
    {
        [self setViewedMoves:[[NSMutableArray alloc] initWithArray:savedViewedMovesArray]];
    }
	
    //init var
    self.isEditing = FALSE;
    
    //blank out navigation back button title as we have a custom button
    self.navigationItem.backBarButtonItem.title = @" ";
    self.navigationController.navigationBar.translucent = FALSE;
    
    [[self tableView] setSeparatorColor:[UIColor clearColor]];
    [[self tableView] setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-pattern.png"]]];
    
    //we are authenticated and this first tab has loaded so let's trigger the app delegate to refresh add data arrays which will
    //initially populate all the appropriate tabs with data
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) initializeAllTabs];
    
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
    UIImage *refreshImage;
    
    if ([sysVersion floatValue] >= 7.0) {
        //create add image
        refreshImage = [[UIImage imageNamed:@"refresh-button-redux.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    else {
        //create add image
        refreshImage = [[UIImage imageNamed:@"refresh-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    //set bar button item background
    [self.navigationItem.leftBarButtonItem setBackgroundImage:refreshImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.navigationItem.leftBarButtonItem setBackgroundImage:refreshImage forState:UIControlEventTouchDown barMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated
{
    //call app delegate to refresh data
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] refreshMoves];
}

- (void)onCurrentMovesChanged:(NSNotification *)notification
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
    int currentCount = [[[[[[self tabBarController] tabBar] items] objectAtIndex:0] badgeValue] integerValue];
    
    //loop current items
    for (Move *move in [AppDelegate sharedCurrentMoves])
    {
        //check all items
        if ([[self viewedMoves] containsObject:[move transportWorkOrderId]])
        {
            //already seen
        }
        else
        {
            //increment counter
            newItemCount++;
        }
    }
    
    //show badge
    if(newItemCount > 0)
    {
        //show badge
        [[[[[self tabBarController] tabBar] items] objectAtIndex:0] setBadgeValue:[NSString stringWithFormat:@"%d", newItemCount]];
        
        //see if we have to play sound
        if(newItemCount > currentCount)
        {
            //play sound
            AudioServicesPlaySystemSound(1007);
        }
    }
    else
    {
        [[[[[self tabBarController] tabBar] items] objectAtIndex:0] setBadgeValue:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section)
    {
        case 0:
            return [[AppDelegate sharedCurrentMoves] count];
            break;
        case 1:
            return 0;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView titleForHeaderInSection:section] != nil) {
        return 40;
    }
    else {
        // If no section header title, no section header needed
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 6, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithHue:(136.0/360.0)  // Slightly bluish green
                                 saturation:1.0
                                 brightness:0.60
                                      alpha:1.0];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view addSubview:label];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//get custom cell from custom class
	MyMovesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyMovesCell"];
    
	//get the move
    Move *move = [[AppDelegate sharedCurrentMoves] objectAtIndex:[indexPath row]];
    
    //see if move has been viewed - set the viewed indicator accordingly
    if([[self viewedMoves] containsObject:[move transportWorkOrderId]]) { [[cell viewedIndicatorImageView] setImage:[UIImage imageNamed:@"ui-blank"]]; }
    else { [[cell viewedIndicatorImageView] setImage:[UIImage imageNamed:@"ui-unviewed"]]; }
	
	//set the cell labels
    [[cell patientNameLabel] setText:[NSString stringWithFormat:@"%@", [move patientName]]];
    [[cell fromAreaLabel] setText:[NSString stringWithFormat:@"%@", [move fromArea]]];
    [[cell toAreaLabel] setText:[NSString stringWithFormat:@"%@", [move toArea]]];
    
    //set the cell icons
    if([move hasBeenStarted]) { [[cell startedImageView] setImage:[UIImage imageNamed:@"started-selected"]]; }
    else { [[cell startedImageView] setImage:[UIImage imageNamed:@"started"]]; }
    
    if([move hasBeenDelayed]) { [[cell delayedImageView] setImage:[UIImage imageNamed:@"delay-selected"]]; }
    else { [[cell delayedImageView] setImage:[UIImage imageNamed:@"delay"]]; }
    
    if([move hasEquiment]) { [[cell equipmentImageView] setImage:[UIImage imageNamed:@"equipment-selected"]]; }
    else { [[cell equipmentImageView] setImage:[UIImage imageNamed:@"equipment"]]; }
    
    if([move hasAnotherTransporter]) { [[cell transporterImageView] setImage:[UIImage imageNamed:@"transporter-selected"]]; }
    else { [[cell transporterImageView] setImage:[UIImage imageNamed:@"transporter"]]; }
    
    if([move hasNotes]) { [[cell notesImageView] setImage:[UIImage imageNamed:@"notes-selected"]]; }
    else { [[cell notesImageView] setImage:[UIImage imageNamed:@"notes"]]; }
    
    //set the urgency indicator
    NSString *urgency = [move getUrgency];
    
    //check if
    if([urgency isEqualToString:@"Bad"]) { [[cell urgencyIndicatorView] setImage:[UIImage imageNamed:@"ui-bad"]]; }
    else if([urgency isEqualToString:@"Caution"]) { [[cell urgencyIndicatorView] setImage:[UIImage imageNamed:@"ui-caution"]]; }
    else if([urgency isEqualToString:@"Good"]) { [[cell urgencyIndicatorView] setImage:[UIImage imageNamed:@"ui-good"]]; }
    else { [[cell urgencyIndicatorView] setImage:[UIImage imageNamed:@"ui-blank"]]; }
    
    //create view for cell background
    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    
    //set properties
    [backgroundView setOpaque:YES];
    [backgroundView setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background-pattern.png"]]];
    
    //set cell background
    [cell setBackgroundView:backgroundView];
    
	//send it back
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	//check which segue it is
	if ([segue.identifier isEqualToString:@"ShowMoveDetail"])
	{
		//grab the move detail controller
		MoveDetailViewController *viewController  = segue.destinationViewController;
		
		//set ourselves to be the delegate for the detail view controller
		//viewController.delegate = self;
		
		//get index path for touched cell
		NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
		
		//get the move out of the array using the index path row as pointer
		Move *move = [[AppDelegate sharedCurrentMoves] objectAtIndex:indexPath.row];
		
		//set the detail view controller player to edit which lets it know we're in edit mode instead of add
		viewController.move = move;
        
        //see if the move is already in viewed items
        if([[self viewedMoves] containsObject:[move transportWorkOrderId]])
        {
            //they've already viewed this item so no need to do anything
        }
        else
        {
            //get current badge count
            NSString *badgeCount = [[[[[self tabBarController] tabBar] items] objectAtIndex:0] badgeValue];
            
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
            [[[[[self tabBarController] tabBar] items] objectAtIndex:0] setBadgeValue:badgeCount];
        }
        
        //add this item to viewed moves
        [[self viewedMoves] addObject:[move transportWorkOrderId]];
        
        //save viewed messages
        [[NSUserDefaults standardUserDefaults] setObject:[self viewedMoves] forKey:[self getPersistentStoreKey]];
        [[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105.00;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	//check editing style for delete only
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		//get the move
        Move *move = [[AppDelegate sharedCurrentMoves] objectAtIndex:[indexPath row]];
        
        //get the time started
        NSString *timeStarted = [move timeStarted];
        
        //check it
        if([timeStarted length] == 0)
        {
            [move start];
        }
        else
        {
            [move close];
        }
        
        //add to viewed
        [[self viewedMoves]  addObject:[move transportWorkOrderId]];
        
        //update bade
        [self updateBadge];
        
        //reload data
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] refreshMoves];
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //get the move
    Move *move = [[AppDelegate sharedCurrentMoves] objectAtIndex:[indexPath row]];
    
    //get the time started
    NSString *timeStarted = [move timeStarted];
    
    //check it
    if([timeStarted length] == 0)
    {
        return @"Start Move";
    }
    else
    {
        return @"Complete Move";
    }
}

- (void)moveDetailViewControllerDidStartWorkOrder
{

}

- (void)moveDetailViewControllerDidCompleteWorkOrder
{

}

- (void)moveDetailViewControllerDidAddDelay
{
    
}

- (void)moveDetailViewControllerDidRemoveDelay
{
    
}

- (NSString *)getPersistentStoreKey
{
    return [NSString stringWithFormat:@"%@%@", @"VIEWED_MOVES_", [[AppDelegate sharedAuthenticatedTransporter] transporterCode]];
}

@end
