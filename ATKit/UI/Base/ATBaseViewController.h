//
//  ATBaseViewController.h
//  ATKit
//
//  Created by linzhiman on 2019/4/28.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AT_IPHONE6_WIDTH 375
#define AT_IPHONE6_HEIGHT 667

#define AT_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define AT_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define AT_IPHONEX_SET (AT_SCREEN_WIDTH >= 375.f && AT_SCREEN_HEIGHT >= 812.f )//X,XR,XS
#define AT_STATUSBAR_HEIGHT (AT_IPHONEX_SET ? 44.f : 20.f)
#define AT_STATUSBAR_AND_NAVIGATION_BAR_HEIGHT (AT_IPHONEX_SET ? 88.f : 64.f)

typedef NS_ENUM(NSInteger, ATNavigationBarStyle)
{
    ATNavigationBarStyleIgnore,
    ATNavigationBarStyleHidden,
    ATNavigationBarStyleShow
};

NS_ASSUME_NONNULL_BEGIN

#define QYTransformViewWidthForFullScreen ([ATBaseViewController transformViewWidthFor:ATNavigationBarStyleHidden])

@interface ATBaseViewController : UIViewController

- (ATNavigationBarStyle)navigationBarHidden;

@property (nonatomic, strong) UIView *transformView;
@property (nonatomic, assign) BOOL usingTransformView;
@property (nonatomic, assign, readonly) CGFloat transformViewWidth;
@property (nonatomic, assign, readonly) CGFloat transformViewHeight;

+ (CGFloat)transformViewWidthFor:(ATNavigationBarStyle)type;

@end

NS_ASSUME_NONNULL_END
