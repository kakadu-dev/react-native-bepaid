#import "RNBepaid.h"
#import "SDWebViewController/SDWebViewController.h"
#import "SDWebViewController/SDWebViewDelegate.h"
#import "NSString+URLEncoding.h"

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
    SDWebViewController *webViewController = [[SDWebViewController alloc] initWithURL:url transactionId:transactionId token:token];
    webViewController.m_delegate = self;
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    [self.navigationController.navigationBar setTranslucent:false];
    [[self topViewController] presentViewController:self.navigationController animated:YES completion:nil];
}

#pragma MARK: - SDWebViewDelegate

- (void)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType: (UIWebViewNavigationType)navigationType {
    
    // Detect url
    NSString *urlString = request.URL.absoluteString;
    
    if ([urlString isEqualToString:POST_BACK_URL]) {
        NSString *result = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        NSString *mdString = [result stringBetweenString:@"MD=" andString:@"&PaRes"];
        NSString *paResString = [[result stringBetweenString:@"PaRes=" andString:@""] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dictionary = @{@"MD": mdString, @"PaRes": paResString};
        
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
