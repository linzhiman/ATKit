//
//  ATKitTransformViewController.m
//  ATKitDemo
//
//  Created by linzhiman on 2019/4/28.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import "ATKitTransformViewController.h"

@interface ATKitTransformViewController ()

@end

@implementation ATKitTransformViewController

- (ATNavigationBarStyle)navigationBarHidden
{
    return ATNavigationBarStyleHidden;
}

- (void)viewDidLoad
{
    self.usingTransformView = YES;
    
    [super viewDidLoad];
    
    {{
        UIButton *aButton = [UIButton new];
        aButton.backgroundColor = [UIColor blueColor];
        aButton.frame = CGRectMake(0, 0, 100, 30);
        [aButton setTitle:@"left top" forState:UIControlStateNormal];
        [self.transformView addSubview:aButton];
    }}
    
    {{
        UIButton *aButton = [UIButton new];
        aButton.backgroundColor = [UIColor blueColor];
        aButton.frame = CGRectMake(self.transformViewWidth - 100, 0, 100, 30);
        [aButton setTitle:@"right top" forState:UIControlStateNormal];
        [self.transformView addSubview:aButton];
    }}
    
    {{
        UIButton *aButton = [UIButton new];
        aButton.backgroundColor = [UIColor blueColor];
        aButton.frame = CGRectMake(0, self.transformViewHeight - 30, 100, 30);
        [aButton setTitle:@"left bottom" forState:UIControlStateNormal];
        [self.transformView addSubview:aButton];
    }}
    
    {{
        UIButton *aButton = [UIButton new];
        aButton.backgroundColor = [UIColor blueColor];
        aButton.frame = CGRectMake(self.transformViewWidth - 100, self.transformViewHeight - 30, 100, 30);
        [aButton setTitle:@"right bottom" forState:UIControlStateNormal];
        [self.transformView addSubview:aButton];
    }}
    
    {{
        UIButton *aButton = [UIButton new];
        aButton.backgroundColor = [UIColor blueColor];
        aButton.frame = CGRectMake((AT_SCREEN_WIDTH - 100) / 2, (AT_SCREEN_HEIGHT - 30) / 2, 100, 30);
        [aButton setTitle:@"back" forState:UIControlStateNormal];
        [aButton addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
        [self.transformView addSubview:aButton];
    }}
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
