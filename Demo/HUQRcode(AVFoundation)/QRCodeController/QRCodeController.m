//
//  QRCodeController.m
//  eCarry
//  依赖于AVFoundation
//  Created by whde on 15/8/14.
//  Copyright (c) 2015年 Joybon. All rights reserved.
//

#import "QRCodeController.h"
#import <AVFoundation/AVFoundation.h>

#define  ScreenHeight  [UIScreen mainScreen].bounds.size.height
#define  ScreenWidth   [UIScreen mainScreen].bounds.size.width
@interface QRCodeController ()
<AVCaptureMetadataOutputObjectsDelegate>
// 用于处理采集信息的代理

{
    AVCaptureSession * session;//输入输出的中间桥梁
    AVCaptureDevice * device;//注册一个硬件设备
    int line_tag;
}


@end

@implementation QRCodeController

/**
 *  @author Whde
 *
 *  viewDidLoad
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = @"二维码扫描";
    [self instanceDevice];
    
    
//    [self initNav];
    
    
    line_tag = 1872637;

}




- (void)initNav{
    
    
    UIBarButtonItem *rightI = [[UIBarButtonItem alloc] initWithTitle:@"停止扫描" style:UIBarButtonItemStylePlain target:self action:@selector(stopSc)];
    self.navigationItem.rightBarButtonItem = rightI;
    
}

- (void)stopSc{
    
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"停止扫描"]) {
        self.navigationItem.rightBarButtonItem.title = @"开始扫描";
        
        [session stopRunning];
        
        
    }else{
        self.navigationItem.rightBarButtonItem.title = @"停止扫描";
        
        [session startRunning];
    }
    
    
}

/**
 *  @author Whde
 *
 *  配置相机属性
 */
#pragma mark  配置相机属性
- (void)instanceDevice{
    
    
    //获取摄像设备
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置扫描范围
    [output setRectOfInterest:CGRectMake(160 / ScreenHeight, 75 / ScreenWidth, (ScreenWidth-150) / ScreenHeight, (ScreenWidth-150) / ScreenWidth)];
    
    
//    这个CGRect参数和普通的Rect范围不太一样，它的四个值的范围都是0-1，表示比例。
//    rectOfInterest都是按照横屏来计算的 所以当竖屏的情况下 x轴和y轴要交换一下。
//    宽度和高度设置的情况也是类似。
    
    
    
    //初始化链接对象
    session = [[AVCaptureSession alloc] init];
    
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    
    if (input) {
        [session addInput:input];
    }
    
    if (output) {
        [session addOutput:output];
        
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *a = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes=a;
    }
    
    // 实例化预览图层
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    
    layer.frame=self.view.layer.bounds;
    
    layer.borderWidth = 3;
    layer.borderColor = [UIColor redColor].CGColor;
    
    [self.view.layer insertSublayer:layer atIndex:0];
    
    //监听中间设备
    [session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:nil];
    
    //处理界面
    [self setOverlayPickerView];
    
    
    //开始扫描
    [session startRunning];
    
}

/**
 *  @author Whde
 *
 *  监听扫码状态-修改扫描动画
 *
 *  @param keyPath
 *  @param object
 *  @param change
 *  @param context
 */
#pragma mark *  监听扫码状态-修改扫描动画

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if ([object isKindOfClass:[AVCaptureSession class]]) {
        BOOL isRunning = ((AVCaptureSession *)object).isRunning;
        if (isRunning) {
            [self addAnimation];
        }else{
            [self removeAnimation];
        }
    }
}

/**
 *  @author Whde
 *
 *  获取扫码结果
 *
 *  @param captureOutput
 *  @param metadataObjects
 *  @param connection
 */
#pragma mark 获取扫码结果
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    
    if (metadataObjects.count>0) {
        //获取数据成功
        //停止扫面
        [session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex :0];
        
        //输出扫描字符串
        NSString *data = metadataObject.stringValue;

        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"结果如下" message:data preferredStyle:UIAlertControllerStyleAlert];
   
        UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self dismissOverlayView:nil];
        }];
        UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissOverlayView:nil];

        }];
        UIAlertAction *a3 = [UIAlertAction actionWithTitle:@"重新扫描" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [session startRunning];
        }];
        
        [alertC addAction:a1];
        [alertC addAction:a2];
        [alertC addAction:a3];

        
        [self presentViewController:alertC animated:YES completion:nil];
    }else{
        //获取数据失败
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    
    [self dismissOverlayView:nil];
}

