//
//  SLPopView.m
//  PreViewPic
//
//  Created by SaraWu on 2018/10/12.
//  Copyright © 2018 SaraWu. All rights reserved.
//

#import "SLPopView.h"
#import "SLTools.h"

@interface SLPopView ()
@property (nonatomic, strong) UIImageView *emoticonView;
@end

@implementation SLPopView

+ (instancetype)popViewWithSize:(CGSize)size;
{
    SLPopView *popView = [[SLPopView alloc] init];
    popView.preferredContentSize = size;
    popView.modalPresentationStyle = UIModalPresentationPopover;
    
    return popView;
}

#pragma mark - 设置popView数据

- (void)showContentFrom:(UIImageView *)imageView delegate:(id)delegate
{
    if ([imageView isEqual:self.popoverPresentationController.sourceView])
    {
        return;
    }
    
    self.emoticonView.image = imageView.image;
    self.popoverPresentationController.sourceView = imageView;
    self.popoverPresentationController.sourceRect = CGRectMake(0, -4, imageView.bounds.size.width, imageView.bounds.size.height);
    self.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    self.popoverPresentationController.delegate = delegate;
    // 注意 - 更新视图（如果不更新，无法切换popView指向的位置）
    [self.popoverPresentationController containerViewWillLayoutSubviews];
    
    [self showPopView];
}


#pragma mark - 展示popView

- (void)showPopView
{
    // 如果当前popView显示状态，直接返回
    if (self.isModalInPopover) return;
    
    // 如果当前没有显示popView，则显示
    [[SLTools topViewControler] presentViewController:self animated:YES completion:nil];
    self.modalInPopover = YES;
}


#pragma mark - 懒加载

- (UIImageView *)emoticonView
{
    if (_emoticonView == nil) {
        _emoticonView = [[UIImageView alloc] init];
        _emoticonView.frame = CGRectMake(0, 0, 150, 150);
        
        [self.view addSubview:_emoticonView];
    }
    return _emoticonView;
}
@end
