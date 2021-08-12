//
//  UICollectionView+PSBugFix.m
//  Pods-PSKitPrj
//
//  Created by 沈闻欣 on 2021/8/2.
//  Copyright © 2021 swx. All rights reserved.
//

#import "UICollectionView+PSBugFix.h"
#import <objc/runtime.h>

// fix bug see: https://developer.apple.com/forums/thread/663156
@implementation UICollectionView (PSBugFix)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(scrollToItemAtIndexPath:atScrollPosition:animated:);
        SEL swizzledSelector = @selector(ps_scrollToItemAtIndexPath:atScrollPosition:animated:);
        
        Class class = [self class];
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)ps_scrollToItemAtIndexPath:(NSIndexPath *)indexPath
                  atScrollPosition:(UICollectionViewScrollPosition)scrollPosition
                          animated:(BOOL)animated {
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 14.0 &&
        self.isPagingEnabled == true) {
        self.pagingEnabled = false;
        [self ps_scrollToItemAtIndexPath:indexPath
                        atScrollPosition:scrollPosition
                                animated:animated];
        self.pagingEnabled = true;
    } else {
        [self ps_scrollToItemAtIndexPath:indexPath
                        atScrollPosition:scrollPosition
                                animated:animated];
    }
}

@end