/**
 *  @author Whde
 *
 *  didReceiveMemoryWarning
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  @author Whde
 *
 *  创建扫码页面
 */
#pragma  mark 创建扫码页面
- (void)setOverlayPickerView
{
    //扫描框
    UIImageView *centerView = [[UIImageView alloc] initWithFrame:CGRectMake(75, 160, ScreenWidth-150, ScreenWidth-150)];
    
    centerView.image = [UIImage imageNamed:@"扫描框.png"];
    centerView.contentMode = UIViewContentModeScaleAspectFit;
    centerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:centerView];
    
    //扫描线
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(75, 160, ScreenWidth-150, 2)];
    line.tag = line_tag;
    line.image = [UIImage imageNamed:@"扫描线.png"];
    line.contentMode = UIViewContentModeScaleAspectFill;
    line.backgroundColor = [UIColor clearColor];
    [self.view addSubview:line];
    
    
    //提示label
    UILabel *tiShiLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, ScreenWidth + 50, ScreenWidth-60, 60)];
    tiShiLabel.backgroundColor = [UIColor clearColor];
    tiShiLabel.textColor = [UIColor whiteColor];
    tiShiLabel.textAlignment = NSTextAlignmentCenter;
    tiShiLabel.font = [UIFont systemFontOfSize:16];
    tiShiLabel.text = @"将二维码放入框内,即可自动扫描";
    [self.view addSubview:tiShiLabel];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 40, 40)];
    [backBtn addTarget:self action:@selector(dismissOverlayView:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"白色返回_想去"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    
    
    
    //闪关灯按钮
    UIButton *lightBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 30, 180, 40)];
    [lightBtn setTitle:@"打开闪光灯" forState:UIControlStateNormal];
    [lightBtn setTitle:@"关闭闪光灯" forState:UIControlStateSelected];
    [lightBtn addTarget:self action:@selector(switchLight:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lightBtn];
    
}


#pragma mark 打开手电筒/闪光灯
- (void)switchLight:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [self openFlashlight];
}


-(void)openFlashlight
{
    
    if (device.torchMode == AVCaptureTorchModeOff) {
        
        // Start session configuration
        [session beginConfiguration];
        [device lockForConfiguration:nil];
        
        // Set torch to on
        [device setTorchMode:AVCaptureTorchModeOn];
        [device unlockForConfiguration];
        [session commitConfiguration];
        
        //填上这一句改为闪光灯
        //        [session startRunning];
    }else{
        [device lockForConfiguration:nil];
        // Set torch to off
        [device setTorchMode:AVCaptureTorchModeOff];
        [device unlockForConfiguration];
        
    }
}


/**
 *  @author Whde
 *
 *  添加扫码动画
 */
#pragma mark  添加/去除扫码动画
- (void)addAnimation{
    UIView *line = [self.view viewWithTag:line_tag];
    line.hidden = NO;
    CABasicAnimation *animation = [QRCodeController moveYTime:2 fromY:[NSNumber numberWithFloat:0] toY:[NSNumber numberWithFloat:ScreenWidth-150] rep:OPEN_MAX];
    [line.layer addAnimation:animation forKey:@"LineAnimation"];
    
}

+ (CABasicAnimation *)moveYTime:(float)time fromY:(NSNumber *)fromY toY:(NSNumber *)toY rep:(int)rep
{
    CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationMove setFromValue:fromY];
    [animationMove setToValue:toY];
    animationMove.duration = time;
    animationMove.repeatCount  = rep;
    animationMove.fillMode = kCAFillModeForwards;
    animationMove.removedOnCompletion = NO;
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animationMove;
}


/**
 *  @author Whde
 *
 *  去除扫码动画
 */
- (void)removeAnimation{
    UIView *line = [self.view viewWithTag:line_tag];
    [line.layer removeAnimationForKey:@"LineAnimation"];
    line.hidden = YES;
}

/**
 *  @author Whde
 *
 *  扫码取消button方法
 *
 *  @return
 */
#pragma mark 退出扫码模式
- (void)dismissOverlayView:(id)sender{

    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self selfRemoveFromSuperview];
}

/**
 *  @author Whde
 *
 *  从父视图中移出
 */
- (void)selfRemoveFromSuperview{
    [session removeObserver:self forKeyPath:@"running" context:nil];
    [session stopRunning];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}


@end
