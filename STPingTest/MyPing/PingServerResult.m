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

-(void)startPingResult:(void(^)(NSString* average,NSInteger failure))block
{
   self.timeCount = 10;
   self.pingServices = [STDPingServices startPingAddress:self.hostUrl callbackHandler:^(STDPingItem *pingItem, NSArray *pingItems) {
        if (pingItem.status != STDPingStatusFinished) {
            NSLog(@"ping的时间=%.2f",pingItem.timeMilliseconds);
            self.timeCount ++;
            self.allTime += pingItem.timeMilliseconds;
            if ((self.timeCount+self.failureCount) == 9) {
                NSString * ave = [NSString stringWithFormat:@"%.2f",self.allTime/self.timeCount];
                NSLog(@"10次平均ping耗时 = %@",ave);
                block(ave,self.failureCount);
                [self stopPing];
            }
         
            
        } else if(pingItem.status == STDPingStatusDidTimeout){
            self.failureCount ++;
        }else if(pingItem.status == STDPingStatusError) {
            self.failureCount ++;
        }else
        {
            
            self.pingServices = nil;
        }
    }];
}

-(void)stopPing
{
    [self.pingServices cancel];
    self.allTime = 0;
    self.timeCount = 0;
    self.failureCount = 0;
}
@end
