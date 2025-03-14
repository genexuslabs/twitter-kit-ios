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

#ifndef TWTRTimelineFilterManager_h
#define TWTRTimelineFilterManager_h

/**
 This header is private to the Twitter Kit SDK and not exposed for public SDK consumption
 */

#import <Foundation/Foundation.h>

@class TWTRTimelineFilter;
@class TWTRTweet;

@interface TWTRTimelineFilterManager : NSObject

/*
 *  Returns a list of tweets after the applying the specified filters.
 */
- (nonnull NSArray *)filterTweets:(nonnull NSArray *)tweets;

- (nullable instancetype)initWithFilters:(nullable TWTRTimelineFilter *)filters NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init NS_UNAVAILABLE;
- (nonnull instancetype) new NS_UNAVAILABLE;
@end

#endif /* TWTRTimelineFilterManager_h */
