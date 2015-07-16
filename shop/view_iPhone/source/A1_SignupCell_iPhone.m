//
//                       __
//                      /\ \   _
//    ____    ____   ___\ \ \_/ \           _____    ___     ___
//   / _  \  / __ \ / __ \ \    <     __   /\__  \  / __ \  / __ \
//  /\ \_\ \/\  __//\  __/\ \ \\ \   /\_\  \/_/  / /\ \_\ \/\ \_\ \
//  \ \____ \ \____\ \____\\ \_\\_\  \/_/   /\____\\ \____/\ \____/
//   \/____\ \/____/\/____/ \/_//_/         \/____/ \/___/  \/___/
//     /\____/
//     \/___/
//
//	Powered by BeeFramework
//

#import "A1_SignupCell_iPhone.h"
#import "FormCell.h"


#pragma mark -

@implementation A1_SignupCell_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIImageView, background )
DEF_OUTLET( BeeUITextField, input )
DEF_OUTLET( BeeUIButton, codeButton)

- (void)load
{
}

- (void)unload
{
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

- (void)dataDidChanged
{
    if ( self.data )
    {
        FormData * formData = self.data;
        self.input.placeholder = formData.placeholder;
        self.input.secureTextEntry = formData.isSecure;
        self.input.returnKeyType = formData.returnKeyType;
        self.input.keyboardType = formData.keyboardType;
        
        [self.codeButton.titleFont description];
    //    self.codeButton.position
        
        if ( formData.text )
        {
            self.input.text = formData.text;
        }
        
        self.codeButton.visible = [formData.tagString isEqualToString: @"check_code"];
        
        switch ( formData.scrollIndex )
        {
            case UIScrollViewIndexFirst:
                self.background.image = [UIImage imageNamed:@"cell_bg_header.png"];
                break;
            case UIScrollViewIndexLast:
                self.background.image = [UIImage imageNamed:@"cell_bg_footer.png"];
                break;
            case UIScrollViewIndexDefault:
            default:
                self.background.image = [UIImage imageNamed:@"cell_bg_content.png"];
                break;
        }
    }
}

NSTimer* timer;
int count = 60;

ON_SIGNAL2(codeButton, signal)
{
    if([timer isValid])
    {
        //counting now
        return ;
    }
    count = 60;
    
    [self.codeButton setTitle:[NSString stringWithFormat:__TEXT(@"wait_code"), count--]];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeClick) userInfo:nil repeats:YES];
}

-(void)timeClick
{
    [self.codeButton setTitle:[NSString stringWithFormat:__TEXT(@"wait_code"), count--]];
    
    if(count <= 0)
    {
        if([timer isValid])
        {
            [timer invalidate];
            timer = nil;
            [self.codeButton setTitle:__TEXT(@"get_code")];
        }
    }
}

@end
