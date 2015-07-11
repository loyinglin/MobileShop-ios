//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "CommonPullLoader.h"

#pragma mark -

@implementation CommonPullLoader

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_OUTLET( BeeUILabel,					state )
DEF_OUTLET( BeeUILabel,					date )
DEF_OUTLET( BeeUIImageView,				arrow )
DEF_OUTLET( BeeUIActivityIndicatorView,	indicator )

- (void)load
{
	self.alpha = 0.0f;
	self.arrow.hidden = NO;
	self.indicator.hidden = YES;
	self.status.data = __TEXT(@"tips_pull_refresh");
	self.date.data = [NSString stringWithFormat:@"%@%@", __TEXT(@"tips_last_update"), [[NSDate date] stringWithDateFormat:@"MM/dd/yyyy"]];
}

- (void)unload
{
}

ON_SIGNAL3( BeeUIPullLoader, STATE_CHANGED, signal )
{
	if ( self.animated )
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDuration:0.25f];
  //      NSLog(@"animated");
	}
	
	if ( self.pulling )
	{
//        NSLog(@"pulling");
		self.alpha = 1.0f;

		self.arrow.hidden = NO;
		self.arrow.transform = CGAffineTransformRotate( CGAffineTransformIdentity, (M_PI / 360.0f) * -359.0f );
		self.indicator.hidden = YES;
		self.status.data = __TEXT(@"tips_release_refresh");
		self.date.data = [NSString stringWithFormat:@"%@%@", __TEXT(@"tips_last_update"), [[NSDate date] stringWithDateFormat:@"MM/dd/yyyy"]];
	}
	else if ( self.loading )
	{
//        NSLog(@"loading");
		self.alpha = 1.0f;
		
		self.indicator.hidden = NO;
		self.indicator.animating = YES;
		
		self.arrow.hidden = YES;
		self.status.data = __TEXT(@"tips_loading");
		self.date.data = [NSString stringWithFormat:@"%@%@", __TEXT(@"tips_last_update"), [[NSDate date] stringWithDateFormat:@"MM/dd/yyyy"]];
	}
	else
	{
//        NSLog(@"end");
		self.alpha = 0.0f;

		self.arrow.hidden = NO;
		self.arrow.transform = CGAffineTransformIdentity;
		self.indicator.hidden = YES;
		self.status.data = __TEXT(@"tips_pull_refresh");
		self.date.data = [NSString stringWithFormat:@"%@%@", __TEXT(@"tips_last_update"), [[NSDate date] stringWithDateFormat:@"MM/dd/yyyy"]];
	}
	
	if ( self.animated )
	{
		[UIView commitAnimations];
	}
}

@end
