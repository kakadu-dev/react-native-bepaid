#import "RNBepaid.h"
#import "SDWebViewController/SDWebViewController.h"
#import "SDWebViewController/SDWebViewDelegate.h"
#import "NSString+URLEncoding.h"

#define COMPLETE_URL @"https://test.com"

typedef void (^RCTPromiseResolveBlock)(id result);
typedef void (^RCTPromiseRejectBlock)(NSString *code, NSString *message, NSError *error);

@interface RNBepaid () <SDWebViewDelegate>

@property (nonatomic, retain) UINavigationController *navigationController;

@property (nonatomic) RCTPromiseResolveBlock resolveWebView;
@property (nonatomic) RCTPromiseRejectBlock rejectWebView;

@end

@implementation RNBepaid

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(show3DS: (NSString *)url
                  endUrl: (NSString *)endUrl
                  resolve: (RCTPromiseResolveBlock)resolve
                  reject: (RCTPromiseRejectBlock)reject)
{
    self.resolveWebView = resolve;
    self.rejectWebView = reject;
    
    // Show WebView
    SDWebViewController *webViewController = [[SDWebViewController alloc] initWithURL:url];
    webViewController.m_delegate = self;
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    [self.navigationController.navigationBar setTranslucent:false];
    [[self topViewController] presentViewController:self.navigationController animated:YES completion:nil];
}

#pragma MARK: - SDWebViewDelegate

- (void)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType: (UIWebViewNavigationType)navigationType {
    
    // Detect url
    NSString *urlString = request.URL.absoluteString;
    
    if ([urlString isEqualToString:COMPLETE_URL]) {
        NSDictionary *dictionary = @{@"status": @YES};
        self.resolveWebView(dictionary);
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)webViewWillClose:(UIWebView *)webView {
    self.rejectWebView(@"", @"", nil);
}

#pragma MARK: - ViewController

- (UIViewController *)topViewController {
    UIViewController *baseVC = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([baseVC isKindOfClass:[UINavigationController class]]) {
        return ((UINavigationController *)baseVC).visibleViewController;
    }
    
    if ([baseVC isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectedTVC = ((UITabBarController*)baseVC).selectedViewController;
        if (selectedTVC) {
            return selectedTVC;
        }
    }
    
    if (baseVC.presentedViewController) {
        return baseVC.presentedViewController;
    }
    
    return baseVC;
}

@end
