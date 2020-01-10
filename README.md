# ATKit

## 1、BlockNotificationCenter-类型安全的通知中心

### 设计思路请查看 

[BlockNotificationCenter](http://linzhiman.github.io/2019/08/29/BlockNotificationCenter-类型安全的通知中心.html)

### 使用方法：

#### (1)头文件添加申明

      AT_BN_DECLARE(kName, int, a, NSString *, b)

#### (2)实现文件添加定义

      AT_BN_DEFINE(kName, int, a, NSString *, b)

#### (3)监听，obj.a/obj.b可访问对应参数

      [self atbn_onkName:^(ATBNkNameObj * _Nonnull obj) {}];

#### (4)取消监听

      [self atbn_removeName:kName];

#### (5)取消所有监听

      [self atbn_removeALL];

#### (6)发送通知

      [self atbn_postkName_a:123 b:@"abc"];
