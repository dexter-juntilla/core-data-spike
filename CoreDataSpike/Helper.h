//
//  Helper.h
//  CoreDataSpike
//
//  Created by DNA on 7/15/16.
//  Copyright © 2016 DNA. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface Helper : NSObject

+ (CGFloat) getScreenWidth;
+ (CGFloat) getScreenHeight;
+ (void) showLoader:(UIView *)view;
+ (void) hideLoader:(UIView *)view;
@end
