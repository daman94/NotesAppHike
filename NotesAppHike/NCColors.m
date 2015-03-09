//
//  NCColors.m
//  NotesAppHike
//
//  Created by Karan Kumar on 06/08/14.
//  Copyright (c) 2014 KaranKumar. All rights reserved.
//

#import "NCColors.h"

@implementation NCColors

+ (UIColor *)mainBackgroundColor {
    static UIColor *g_mainBackgroundColor;
    if(!g_mainBackgroundColor) {
        g_mainBackgroundColor = [UIColor whiteColor];
    }
    
    return g_mainBackgroundColor;
}

+ (UIColor *)ncSmallLightFontColor {
    static UIColor *g_ncSmallLightFontColor;
    if(!g_ncSmallLightFontColor) {
        g_ncSmallLightFontColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    }
    return g_ncSmallLightFontColor;
}

@end
