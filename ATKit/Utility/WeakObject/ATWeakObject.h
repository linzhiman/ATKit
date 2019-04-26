//
//  ATWeakObject.h
//  demo
//
//  Created by linzhiman on 2019/4/24.
//  Copyright © 2019 linzhiman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATWeakObject : NSObject

- (NSString *)objectKey;

+ (NSString *)objectKey:(id)targetObj;

@property (nonatomic, weak) id target;

@property (nonatomic, strong) id extension;

@end

NS_ASSUME_NONNULL_END
