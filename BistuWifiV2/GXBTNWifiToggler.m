//
//  GXBTNWifiToggler.m
//  BistuWifiV2
//
//  Created by Apple on 13-9-11.
//  Copyright (c) 2013年 thephoenixorg. All rights reserved.
//

#import "GXBTNWifiToggler.h"

@interface GXBTNWifiToggler ()

@end

@implementation GXBTNWifiToggler
@synthesize light_start=_light_start;
@synthesize light_end=_light_end;
-(void)Active_Signal:(int)ID
{
    if (ID==-1)
    {
        for (int i=0;i<(__BTNWifiToggler_MaxID__);i++)
            self->active_signal[i]=YES;
    }
    else if ((ID>=0)&&(ID<(__BTNWifiToggler_MaxID__)))
        self->active_signal[ID]=YES;
    [self setNeedsDisplay];
}
-(void)Unactive_Signal:(int)ID
{
    if (ID==-1)
    {
        for (int i=0;i<(__BTNWifiToggler_MaxID__);i++)
            self->active_signal[i]=NO;
    }
    else if ((ID>=0)&&(ID<(__BTNWifiToggler_MaxID__)))
        self->active_signal[ID]=NO;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    float s=rect.size.height/85;
    CGFloat lineWidth_signal=5;
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    UIColor* cmain = [UIColor colorWithRed: 0.5 green: 0.5 blue: 0.5 alpha: 1];
    UIColor* white = [UIColor colorWithRed: 1 green: 0.984 blue: 0.984 alpha: 1];
    UIColor* csignal = [UIColor colorWithRed: 0.679 green: 0.866 blue: 1 alpha: 1];
    UIColor* NoColor = [UIColor colorWithRed: 1 green: 0 blue: 0 alpha: 0];
    UIColor* clight = [UIColor colorWithRed: 0 green: 0.59 blue: 0.886 alpha: 1];
    
    //// Shadow Declarations
    UIColor* smain_inner = white;
    CGSize smain_innerOffset = CGSizeMake(s*0.1, s*(-0.1));
    CGFloat smain_innerBlurRadius = s*5;
    CGFloat xrectinfo[6][4]={
        s*0.5, s*0.5, s*84.5, s*84.5,
        s*25, s*42.5, s*35, s*35,
        s*20, s*37.5, s*45, s*45,
        s*15, s*32.5, s*55, s*55,
        s*10, s*27.5, s*65, s*65,
        s*5, s*22.5, s*75, s*75
    };
    //// main Drawing
    UIBezierPath* mainPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(xrectinfo[0][0],xrectinfo[0][1],xrectinfo[0][2],xrectinfo[0][3])];
    [fillColor setFill];
    [mainPath fill];

    for(int i=1;i<=5;i++)
    {
        CGRect x5Rect = CGRectMake(xrectinfo[i][0],xrectinfo[i][1],xrectinfo[i][2],xrectinfo[i][3]);
        UIBezierPath* x5Path = [UIBezierPath bezierPath];
        [x5Path addArcWithCenter: CGPointMake(CGRectGetMidX(x5Rect), CGRectGetMidY(x5Rect)) radius: CGRectGetWidth(x5Rect) / 2 startAngle: 210 * M_PI/180 endAngle: 330 * M_PI/180 clockwise: YES];
        if (active_signal[i])
        {
            //// x5 Drawing
            [csignal setStroke];
            x5Path.lineWidth = lineWidth_signal;
            [x5Path stroke];
        }
        else
        {
            //// x5 Drawing
            [cmain setStroke];
            x5Path.lineWidth = lineWidth_signal;
            [x5Path stroke];
        }
    }
    //draw background
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(xrectinfo[0][0],xrectinfo[0][1],xrectinfo[0][2],xrectinfo[0][3])];
    [NoColor setFill];
    [rectanglePath fill];
    
    if (active_signal[0])
    {
        
        //// x0 Drawing
        UIBezierPath* x0Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(s*35, s*52.5, s*15, s*15)];
        [cmain setFill];
        [x0Path fill];
        
        ////// x0 Inner Shadow
        CGRect x0BorderRect = CGRectInset([x0Path bounds], -smain_innerBlurRadius, -smain_innerBlurRadius);
        x0BorderRect = CGRectOffset(x0BorderRect, -smain_innerOffset.width, -smain_innerOffset.height);
        x0BorderRect = CGRectInset(CGRectUnion(x0BorderRect, [x0Path bounds]), s*-1, s*-1);
        
        UIBezierPath* x0NegativePath = [UIBezierPath bezierPathWithRect: x0BorderRect];
        [x0NegativePath appendPath: x0Path];
        x0NegativePath.usesEvenOddFillRule = YES;
        
        CGContextSaveGState(context);
        {
            CGFloat xOffset = smain_innerOffset.width + round(x0BorderRect.size.width);
            CGFloat yOffset = smain_innerOffset.height;
            CGContextSetShadowWithColor(context,
                                        CGSizeMake(xOffset + copysign(s*0.1, xOffset), yOffset + copysign(s*0.1, yOffset)),
                                        smain_innerBlurRadius,
                                        smain_inner.CGColor);
            
            [x0Path addClip];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(x0BorderRect.size.width), 0);
            [x0NegativePath applyTransform: transform];
            [[UIColor grayColor] setFill];
            [x0NegativePath fill];
        }
        CGContextRestoreGState(context);
    }
    
    CGRect lightRect = CGRectMake(s*1, s*1, s*83.5, s*83.5);
    UIBezierPath* lightPath = [UIBezierPath bezierPath];
    [lightPath addArcWithCenter: CGPointMake(CGRectGetMidX(lightRect), CGRectGetMidY(lightRect)) radius: CGRectGetWidth(lightRect) / 2 startAngle: _light_start * M_PI/180 endAngle: _light_end * M_PI/180 clockwise: YES];
    //light
    [clight setStroke];
    lightPath.lineWidth = s*2;
    [lightPath stroke];
  
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        [self dwMakeBottomRoundCornerWithRadius:3.0];
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius = 50;
    }
    return self;
}
@end
