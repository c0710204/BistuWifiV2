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
-(void)Active_Signal:(int)ID
{
    if (ID==-1)
    {
        for (int i=0;i<6;i++)
            self->active_signal[i]=YES;
    }
    else if ((ID>=0)&&(ID<6))
        self->active_signal[ID]=YES;
    [self setNeedsDisplay];
}
-(void)Unactive_Signal:(int)ID
{
    if (ID==-1)
    {
        for (int i=0;i<6;i++)
            self->active_signal[i]=NO;
    }
    else if ((ID>=0)&&(ID<6))
        self->active_signal[ID]=NO;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    for (int i=0;i<6;i++) printf("sign=\n%s\n%s\n%s\n%s\n%s\n%s\n"
                                 ,self->active_signal[0]?"YES":"NO"
                                 ,self->active_signal[1]?"YES":"NO"
                                 ,self->active_signal[2]?"YES":"NO"
                                 ,self->active_signal[3]?"YES":"NO"
                                 ,self->active_signal[4]?"YES":"NO"
                                 ,self->active_signal[5]?"YES":"NO"
                                 );
    if ((selfRECT.origin.x!=rect.origin.x)||
        (selfRECT.origin.y!=rect.origin.y)||
        (selfRECT.size.height!=rect.size.height)||
        (selfRECT.size.width!=rect.size.width))
        selfRECT=rect;
    NSLog(@"\n******************\nrect=\nx=%f\ny=%f\nw=%f\nh=%f\n\n\n****************\n",rect.origin.x
        ,rect.origin.y
          ,rect.size.width,rect.size.height);
    NSLog(@"\n******************\nSEFLrect=\nx=%f\ny=%f\nw=%f\nh=%f\n\n\n****************\n",selfRECT.origin.x
          ,selfRECT.origin.y
          ,selfRECT.size.width,selfRECT.size.height);
    float s=rect.size.height/85;
    CGFloat lineWidth_signal=5;
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    UIColor* cmain = [UIColor colorWithRed: 0.5 green: 0.5 blue: 0.5 alpha: 1];
    UIColor* white = [UIColor colorWithRed: 1 green: 0.984 blue: 0.984 alpha: 1];
    UIColor* csignal = [UIColor colorWithRed: 0.679 green: 0.866 blue: 1 alpha: 1];
    
    //// Shadow Declarations
    UIColor* smain_inner = white;
    CGSize smain_innerOffset = CGSizeMake(s*0.1, s*(-0.1));
    CGFloat smain_innerBlurRadius = s*5;
    
    //// main Drawing
    UIBezierPath* mainPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0.5, 0.5, s*85, s*85)];
    [fillColor setFill];
    [mainPath fill];
    CGFloat xrectinfo[6][4]={
        0,0,0,0,
        s*25, s*42.5, s*35, s*35,
        s*20, s*37.5, s*45, s*45,
        s*15, s*32.5, s*55, s*55,
        s*10, s*27.5, s*65, s*65,
        s*5, s*22.5, s*75, s*75
    };
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
