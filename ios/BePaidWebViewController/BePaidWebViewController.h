//
//  BePaidWebViewController.h
//  BePaidWebViewController
//
//  Created by Dmitry Sytsevich on 5/30/19.
//  Copyright © 2019 Dmitry Sytsevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BePaidWebViewDelegate;
@interface BePaidWebViewController : UIViewController

@property (weak, nonatomic) id<BePaidWebViewDelegate> m_delegate;

- (id)initWithURL:(id)url;

@end
