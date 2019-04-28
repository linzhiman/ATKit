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

@interface ViewController ()

@property (nonatomic, strong) ATKitNotificationDemo *notificationDemo;
@property (nonatomic, strong) ATKitModuleManagerDemo *moduleManagerDemo;
@property (nonatomic, strong) ATKitProtocolManagerDemo *protocolManagerDemo;

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
}

@end
