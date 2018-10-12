//
//  SLTools.h
//  PreViewPic
//
//  Created by SaraWu on 2018/10/12.
//  Copyright © 2018 SaraWu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLTools : NSObject

/// 获取当前顶级视图控制器
+ (UIViewController *)topViewControler;

+ (UIView *)fetchPointView:(CGPoint)point dataSource:(NSArray <UIView *> *)dataSource;

@end

NS_ASSUME_NONNULL_END
