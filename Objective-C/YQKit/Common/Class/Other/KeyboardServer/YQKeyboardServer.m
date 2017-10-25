//
//  YQKeyboardServer.m
//  Demo
//
//  Created by maygolf on 17/4/18.
//  Copyright © 2017年 yiquan. All rights reserved.
//

#import "YQKeyboardServer.h"

@interface YQKeyboardServer ()

@property (nonatomic, copy) YQBeforeAnimationsWithKeyboardBlock beforeAnimations;       // 动画开始之前的事件
@property (nonatomic, copy) YQAnimationsWithKeyboardBlock animations;                   // 动画
@property (nonatomic, copy) YQCompletionKeyboardAnimations completion;                  // 完成

@end

@implementation YQKeyboardServer

- (void)dealloc{
    [self unsubscribeKeyboard];
}

#pragma mark - private
// ----------------------------------------------------------------
- (void)handleWillShowKeyboardNotification:(NSNotification *)notification {
    [self keyboardWillShowHide:notification isShowing:YES];
}

// ----------------------------------------------------------------
- (void)handleWillHideKeyboardNotification:(NSNotification *)notification {
    [self keyboardWillShowHide:notification isShowing:NO];
}

- (void)keyboardWillShowHide:(NSNotification *)notification isShowing:(BOOL)isShowing {
    // getting keyboard animation attributes
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (self.beforeAnimations){
       self.beforeAnimations(keyboardRect, duration, isShowing);
    }
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [UIView setAnimationCurve:curve];
                         if (self.animations){
                             self.animations(keyboardRect, duration, isShowing);
                         }
                     }
                     completion:self.completion];
}

#pragma mark - puclic
- (void)subscribeKeyboardWithAnimations:(YQAnimationsWithKeyboardBlock)animations
                             completion:(YQCompletionKeyboardAnimations)completion{
    [self subscribeKeyboardWithBeforeAnimations:nil animations:animations completion:completion];
}

- (void)subscribeKeyboardWithBeforeAnimations:(YQBeforeAnimationsWithKeyboardBlock)beforeAnimations
                                   animations:(YQAnimationsWithKeyboardBlock)animations
                                   completion:(YQCompletionKeyboardAnimations)completion{
    self.beforeAnimations = beforeAnimations;
    self.animations = animations;
    self.completion = completion;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillShowKeyboardNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillHideKeyboardNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)unsubscribeKeyboard{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
