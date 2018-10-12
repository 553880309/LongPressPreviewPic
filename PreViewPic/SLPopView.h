//
//  SLPopView.h
//  PreViewPic
//
//  Created by SaraWu on 2018/10/12.
//  Copyright © 2018 SaraWu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPopView : UIViewController

+ (instancetype)popViewWithSize:(CGSize)size;

- (void)showContentFrom:(UIImageView *)imageView delegate:(id<UIPopoverPresentationControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
