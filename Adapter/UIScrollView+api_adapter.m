//
//  UIScrollView+api_adapter.m
//  Adapter
//
//  Created by weekope on 2017/12/5.
//  Copyright © 2017年 weekope. All rights reserved.
//

#import "UIScrollView+api_adapter.h"
#import <objc/runtime.h>



@implementation UIScrollView (api_adapter)

@dynamic selectorString;

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    self.selectorString = NSStringFromSelector(aSelector);
    
    if (aSelector == @selector(setContentInsetAdjustmentBehavior:)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];    //保持方法签名和aSelector签名一致
    } else {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([self.selectorString isEqualToString:@"setContentInsetAdjustmentBehavior:"]) {
        UIResponder *res = self.nextResponder;
        while (![res isKindOfClass:[UIViewController class]]) {
            res = res.nextResponder;
        }
        
        NSInteger arg;
        [anInvocation getArgument:&arg atIndex:2];
        BOOL automaticallyAdjustsScrollViewInsets = arg!=2;
        
        anInvocation.target = res;
        anInvocation.selector = @selector(setAutomaticallyAdjustsScrollViewInsets:);
        [anInvocation setArgument:&automaticallyAdjustsScrollViewInsets atIndex:2];
        [anInvocation invoke];
    } else {
        
    }
}


#pragma mark - accessory

- (void)setSelectorString:(NSString *)selectorString {
    objc_setAssociatedObject(self, @selector(selectorString), selectorString, OBJC_ASSOCIATION_ASSIGN);
}

- (NSString *)selectorString {
    return objc_getAssociatedObject(self, @selector(selectorString));
}

@end
