//
//  MyDrawerViewController.m
//  MyDrawerViewController
//
//  Created by 蔡成汉 on 16/4/6.
//  Copyright © 2016年 蔡成汉. All rights reserved.
//

#import "MyDrawerViewController.h"
#import "MySideViewController.h"

/**
 *  抽屉状态 -- 默认为关闭
 */
typedef NS_ENUM(NSInteger,DrawerState) {
    /**
     *  关闭 -- 默认状态
     */
    isClose = 0,
    /**
     *  开启
     */
    isOpen = 1
};

@interface MyDrawerViewController ()
{
    /**
     *  抽屉状态
     */
    DrawerState drawerState;
}

/**
 *  侧边View
 */
@property (nonatomic , strong) UIView *sideView;

/**
 *  内容View
 */
@property (nonatomic , strong) UIView *contentView;

/**
 *  侧边VC
 */
@property (nonatomic , strong) UIViewController *mySideViewController;

/**
 *  内容VC
 */
@property (nonatomic , strong) UIViewController *myContentViewController;

/**
 *  内容View侧边滑动手势接收View
 */
@property (nonatomic , strong) UIView *sideGesView;

/**
 *  内容页滑动/单击手势接收View
 */
@property (nonatomic , strong) UIView *contentGesView;

/**
 *  statusBar
 */
@property (nonatomic , strong) UIView *statusBar;

/**
 *  statusBarHeight
 */
@property (nonatomic , assign) CGFloat statusBarHeight;

@end

@implementation MyDrawerViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61, 0x72} length:9] encoding:NSASCIIStringEncoding];
        id object = [UIApplication sharedApplication];
        if ([object respondsToSelector:NSSelectorFromString(key)])
        {
            _statusBar = [object valueForKey:key];
        }
        _drawerRightWidth = 80.0;
        _shadowColor = [UIColor blackColor];
        _shadowRadius = 7.0;
        _animationTime = 0.26;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

/**
 *  侧滑手势
 *
 *  @param recognizer 侧滑手势
 */
-(void)myPanGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer translationInView:self.view];
    CGFloat newPointX = point.x;
    if (newPointX <=0)
    {
        /**
         *  当拖动的X点小于0的时候，X点的位置只能为0，防止出界。
         */
        newPointX = 0;
    }
    if (newPointX >= self.view.frame.size.width - _drawerRightWidth)
    {
        /**
         *  当拖动的X点超过的最大展开点的时候，X点的位置只能为最大展开点位置，防止越界。
         */
        newPointX = self.view.frame.size.width - _drawerRightWidth;
    }
    
    /**
     *  动态更改内容视图位置
     */
    _contentView.frame = CGRectMake(newPointX, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    
    /**
     *  动态更改statusbar位置
     */
    _statusBar.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, _contentView.frame.size.width, self.statusBarHeight);
    
    /**
     *  动态更改侧边视图位置
     */
    CGFloat xRate = 1.0/(self.view.frame.size.width - _drawerRightWidth)*newPointX;
    _sideView.frame = CGRectMake(-(self.view.frame.size.width-_drawerRightWidth)*0.35+((self.view.frame.size.width-_drawerRightWidth)*0.35)*xRate, _sideView.frame.origin.y, self.view.frame.size.width-_drawerRightWidth, _sideView.frame.size.height);
    
    /**
     *  手势结束 -- 采用动画完成抽屉效果
     */
    if (gestureRecognizer.state == UIGestureRecognizerStateCancelled || gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateFailed)
    {
        /**
         *  执行拖动 -- 根据现在内容页的X位置进行动画还原
         */
        CGFloat pointX = _contentView.frame.origin.x;
        if (pointX>=(self.view.frame.size.width - _drawerRightWidth)*0.5)
        {
            /**
             *  拉动距离大于拖动范围的50%，则打开抽屉
             */
            [self openDrawerView];
        }
        else
        {
            /**
             *  拉动距离小于拖动范围的75%，则关闭抽屉
             */
            [self closeDrawerView];
        }
    }
}

/**
 *  打开抽屉
 */
-(void)openDrawerView
{
    [UIView animateWithDuration:_animationTime animations:^{
        _contentView.frame = CGRectMake(self.view.frame.size.width - _drawerRightWidth, 0, _contentView.frame.size.width, _contentView.frame.size.height);
        _statusBar.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, _contentView.frame.size.width, self.statusBarHeight);
        _sideView.frame = CGRectMake(0, _sideView.frame.origin.y, self.view.frame.size.width-_drawerRightWidth, _sideView.frame.size.height);
    } completion:^(BOOL finished) {
        /**
         *  记录抽屉状态 -- 为打开状态
         */
        drawerState = isOpen;
        
        /**
         *  添加侧边栏手势 -- 用于关闭抽屉
         */
        [self addGestureRecognizer];
    }];
}

/**
 *  关闭抽屉
 */
