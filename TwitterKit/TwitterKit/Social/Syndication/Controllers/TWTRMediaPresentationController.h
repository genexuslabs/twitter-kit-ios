/*
 * Copyright (C) 2017 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#ifndef TWTRMediaPresentationController_h
#define TWTRMediaPresentationController_h

/**
 This header is private to the Twitter Kit SDK and not exposed for public SDK consumption
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWTRMediaPresentationController : UIPresentationController

@end

@interface TWTRMediaAnimatedTransitioningPresenter : NSObject <UIViewControllerAnimatedTransitioning>

/**
 * Initializes the presenter with a view that will be animated.
 *
 * @param transitionView the view that will be animated during the transition
 * @param initialFrame the initial frame of the view
 * @param targetFrame the frame that the view will be transition to
 * @param completion a block to invoke when the transition has completed.
 */
- (instancetype)initWithTransitioningView:(UIView *)transitionView initialFrame:(CGRect)frame targetFrame:(CGRect)targetFrame completion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END

#endif /* TWTRMediaPresentationController_h */
