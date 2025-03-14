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

#ifndef NSArray_Helpers_h
#define NSArray_Helpers_h

#import <Foundation/Foundation.h>

typedef _Nonnull id (^TSEArrayMapBlock)(_Nonnull id element);
typedef BOOL (^TSEArrayFilterBlock)(_Nonnull id element);

FOUNDATION_EXTERN NSArray *_Nonnull tse_map(NSArray *_Nonnull array, _Nonnull TSEArrayMapBlock block);
FOUNDATION_EXTERN NSArray *_Nonnull tse_filter(NSArray *_Nonnull array, _Nonnull TSEArrayFilterBlock block);

#endif /* NSArray_Helpers_h */
