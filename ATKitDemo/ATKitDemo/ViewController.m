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
#import "ATKitApiStrategyDemo.h"

typedef NS_ENUM(NSUInteger, ATKitDemoCellType) {
    ATKitDemoCellTypeDefault,
    ATKitDemoCellTypeSwitch
};

typedef NS_ENUM(NSUInteger, ATKitDemoSectionType) {
    ATKitDemoSectionTypeUtils,
    ATKitDemoSectionTypeUI,
    ATKitDemoSectionTypeEnd
};

typedef void (^ATKitSwitchChangeCallback)(BOOL isON);


@interface ATKitDemoConfig : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) ATKitDemoCellType type;
@property (nonatomic, assign) ATKitDemoSectionType sectionType;
@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, copy) dispatch_block_t clickCallback;
@property (nonatomic, copy) ATKitSwitchChangeCallback switchChangedCallback;

@end

@implementation ATKitDemoConfig

@end


@interface ATKitDemoCell : UITableViewCell

@property (nonatomic, strong) ATKitDemoConfig *model;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UISwitch *switchView;

@end

@implementation ATKitDemoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [_switchView addTarget:self action:@selector(onSwitchChanged:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_label];
        [self.contentView addSubview:_switchView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _label.frame = CGRectMake(20, 5, self.contentView.bounds.size.width - 100, CGRectGetHeight(self.contentView.bounds));
    _switchView.frame = CGRectMake(CGRectGetWidth(self.contentView.bounds) - 60, 5, 40, CGRectGetHeight(self.contentView.bounds));
}

- (void)setContent:(ATKitDemoConfig *)model
{
    _model = model;
    
    _label.text = model.title;
    
    _switchView.hidden = YES;
    if (model.type == ATKitDemoCellTypeSwitch) {
        _switchView.hidden = NO;
        [_switchView setOn:model.isOn animated:NO];
    }
}

- (void)onSwitchChanged:(UISwitch *)switchView
{
    AT_SAFETY_CALL_BLOCK(self.model.switchChangedCallback, switchView.on);
}

@end

static NSString * const ATKitDemoCellIdentifier = @"ATKitDemoCellIdentifier";

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *sectionTitleArray;
@property (nonatomic, strong) NSMutableArray *sectionList;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation ViewController

- (void)viewDidLoad
{
#define BEGIN_BIND_SECTION() self.sectionTitleArray = @{
    
#define BIND_SECTION_TITLE(__SECTION_TYPE__, __SECTION_TITLE__) @(__SECTION_TYPE__):__SECTION_TITLE__
    
#define END_BIND_SECTION() };

    [super viewDidLoad];
    
    BEGIN_BIND_SECTION()
    
    BIND_SECTION_TITLE(ATKitDemoSectionTypeUtils, @"Utils"),
    BIND_SECTION_TITLE(ATKitDemoSectionTypeUI, @"UI"),
    
    END_BIND_SECTION()
    
    [self initData];
    [self initViews];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)initData
{
    _dataList = [NSMutableArray new];

    AT_WEAKIFY_SELF;
    
    /// =========================== 基础工具控件 ==================================

    [self addItem:@"UI" inSectionType:ATKitDemoSectionTypeUI clickCallback:^{
        [weak_self.navigationController pushViewController:[[ATKitTransformViewController alloc] init] animated:YES];
    }];
    
    /// =========================== 测试页面 ==================================

    [self addItem:@"Notification" inSectionType:ATKitDemoSectionTypeUtils clickCallback:^{
        [[[ATKitNotificationDemo alloc] init] demo];
    }];
    [self addItem:@"Notification2" inSectionType:ATKitDemoSectionTypeUtils clickCallback:^{
        [[[ATKitNotificationDemo2 alloc] init] demo];
    }];
    
    [self addItem:@"ModuleManager" inSectionType:ATKitDemoSectionTypeUtils clickCallback:^{
        [[[ATKitModuleManagerDemo alloc] init] demo];
    }];
    
    [self addItem:@"ProtocolManager" inSectionType:ATKitDemoSectionTypeUtils clickCallback:^{
        [[[ATKitProtocolManagerDemo alloc] init] demo];
    }];
    
    [self addItem:@"Component" inSectionType:ATKitDemoSectionTypeUtils clickCallback:^{
        [[[ATKitComponentDemo alloc] init] demo];
    }];
    
    [self addItem:@"ApiStrategy" inSectionType:ATKitDemoSectionTypeUtils clickCallback:^{
        [[[ATKitApiStrategyDemo alloc] init] demo];
    }];
    
    [self makeSectionList];
}

- (void)initViews
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[ATKitDemoCell class] forCellReuseIdentifier:ATKitDemoCellIdentifier];
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

- (ATKitDemoConfig *)addItem:(NSString *)title inSectionType:(ATKitDemoSectionType)sectionType clickCallback:(dispatch_block_t)callback
{
    ATKitDemoConfig *model = [ATKitDemoConfig new];
    model.title = title;
    model.type = ATKitDemoCellTypeDefault;
    model.sectionType = sectionType;
    model.clickCallback = callback;
    [_dataList addObject:model];
    return model;
}

- (ATKitDemoConfig *)addItem:(NSString *)title inSectionType:(ATKitDemoSectionType)sectionType switchCallback:(ATKitSwitchChangeCallback)callback
{
    ATKitDemoConfig *model = [ATKitDemoConfig new];
    model.title = title;
    model.type = ATKitDemoCellTypeSwitch;
    model.sectionType = sectionType;
    model.switchChangedCallback = callback;
    [_dataList addObject:model];
    return model;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_sectionList.count > 0) {
        return _sectionList.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_sectionList.count > 0) {
        NSArray *array = _sectionList[section];
        return array.count;
    }
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ATKitDemoConfig *model = nil;
    if (_sectionList.count > 0) {
        NSArray *array = _sectionList[indexPath.section];
        model = array[indexPath.row];
    }
    else {
        model = _dataList[indexPath.row];
    }
    ATKitDemoCell *cell = [tableView dequeueReusableCellWithIdentifier:ATKitDemoCellIdentifier forIndexPath:indexPath];
    [cell setContent:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ATKitDemoConfig *model = nil;
    if (_sectionList.count > 0) {
        NSArray *array = _sectionList[indexPath.section];
        model = array[indexPath.row];
    }
    else {
        model = _dataList[indexPath.row];
    }
    AT_SAFETY_CALL_BLOCK(model.clickCallback);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_sectionList.count > 0) {
        return 40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor blueColor];
    UILabel *label = [UILabel new];
    if (section < self.sectionTitleArray.count) {
        label.text = self.sectionTitleArray[@(section)];
    }
    [view addSubview:label];
    label.frame = CGRectMake(20, 0, 200, 40);
    return view;
}

- (void)makeSectionList
{
    _sectionList = [[NSMutableArray alloc] init];
    for (NSUInteger i = ATKitDemoSectionTypeUtils; i <= ATKitDemoSectionTypeEnd; i++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [_dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ATKitDemoConfig *model = obj;
            if (model.sectionType == i) {
                [array addObject:model];
            }
        }];
        if (array.count > 0) {
            [_sectionList addObject:array];
        }
    }
}

@end
