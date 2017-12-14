
#import "THMTextView.h"
#import <QuartzCore/QuartzCore.h>

@implementation THMTextView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        //set field borders / backcolors
        self.layer.borderWidth = 1.0f;
        
        if(self.isEditable)
        {
            self.layer.borderColor = [[UIColor colorWithRed:0.765 green:0.812 blue:0.129 alpha:1] CGColor];
        }
        else
        {
            self.layer.borderColor = [[UIColor colorWithRed:0.914 green:0.922 blue:0.922 alpha:1] CGColor];
        }
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

//placeholder position padding
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds , 10 , 10 );
}

//text position padding
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds , 10 , 10 );
}

@end
