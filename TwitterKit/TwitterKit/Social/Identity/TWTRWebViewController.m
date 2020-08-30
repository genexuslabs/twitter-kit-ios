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

#import "TWTRWebViewController.h"
@import WebKit;
#import <TwitterCore/TWTRAuthenticationConstants.h>

@interface TWTRWebViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) BOOL showCancelButton;
@property (nonatomic, copy) TWTRWebViewControllerCancelCompletion cancelCompletion;

@end

@implementation TWTRWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Twitter"];
    if ([self showCancelButton]) {
        [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)]];
    }
    [self load];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interface implementations

- (void)load
{
    [[self webView] loadRequest:[self request]];
}

#pragma mark - View controller lifecycle

- (void)loadView
{
	_webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:[self webViewConfiguration]];
    //[[self webView] setScalesPageToFit:YES];
	_webView.navigationDelegate = self;
    self.view = self.webView;
}

#define pageScaleJS @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"

- (WKWebViewConfiguration *)webViewConfiguration
{
	WKUserScript *userScript = [[WKUserScript alloc] initWithSource:pageScaleJS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
	WKUserContentController *userContentController = [[WKUserContentController alloc] init];
	[userContentController addUserScript:userScript];
	
	WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
	webConfig.userContentController = userContentController;
	return webConfig;
}

#pragma mark - WKWebViewNavigation delegate


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
	NSURLRequest *request = navigationAction.request;
	if (![self whitelistedDomain:request]) {
		// Open in Safari if request is not whitelisted
		NSLog(@"Opening link in Safari browser, as the host is not whitelisted: %@", request.URL);
		[[UIApplication sharedApplication] openURL:request.URL];
		decisionHandler(WKNavigationActionPolicyCancel);
		return;
	}
	if ([self shouldStartLoadWithRequest]) {
		BOOL shouldAllowNavigation = self.shouldStartLoadWithRequest(self, request, navigationAction.navigationType);
		decisionHandler(shouldAllowNavigation ? WKNavigationActionPolicyAllow : WKNavigationActionPolicyCancel);
		return;
	}
	decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
	if (self.errorHandler) {
		self.errorHandler(error);
		self.errorHandler = nil;
	}
}

#pragma mark - Internal methods

- (BOOL)whitelistedDomain:(NSURLRequest *)request
{
    NSString *whitelistedHostWildcard = [@"." stringByAppendingString:TWTRTwitterDomain];
    NSURL *url = request.URL;
    NSString *host = url.host;
    return ([host isEqualToString:TWTRTwitterDomain] || [host hasSuffix:whitelistedHostWildcard] || ([TWTRSDKScheme isEqualToString:url.scheme] && [TWTRSDKRedirectHost isEqualToString:host]));
}

- (void)cancel
{
    if ([self cancelCompletion]) {
        [self cancelCompletion](self);
        self.cancelCompletion = nil;
    }
}

- (void)enableCancelButtonWithCancelCompletion:(TWTRWebViewControllerCancelCompletion)cancelCompletion
{
    NSAssert([self isViewLoaded] == NO, @"This method must be called before the view controller is presented");
    [self setShowCancelButton:YES];
    [self setCancelCompletion:cancelCompletion];
}

@end