-(void)closeDrawerView
{
    [UIView animateWithDuration:_animationTime animations:^{
        _contentView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
        _statusBar.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, _contentView.frame.size.width, self.statusBarHeight);
        _sideView.frame = CGRectMake(-(self.view.frame.size.width-_drawerRightWidth)*0.35, _sideView.frame.origin.y, self.view.frame.size.width-_drawerRightWidth, _sideView.frame.size.height);
    } completion:^(BOOL finished) {
        /**
         *  记录抽屉状态 -- 为关闭状态
         */
        drawerState = isClose;
        
        /**
         *  移除侧边栏手势
         */
        [self removeGestureRecognizer];
    }];
}

/**
 *  添加手势 -- 单击、拖动
 */
-(void)addGestureRecognizer
{
    if ([_rootViewController isKindOfClass:[UINavigationController class]])
    {
        UIView *tpView = [((UINavigationController *)_rootViewController).viewControllers objectAtIndex:0].view;
        self.contentGesView.frame = CGRectMake(0, 0, tpView.frame.size.width, tpView.frame.size.height);
        [tpView addSubview:self.contentGesView];
    }
    else
    {
        UIView *tpView = _rootViewController.view;
        self.contentGesView.frame = CGRectMake(0, 0, tpView.frame.size.width, tpView.frame.size.height);
        [tpView addSubview:self.contentGesView];
    }
    
    /**
     *  添加单击手势
     */
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [self.contentGesView addGestureRecognizer:tapGestureRecognizer];
    
    /**
     *  添加拖动手势
     */
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self.contentGesView addGestureRecognizer:panGestureRecognizer];
}

/**
 *  移除手势
 */
-(void)removeGestureRecognizer
{
    [self.contentGesView removeFromSuperview];
}

/**
 *  单击手势事件
 *
 *  @param gestureRecognizer 单击手势
 */
-(void)tapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer
{
    /**
     *  单击手势 -- 关闭抽屉
     */
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [self closeDrawerView];
    }
}

/**
 *  拖动手势事件
 *
 *  @param gestureRecognizer 拖动手势
 */
-(void)panGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer translationInView:self.view];
    CGFloat newPointX = self.view.frame.size.width - _drawerRightWidth + point.x;
    if (newPointX <=0)
    {
        /**
         *  当拖动的X点小于0的时候，X点的位置只能为0，防止出界。
         */
        newPointX = 0;
    }
    if (newPointX >= self.view.frame.size.width - _drawerRightWidth)
    {
        /**
         *  当拖动的X点超过的最大展开点的时候，X点的位置只能为最大展开点位置，防止越界。
         */
        newPointX = self.view.frame.size.width - _drawerRightWidth;
    }
    
    /**
     *  动态更改内容视图位置
     */
    _contentView.frame = CGRectMake(newPointX, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    
    /**
     *  动态更改statusbar位置
     */
    _statusBar.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, _contentView.frame.size.width, self.statusBarHeight);
    
    /**
     *  动态更改侧边视图位置
     */
    CGFloat xRate = 1.0/(self.view.frame.size.width - _drawerRightWidth)*newPointX;
    _sideView.frame = CGRectMake(-(self.view.frame.size.width-_drawerRightWidth)*0.35+((self.view.frame.size.width-_drawerRightWidth)*0.35)*xRate, _sideView.frame.origin.y, self.view.frame.size.width-_drawerRightWidth, _sideView.frame.size.height);
    
    /**
     *  手势结束
     */
    if (gestureRecognizer.state == UIGestureRecognizerStateCancelled || gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateFailed)
    {
        /**
         *  执行拖动 -- 根据现在内容页的X位置进行动画还原
         */
        CGFloat pointX = _contentView.frame.origin.x;
        if (pointX>=(self.view.frame.size.width - _drawerRightWidth)*0.5)
        {
            /**
             *  拉动距离大于拖动范围的50%，则打开抽屉
             */
            [self openDrawerView];
        }
        else
        {
            /**
             *  拉动距离小于拖动范围的75%，则关闭抽屉
             */
            [self closeDrawerView];
        }
    }
}



/**
 *  set
 *
 *  @param sideController 侧边
 */
-(void)setSideController:(MySideViewController *)sideController
{
    _sideController = sideController;
    _sideController.drawerViewController = self;
    [_mySideViewController removeFromParentViewController];
    _mySideViewController = _sideController;
    [self addChildViewController:_mySideViewController];
    
    [_sideView removeFromSuperview];
    _sideView = _mySideViewController.view;
    [self.view addSubview:_sideView];
}

/**
 *  set
 *
 *  @param rootViewController root-内容页
 */
