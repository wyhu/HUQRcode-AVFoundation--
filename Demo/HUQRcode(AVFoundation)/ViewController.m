//
//  ViewController.m
//  HUQRcode(AVFoundation)
//
//  Created by huweiya on 16/4/8.
//  Copyright © 2016年 bj_5i5j. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeController.h"
#import "PressQRViewController.h"
@interface ViewController ()

@property(nonatomic, strong) NSArray *titleArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
}

- (NSArray *)titleArr
{
    if (!_titleArr) {
        return @[@"扫描二维码",@"长按识别二维码"];
    }
    return _titleArr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.textLabel.text = self.titleArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //单元格点击
    if (indexPath.row == 0) {
        
        QRCodeController *qr = [[QRCodeController alloc] init];
        
        [self presentViewController:qr animated:YES completion:nil];
        
    }
    
    if (indexPath.row == 1) {
        PressQRViewController *pressQR = [[PressQRViewController alloc] init];
        [self.navigationController pushViewController:pressQR animated:YES];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
