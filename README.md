# HUQRcode-AVFoundation--
首次上传
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    QRCodeController *qr = [[QRCodeController alloc] init];
    
    [self.navigationController pushViewController:qr animated:YES];
}

