//
//  ViewController.m
//  PreViewPic
//
//  Created by SaraWu on 2018/10/11.
//  Copyright © 2018 SaraWu. All rights reserved.
//

#import "ViewController.h"
#import "SLPopView.h"
#import "SLTools.h"

@interface ViewController () <UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) SLPopView *popView;
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;

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


#pragma mark - 长按手势事件

- (void)buttonTouchedLongTime:(UILongPressGestureRecognizer *)gesture
{
    UIImageView *imageView = [self fetchPointView:[gesture locationInView:self.view]];
    
    if (imageView)
    {
        [self imageView:imageView responseGesture:gesture];
    }
    else
    {
        if (self.popView.isModalInPopover)
        {
            [self.popView dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)imageView:(UIImageView *)imageView responseGesture:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            
            [self.popView showContentFrom:imageView delegate:self];
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
    return (UIImageView *)[SLTools fetchPointView:point dataSource:self.view.subviews];
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


#pragma mark - Lazy


- (SLPopView *)popView
{
    if (_popView == nil) {
        _popView = [SLPopView popViewWithSize:CGSizeMake(160, 150)];
    }
    return _popView;
}

@end
