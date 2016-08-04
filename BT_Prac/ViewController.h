//
//  ViewController.h
//  BT_Prac
//
//  Created by Joseph.Tsai on 2016/3/23.
//  Copyright © 2016年 Joseph.Tsai. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreBluetooth;
@import QuartzCore;

@interface ViewController : UIViewController
@property (strong,nonatomic)CBCentralManager *CM;
@property (weak, nonatomic) IBOutlet UILabel *rssiLable;
@property (weak, nonatomic) IBOutlet UILabel *localNameLabel;

@end

