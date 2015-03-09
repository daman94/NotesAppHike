//
//  UIFont+NCAdditions.m
//  NotesAppHike
//
//  Created by Karan Kumar on 06/08/14.
//  Copyright (c) 2014 KaranKumar. All rights reserved.
//

#import "UIFont+NCAdditions.h"

@implementation UIFont (NCAdditions)

+ (UIFont *)ncRegularFontOfSize:(CGFloat)size {
    return [UIFont systemFontOfSize:size];
}
+ (UIFont *)ncBoldFontOfSize:(CGFloat)size {
    return [UIFont boldSystemFontOfSize:size];
}
+ (UIFont *)ncExtraBoldFontOfSize:(CGFloat)size {
    return [UIFont boldSystemFontOfSize:size];
}

@end
