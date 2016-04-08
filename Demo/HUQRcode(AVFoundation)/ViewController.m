//
//  ViewController.m
//  HUQRcode(AVFoundation)
//
//  Created by huweiya on 16/4/8.
//  Copyright © 2016年 bj_5i5j. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    QRCodeController *qr = [[QRCodeController alloc] init];
    
    [self.navigationController pushViewController:qr animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
