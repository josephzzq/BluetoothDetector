//
//  ViewController.m
//  BT_Prac
//
//  Created by Joseph.Tsai on 2016/3/23.
//  Copyright © 2016年 Joseph.Tsai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<CBCentralManagerDelegate>
{
    CBPeripheral *connectPeripheral;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.CM=[[CBCentralManager alloc]initWithDelegate:self queue:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)scanAndConnect:(id)sender {
    [self.CM stopScan];
    [self.CM scanForPeripheralsWithServices:nil options:nil];
}

- (IBAction)stopAndDisconnect:(id)sender {
    
    [self.CM stopScan];
    
    if (connectPeripheral==NULL) {
        NSLog(@"connectPeripheral==NULL");
        return;
    }
    
    if (connectPeripheral.state == CBPeripheralStateConnected) {
        [self.CM cancelPeripheralConnection:connectPeripheral];
        NSLog(@"disconnect-1");
    }
}

#pragma mark - CBCentralManager delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSMutableString *stateStr=[NSMutableString stringWithString:@"UpdateState:"];
    BOOL isWork=FALSE;
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            [stateStr appendString:@"Unknown\n"];
            break;
        case CBCentralManagerStateUnsupported:
            [stateStr appendString:@"Unsupported\n"];
            break;
        case CBCentralManagerStateUnauthorized:
            [stateStr appendString:@"Unauthorized\n"];
            break;
        case CBCentralManagerStatePoweredOff:
            [stateStr appendString:@"PowerOff\n"];
//            if (connectedPeripheral!=NULL){
//                [CM cancelPeripheralConnection:connectedPeripheral];
//            }
            break;
        case CBCentralManagerStatePoweredOn:
            [stateStr appendString:@"PowerOn\n"];
            isWork=TRUE;
            break;
        default:
            [stateStr appendString:@"none\n"];
            break;
    }
    NSLog(@"bluetooth %@",stateStr);
}

// press scan, 若有找到會跑來這個delegate
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSLog(@"peripheral %@\n",peripheral);
    NSLog(@"advertisementData %@\n",advertisementData);
    NSLog(@"RSSI %@\n",RSSI);
    
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    
    NSLog(@"localName:%@",localName);
    
    self.rssiLable.text=[NSString stringWithFormat:@"RSSI:%@",RSSI];
    self.localNameLabel.text=[NSString stringWithFormat:@"Name:%@",localName];
    
    //if ([peripheral.name length] && [peripheral.name rangeOfString:@"DannySimpleBLE"].location != NSNotFound) {
    if ([localName length] && [localName rangeOfString:@""].location != NSNotFound) {
        //抓到週邊後就立即停止 Scan
        [self.CM stopScan];
        NSLog(@"stopScan");
        connectPeripheral = peripheral;
        [self.CM connectPeripheral:peripheral options:nil];
        NSLog(@"connect to %@",peripheral.name);
    }
}


-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSLog(@"%@",@"connected");
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"%@",@"disconnect-2");
}


@end
