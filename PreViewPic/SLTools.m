//
//  SLTools.m
//  PreViewPic
//
//  Created by SaraWu on 2018/10/12.
//  Copyright © 2018 SaraWu. All rights reserved.
//

#import "SLTools.h"

@implementation SLTools

+ (UIViewController *)topViewControler
{
    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    UIViewController *parent = rootVC;
    while ((parent = rootVC.presentedViewController) != nil)
    {
        rootVC = parent;
        
    }
    while ([rootVC isKindOfClass:[UINavigationController class]])
    {
        rootVC = [(UINavigationController *)rootVC topViewController];
    }
    return rootVC;
}

+ (UIView *)fetchPointView:(CGPoint)point dataSource:(NSArray <UIView *> *)dataSource
{
    __block UIView *view = nil;
    [dataSource enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         CALayer *layer = [obj.layer hitTest:point];
         if (layer)
         {
             view = obj;
         }
     }];
    return view;
}

@end
