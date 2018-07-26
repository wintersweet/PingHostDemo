//
//  PingServerResult.h
//  STPingTest
//
//  Created by 新国都 on 2018/6/21.
//  Copyright © 2018年 Suen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PingServerResult : NSObject

@property(nonatomic,strong)NSString* hostUrl;

-(void)startPingWithUrl:(NSString*)url
                 result:(void(^)(NSString* average,NSInteger failure))block;
-(void)stopPing;
@end
