
#import "THMBorderedView.h"
#import <QuartzCore/QuartzCore.h>

@implementation THMBorderedView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    //call super
    self = [super initWithCoder:aDecoder];
    
    //validate
    if (self)
    {
        //set borders / backcolors
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [[UIColor colorWithRed:0.914 green:0.922 blue:0.922 alpha:1] CGColor];
        
        //set background color
        self.backgroundColor = [UIColor whiteColor];
    }
    
    //send back self
    return self;
}

@end
