//
//  ViewController.m
//  PreViewPic
//
//  Created by SaraWu on 2018/10/11.
//  Copyright © 2018 SaraWu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;

// 用于预览的外壳
@property (nonatomic, strong) UIViewController *popView;
// 预览的内容
@property (nonatomic, strong) UIImageView *emoticonView;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 添加长按手势
    [self addLongPressGestureRecognizer:self.view];
    
    // 添加平移手势
    [self addPanPressGestureRecognizer:self.view];
}


#pragma mark - 添加手势

// 添加长按手势
- (void)addLongPressGestureRecognizer:(UIView *)view
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] init];
    [longPress addTarget:self action:@selector(buttonTouchedLongTime:)];
    longPress.minimumPressDuration = 0.5;
    [view addGestureRecognizer:longPress];
}

// 添加平移手势
- (void)addPanPressGestureRecognizer:(UIView *)view
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    pan.delegate = self;
    [pan addTarget:self action:@selector(gestureMove:)];
    
    [view addGestureRecognizer:pan];
}


#pragma mark - 长按手势事件

- (void)buttonTouchedLongTime:(UILongPressGestureRecognizer *)gesture
{
    UIImageView *imageView = [self fetchPointView:[gesture locationInView:self.view]];
    if (imageView == nil)
    {
        if (self.popView.isModalInPopover)
        {
            [self.popView dismissViewControllerAnimated:YES completion:nil];
        }
        return;
    }
    
    [self imageView:imageView responseGesture:gesture];
}

- (void)imageView:(UIImageView *)imageView responseGesture:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            
            [self showPopView:imageView];
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            
            [self.popView dismissViewControllerAnimated:YES completion:nil];
            self.popView.modalInPopover = NO;
            break;
            
        default:
            break;
    }
}

- (void)showPopView:(UIImageView *)imageView
{
    // 给触摸到的视图添加PopView以及PopView将要显示的数据
    [self addContentForPopView:imageView];
    
    // 如果当前popView显示状态，直接返回
    if (self.popView.isModalInPopover) return;

    // 如果当前没有显示popView，则显示
    [self presentViewController:self.popView animated:YES completion:nil];
    self.popView.modalInPopover = YES;
}

// 添加PopView将要显示的数据
- (void)addContentForPopView:(UIImageView *)imageView
{
    if ([imageView isEqual:self.popView.popoverPresentationController.sourceView])
    {
        return;
    }
    
    self.emoticonView.image = imageView.image;
    self.popView.popoverPresentationController.sourceView = imageView;
    self.popView.popoverPresentationController.sourceRect = CGRectMake(0, -4, imageView.bounds.size.width, imageView.bounds.size.height);
    self.popView.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    self.popView.popoverPresentationController.delegate = self;
    // 注意 - 更新视图（如果不更新，无法切换popView指向的位置）
    [self.popView.popoverPresentationController containerViewWillLayoutSubviews];
}


#pragma mark - 拖拽手势事件

- (void)gestureMove:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIImageView *imageView = [self fetchPointView:[panGestureRecognizer locationInView:self.view]];
    if (imageView == nil)
    {
        return;
    }
    
    UIView *view = imageView;
    CGPoint translation = [panGestureRecognizer translationInView:view];
    view.center = CGPointMake(view.center.x + translation.x, view.center.y + translation.y);
    [panGestureRecognizer setTranslation:CGPointZero inView:view];
}


#pragma mark - <UIPopoverPresentationControllerDelegate>

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection
{
    return UIModalPresentationNone;
}


#pragma mark - Tool

- (UIImageView *)fetchPointView:(CGPoint)point
{
    __block UIImageView *imageV = nil;
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         if ([obj isEqual:self.firstImage] || [obj isEqual:self.secondImage])
         {
             CALayer *layer = [obj.layer hitTest:point];
             if (layer)
             {
                 imageV = obj;
             }
         }
     }];
    return imageV;
}


#pragma mark - Lazy


- (UIViewController *)popView
{
    if (_popView == nil) {
        _popView = [[UIViewController alloc] init];
        _popView.preferredContentSize = CGSizeMake(160, 150);
        _popView.modalPresentationStyle = UIModalPresentationPopover;
        [_popView.view addSubview:self.emoticonView];
    }
    return _popView;
}

- (UIImageView *)emoticonView
{
    if (_emoticonView == nil) {
        _emoticonView = [[UIImageView alloc] initWithImage:self.firstImage.image];
        _emoticonView.frame = CGRectMake(0, 0, 150, 150);
    }
    return _emoticonView;
}

@end
