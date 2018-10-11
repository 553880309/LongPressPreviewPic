//
//  ViewController.m
//  PreViewPic
//
//  Created by SaraWu on 2018/10/11.
//  Copyright © 2018 SaraWu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate>

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
    
    if ([gesture state] == UIGestureRecognizerStateBegan)
    {
        [self showPopView:imageView];
        self.popView.modalInPopover = YES;
    }
    else if ([gesture state] == UIGestureRecognizerStateChanged)
    {
        [self addContentForPopView:imageView];
        self.popView.modalInPopover = YES;
    }
    else if ([gesture state] == UIGestureRecognizerStateEnded)
    {
        [self.popView dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showPopView:(UIImageView *)imageView
{
    [self addContentForPopView:imageView];
    
    [self presentViewController:self.popView animated:YES completion:nil];
}

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

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing  _Nonnull *)view
{
    NSLog(@"popoverPresentationController:willRepositionPopoverToRect");
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

// 获取当前顶级视图控制器
- (UIViewController *)fetchTopviewControler
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

@end
