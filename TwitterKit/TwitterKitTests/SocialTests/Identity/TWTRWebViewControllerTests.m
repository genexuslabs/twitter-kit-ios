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

#import <UIKit/UIKit.h>
@import WebKit;
#import "TWTRTestCase.h"
#import "TWTRWebViewController.h"

@interface DummyNavigationAction: WKNavigationAction
- (id)initWithRequest:(NSURLRequest *)request;
@end

@implementation DummyNavigationAction {
	NSURLRequest *_request;
	WKNavigationType _navigationType;
}

- (id)initWithRequest:(NSURLRequest *)request
{
	return [self initWithRequest:request navigationType:0];
}

- (id)initWithRequest:(NSURLRequest *)request navigationType:(WKNavigationType)navigationType
{
	self = [super init];
	if (self)
	{
		_request = request;
		_navigationType = navigationType;
	}
	
	return self;
}

- (NSURLRequest *)request
{
	return _request;
}

- (WKNavigationType)navigationType
{
	return _navigationType;
}

@end

@interface TWTRWebViewController ()

@property (nonatomic, readonly) WKWebView *webView;

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;

@end

@interface TWTRWebViewControllerTests : TWTRTestCase

@property (nonatomic) TWTRWebViewController *webVC;

@end

@implementation TWTRWebViewControllerTests

- (void)setUp
{
    [super setUp];
    TWTRWebViewControllerShouldLoadCompletion shouldLoadCompletion = ^BOOL(UIViewController *controller, NSURLRequest *urlRequest, WKNavigationType navType) {
        return YES;
    };
    self.webVC = [[TWTRWebViewController alloc] init];
    [self.webVC setShouldStartLoadWithRequest:shouldLoadCompletion];
}

- (void)testShouldStartLoadWithRequest_returnsYESForWhitelistedDomain
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://twitter.com/test"]];
	WKNavigationAction *navigationAction = [[DummyNavigationAction alloc] initWithRequest:request];
	[self.webVC webView:nil decidePolicyForNavigationAction:navigationAction decisionHandler:^(WKNavigationActionPolicy policy) {
		XCTAssert(policy == WKNavigationActionPolicyAllow);
	}];
}

- (void)testShouldStartLoadWithRequest_returnsYESForWhitelistedSubDomain
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://lol.twitter.com/test"]];
	WKNavigationAction *navigationAction = [[DummyNavigationAction alloc] initWithRequest:request];
	[self.webVC webView:nil decidePolicyForNavigationAction:navigationAction decisionHandler:^(WKNavigationActionPolicy policy) {
		XCTAssert(policy == WKNavigationActionPolicyAllow);
	}];
}

- (void)testShouldStartLoadWithRequest_returnsYESForWhitelistedScheme
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"twittersdk://callback"]];
	WKNavigationAction *navigationAction = [[DummyNavigationAction alloc] initWithRequest:request];
	[self.webVC webView:nil decidePolicyForNavigationAction:navigationAction decisionHandler:^(WKNavigationActionPolicy policy) {
		XCTAssert(policy == WKNavigationActionPolicyAllow);
	}];
}

- (void)testShouldStartLoadWithRequest_returnsNOForHackySchemeInQuery
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://lolp0wnedtwitter.com/twittersdk://callback"]];
	WKNavigationAction *navigationAction = [[DummyNavigationAction alloc] initWithRequest:request];
	[self.webVC webView:nil decidePolicyForNavigationAction:navigationAction decisionHandler:^(WKNavigationActionPolicy policy) {
		XCTAssertFalse(policy == WKNavigationActionPolicyAllow);
	}];
}

- (void)testShouldStartLoadWithRequest_returnsNOForHackyScheme
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"abctwittersdk://callback"]];
	WKNavigationAction *navigationAction = [[DummyNavigationAction alloc] initWithRequest:request];
	[self.webVC webView:nil decidePolicyForNavigationAction:navigationAction decisionHandler:^(WKNavigationActionPolicy policy) {
		XCTAssertFalse(policy == WKNavigationActionPolicyAllow);
	}];
}

- (void)testShouldStartLoadWithRequest_returnsNOForHackyCleverLOLDomain
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://lolp0wnedtwitter.com/test"]];
	WKNavigationAction *navigationAction = [[DummyNavigationAction alloc] initWithRequest:request];
	[self.webVC webView:nil decidePolicyForNavigationAction:navigationAction decisionHandler:^(WKNavigationActionPolicy policy) {
		XCTAssertFalse(policy == WKNavigationActionPolicyAllow);
	}];
}

- (void)testShouldStartLoadWithRequest_returnsYESForWhitelistedDomainButHackyQuery
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://twitter.com/test?query=twitter.com"]];
	WKNavigationAction *navigationAction = [[DummyNavigationAction alloc] initWithRequest:request];
	[self.webVC webView:nil decidePolicyForNavigationAction:navigationAction decisionHandler:^(WKNavigationActionPolicy policy) {
		XCTAssertTrue(policy == WKNavigationActionPolicyAllow);
	}];
}

- (void)testShouldStartLoadWithRequest_returnsNOForNonWhitelistedDomain
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://google.com/test"]];
	WKNavigationAction *navigationAction = [[DummyNavigationAction alloc] initWithRequest:request];
	[self.webVC webView:nil decidePolicyForNavigationAction:navigationAction decisionHandler:^(WKNavigationActionPolicy policy) {
		XCTAssertFalse(policy == WKNavigationActionPolicyAllow);
	}];
}
@end