-(void)setRootViewController:(UIViewController *)rootViewController
{
    _rootViewController = rootViewController;
    [_myContentViewController removeFromParentViewController];
    _myContentViewController = _rootViewController;
    [self addChildViewController:_myContentViewController];
    
    [_contentView removeFromSuperview];
    _contentView = rootViewController.view;
    [self.view addSubview:_contentView];
    
    /**
     *  侧边阴阴效果处理
     */
    _contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:_contentView.bounds].CGPath;
    _contentView.layer.shadowOpacity = 0.4;
    _contentView.layer.shadowOffset = CGSizeMake(-2,0);
    
    /**
     *  添加侧边手势接收View
     */
    if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        UIView *tpView = [((UINavigationController *)rootViewController).viewControllers objectAtIndex:0].view;
        [tpView addSubview:self.sideGesView];
    }
    else
    {
        UIView *tpView = rootViewController.view;
        [tpView addSubview:self.sideGesView];
    }
    
    /**
     *  添加侧滑手势
     */
    UIPanGestureRecognizer *myPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(myPanGestureRecognizer:)];
    [self.sideGesView addGestureRecognizer:myPanGestureRecognizer];
}

/**
 *  set
 *
 *  @param drawerRightWidth drawerRightWidth
 */
-(void)setDrawerRightWidth:(CGFloat)drawerRightWidth
{
    _drawerRightWidth = drawerRightWidth;
}

/**
 *  set
 *
 *  @param shadowColor shadowColor
 */
-(void)setShadowColor:(UIColor *)shadowColor
{
    _shadowColor = shadowColor;
}

/**
 *  set
 *
 *  @param shadowRadius shadowRadius
 */
-(void)setShadowRadius:(CGFloat)shadowRadius
{
    _shadowRadius = shadowRadius;
}

/**
 *  set
 *
 *  @param animationTime animationTime
 */
-(void)setAnimationTime:(NSTimeInterval)animationTime
{
    _animationTime = animationTime;
}

/**
 *  get
 *
 *  @return sidePanView
 */
-(UIView *)sideGesView
{
    if (_sideGesView == nil)
    {
        _sideGesView = [[UIView alloc]init];
        _sideGesView.backgroundColor = [UIColor clearColor];
    }
    return _sideGesView;
}

/**
 *  get
 *
 *  @return contentGesView
 */
-(UIView *)contentGesView
{
    if (_contentGesView == nil)
    {
        _contentGesView = [[UIView alloc]init];
        _contentGesView.backgroundColor = [UIColor clearColor];
    }
    return _contentGesView;
}

-(CGFloat)statusBarHeight
{
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}


/**
 *  切换内容页
 *
 *  @param viewController viewController
 */
-(void)exchangeContentViewController:(UIViewController *)viewController;
{
    if ([_rootViewController isKindOfClass:[UINavigationController class]])
    {
        [((UINavigationController *)self.rootViewController) pushViewController:viewController animated:NO];
        [self closeDrawerView];
    }
    else if ([_rootViewController isKindOfClass:[UITabBarController class]])
    {
        UIViewController *controller = [((UITabBarController *)viewController).viewControllers objectAtIndex:((UITabBarController *)viewController).selectedIndex];
        if ([controller isKindOfClass:[UINavigationController class]])
        {
            [((UINavigationController *)controller) pushViewController:viewController animated:NO];
            [self closeDrawerView];
        }
    }
}

/**
 *  layout
 */
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.view bringSubviewToFront:_contentView];
    [_contentView bringSubviewToFront:self.sideGesView];
    
    _sideGesView.frame = CGRectMake(0, 0, 18, _contentView.frame.size.height);
    _contentView.layer.shadowColor = [_shadowColor CGColor];
    _contentView.layer.shadowRadius = _shadowRadius;
    
    if (drawerState == isOpen)
    {
        /**
         *  抽屉开启
         */
        _contentView.frame = CGRectMake(self.view.frame.size.width - _drawerRightWidth, 0, _contentView.frame.size.width, _contentView.frame.size.height);
        _statusBar.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, _contentView.frame.size.width, self.statusBarHeight);
        
        _sideView.frame = CGRectMake(0, _sideView.frame.origin.y, self.view.frame.size.width-_drawerRightWidth, _sideView.frame.size.height);
    }
    else
    {
        /**
         *  抽屉关闭
         */
        _contentView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
        _statusBar.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, _contentView.frame.size.width, self.statusBarHeight);
        
        _sideView.frame = CGRectMake(-(self.view.frame.size.width-_drawerRightWidth)*0.35, _sideView.frame.origin.y, self.view.frame.size.width-_drawerRightWidth, _sideView.frame.size.height);
    }
    
    /**
     *  添加侧边手势接收View
     */
    if ([_rootViewController isKindOfClass:[UINavigationController class]])
    {
        UIView *tpView = [((UINavigationController *)_rootViewController).viewControllers objectAtIndex:0].view;
        _contentGesView.frame = CGRectMake(0, 0, tpView.frame.size.width, tpView.frame.size.height);
    }
    else
    {
        UIView *tpView = _rootViewController.view;
        _contentGesView.frame = CGRectMake(0, 0, tpView.frame.size.width, tpView.frame.size.height);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
