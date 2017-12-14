
#import "THMButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation THMButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        //set backgrounds
        [self setBackgroundImage:[UIImage imageNamed:@"button-background.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"button-background-pressed.png"] forState:UIControlEventTouchDown];
        
        //set forecolor
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        //set border and corner rounding
        [[self layer] setMasksToBounds:YES];
        [[self layer] setCornerRadius:8.0];
        [[self layer] setBorderWidth:1.0];
        [[self layer] setBorderColor:[[UIColor colorWithRed:0.047 green:0.380 blue:0.541 alpha:1] CGColor]];
    }
    return self;
}

@end
