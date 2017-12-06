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

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(setContentInsetAdjustmentBehavior:)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];    //保持方法签名和aSelector签名一致
    } else {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSInteger arg;
    [anInvocation getArgument:&arg atIndex:2];
    BOOL automaticallyAdjustsScrollViewInsets = arg!=2;
    
    UIResponder *res = self.nextResponder;
    while (![res isKindOfClass:[UIViewController class]]) {
        res = res.nextResponder;
    }
    
    anInvocation.target = res;
    anInvocation.selector = @selector(setAutomaticallyAdjustsScrollViewInsets:);
    [anInvocation setArgument:&automaticallyAdjustsScrollViewInsets atIndex:2];
    [anInvocation invoke];
}

@end
