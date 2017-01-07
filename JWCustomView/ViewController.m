//
//  ViewController.m
//  JWCustomView
//
//  Created by huangjw on 2017/1/7.
//  Copyright © 2017年 huangjw. All rights reserved.
//

#import "ViewController.h"
#import "JWActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showActionSheet:(id)sender {
    JWActionSheet *action = [[JWActionSheet alloc] initWithTitle:nil];
    [action addButtonWithTitle:@"first" type:ActionSheetButtonTypeDefault handler:^(JWActionSheet *sheet) {
        NSLog(@"first");
    }];
    [action show];
}

@end
