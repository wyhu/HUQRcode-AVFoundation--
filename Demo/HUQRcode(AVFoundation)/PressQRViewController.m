//
//  PressQRViewController.m
//  HUQRcode(AVFoundation)
//
//  Created by huweiya on 2017/5/3.
//  Copyright © 2017年 bj_5i5j. All rights reserved.
//

#import "PressQRViewController.h"

#define  ScreenHeight  [UIScreen mainScreen].bounds.size.height
#define  ScreenWidth   [UIScreen mainScreen].bounds.size.width
@interface PressQRViewController ()

@end

@implementation PressQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"长按识别二维码";
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth - 100, ScreenWidth - 100)];
    imageView.center = self.view.center;
    imageView.image = [UIImage imageNamed:@"testQR.png"];
    [self.view addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longP.minimumPressDuration = 1.0;

    
    [imageView addGestureRecognizer:longP];
}


- (void)longPress:(UILongPressGestureRecognizer *)sender{
    
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        
        //1.获取选择的图片
        UIImage *image = [UIImage imageNamed:@"testQR.png"];
        //2.初始化一个监测器
        CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
        
        //监测到的结果数组
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count >=1) {
            /**结果对象 */
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:scannedResult delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
        else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该图片没有包含一个二维码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
        
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
