//
//  PingServerResult.m
//  STPingTest
//
//  Created by 新国都 on 2018/6/21.
//  Copyright © 2018年 Suen. All rights reserved.
//

#import "PingServerResult.h"
#import "STDebugFoundation.h"
#import "STDPingServices.h"

@interface PingServerResult ()

@property(nonatomic, strong) STDPingServices    *pingServices;
@property(nonatomic, assign) CGFloat            allTime; //ping的次数的所有时间
@property(nonatomic, assign) NSInteger          timeCount; //ping的次数
@property(nonatomic, assign) NSInteger          failureCount; //失败的次数

@end

@implementation PingServerResult

-(void)startPingWithUrl:(NSString*)url result:(void(^)(NSString* average,NSInteger failure))block
{
   //似乎要导入这个库 libz.1.2.5
   self.timeCount = 0;
    __weak PingServerResult *weakSelf = self;
   self.pingServices = [STDPingServices startPingAddress:url callbackHandler:^(STDPingItem *pingItem, NSArray *pingItems) {
        if (pingItem.status != STDPingStatusFinished) {
            NSLog(@"ping的时间=%.2f",pingItem.timeMilliseconds);
            if (pingItem.timeMilliseconds >0) {
                self.timeCount ++;
            }
            
            weakSelf.allTime += pingItem.timeMilliseconds;
            if ((weakSelf.timeCount + weakSelf.failureCount) == 10) {
                NSString * ave = [NSString stringWithFormat:@"%.2f",weakSelf.allTime/self.timeCount];
                NSLog(@"10次平均ping耗时 = %@",ave);
                block(ave,weakSelf.failureCount);
                [weakSelf stopPing];
            }
         
            
        } else if(pingItem.status == STDPingStatusDidTimeout){
            
            weakSelf.failureCount ++;
        }else if(pingItem.status == STDPingStatusError) {
            
            weakSelf.failureCount ++;
        }else{
            
            weakSelf.pingServices = nil;
        }
    }];
}

-(void)stopPing
{
    [self.pingServices cancel];
    self.pingServices = nil;
    self.allTime = 0;
    self.timeCount = 0;
    self.failureCount = 0;
}
@end
