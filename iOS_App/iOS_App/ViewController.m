//
//  ViewController.m
//  iOS_App
//
//  Created by Tiny on 2020/4/12.
//  Copyright © 2020 Tiny. All rights reserved.
//

#import "ViewController.h"
#import <Flutter/Flutter.h>

@interface ViewController ()

@property (nonatomic, strong) FlutterViewController *flutterViewController;

@property (nonatomic, strong) FlutterMethodChannel *methodChannel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Flutter与iOS交互";
    UIButton *button = [UIButton new];
    button.frame = CGRectMake(100, 200, 200, 30);
    [button setTitle:@"点击打开Flutter" forState:UIControlStateNormal];
    [button setBackgroundColor:UIColor.grayColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(itemClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton new];
    [button2 setTitle:@"点击向Flutter发送消息" forState:UIControlStateNormal];
    [button2 setBackgroundColor:UIColor.grayColor];
    
    button2.frame = CGRectMake(100, 300, 200, 30);
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(itemClickx) forControlEvents:UIControlEventTouchUpInside];
}

-(void)itemClickx{
    //发消息给flutter
    [self.methodChannel invokeMethod:@"MSGChannel" arguments:@"我是iOS发送过来的消息"];
}

-(void)itemClick{
    [self openFlutterViewController];
}

-(void)openFlutterViewController{
    //初始化FlutterViewController
    self.flutterViewController = [[FlutterViewController alloc] init];
    //为FlutterViewController指定路由以及路由携带的参数
    [self.flutterViewController setInitialRoute:@"{\"msg\":\"我是iOS传入的指令\"}"];
    //设置模态跳转满屏显示
    self.flutterViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:self.flutterViewController animated:YES completion:nil];
    
    //创建MethodChannel消息
    FlutterMethodChannel *methodChannel = [FlutterMethodChannel methodChannelWithName:@"MSGChannel" binaryMessenger:self.flutterViewController.binaryMessenger];
    
    //给
    self.methodChannel = methodChannel;
    
    //监听返回
    __weak typeof(self) weakself = self;
    [methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        __strong typeof(weakself) strongself = weakself;
        //dissmiss当前页面
        if([call.method isEqualToString:@"dismiss"]){
            [strongself dismissViewControllerAnimated:YES completion:nil];
        }
        if (result) {
            result(@"成功关闭页面");
        }
    }];
}


@end

