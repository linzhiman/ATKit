//
//  ViewController.m
//  ATKitDemo
//
//  Created by linzhiman on 2019/4/26.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import "ViewController.h"
#import "ATKitNotificationDemo.h"
#import "ATKitModuleManagerDemo.h"
#import "ATKitProtocolManagerDemo.h"
#import "ATKitComponentDemo.h"
#import "ATKitTransformViewController.h"

@interface ViewController ()

@property (nonatomic, strong) ATKitNotificationDemo *notificationDemo;
@property (nonatomic, strong) ATKitModuleManagerDemo *moduleManagerDemo;
@property (nonatomic, strong) ATKitProtocolManagerDemo *protocolManagerDemo;
@property (nonatomic, strong) ATKitComponentDemo *componentDemo;
@property (nonatomic, strong) ATKitTransformViewController *transformViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.notificationDemo = [[ATKitNotificationDemo alloc] init];
    [self.notificationDemo postNotification];
    
    self.moduleManagerDemo = [[ATKitModuleManagerDemo alloc] init];
    [self.moduleManagerDemo demo];
    
    self.protocolManagerDemo = [[ATKitProtocolManagerDemo alloc] init];
    [self.protocolManagerDemo demo];
    
    self.componentDemo = [[ATKitComponentDemo alloc] init];
    [self.componentDemo demo];
    
    self.transformViewController = [[ATKitTransformViewController alloc] init];
    [self.navigationController pushViewController:self.transformViewController animated:YES];
}

@end
