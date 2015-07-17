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
#import "A1_SignupBoard_iPhone.h"
#import "FormCell.h"


#pragma mark -


@interface A1_SignupCell_iPhone()
{
    
}

@property( retain, nonatomic ) NSTimer* timer;
@property( nonatomic ) int count;

@end


@implementation A1_SignupCell_iPhone


SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUIImageView, background )
DEF_OUTLET( BeeUITextField, input )
DEF_OUTLET( BeeUIButton, codeButton)

DEF_SIGNAL( MOBILE_REGISTER )

- (void)load
{
}

- (void)unload
{
    if(self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    [self unobserveNotification:A1_SignupBoard_iPhone.TIME_CLICK];
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
        if (self.codeButton.visible)
        {
            [self unobserveNotification:A1_SignupBoard_iPhone.TIME_CLICK];
            [self observeNotification:A1_SignupBoard_iPhone.TIME_CLICK];
        }
        
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

//-(void)handleUISignal:(BeeUISignal *)signal
//{
//    count = 10;
//}

ON_SIGNAL2(codeButton, signal)
{
    if(self.timer != nil && [self.timer isValid])
    {
        //counting now
        [[BeeUIApplication sharedInstance] presentMessageTips:[NSString stringWithFormat:__TEXT(@"wait_code"), self.count]];
        return ;
    }
    [self sendUISignal:self.MOBILE_REGISTER];
}

ON_NOTIFICATION3(A1_SignupBoard_iPhone, TIME_CLICK, notification)
{
    self.count = 60;
    
    [self.codeButton setTitle:[NSString stringWithFormat:__TEXT(@"wait_code"), self.count--]];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(timeClick)
                                           userInfo:nil
                                            repeats:YES];
}

-(void)timeClick
{
    [self.codeButton setTitle:[NSString stringWithFormat:__TEXT(@"wait_code"), self.count--]];
    
    if(self.count <= 0)
    {
        if([self.timer isValid])
        {
            [self.timer invalidate];
            self.timer = nil;
            [self.codeButton setTitle:__TEXT(@"get_code")];
        }
    }
}

@end
