//
//  NetworkingReachability.m
//  Networking
//
//  Created by mike on 17/11/2016.
//  Copyright © 2016 mike. All rights reserved.
//

#import "NetworkingReachability.h"
#import <AFNetworking.h>
NSString *const NetworkingReachableViaWWANNotification = @"NetworkingReachableViaWWAN";
NSString *const NetworkingReachableViaWIFINotification = @"NetworkingReachableViaWIFI";
NSString *const NetworkingNotReachableNotification     = @"NetworkingNotReachable";


/**
 *  用于测试网络是否可以连接的基准URL地址
 */
static NSString *reachabeBaseURL = @"http://baidu.com/";
static BOOL     _canSendMessage  = YES;
@implementation NetworkingReachability

+ (void)initialize {
    
    if (self == [NetworkingReachability class]) {
        
        [AFNetworkReachabilityManager managerForAddress:(__bridge const void * _Nonnull)(reachabeBaseURL)];
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            switch (status) {
                    
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    
                    if (_canSendMessage == YES) {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkingReachableViaWWANNotification
                                                                            object:nil
                                                                          userInfo:nil];
                    }
                    
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    
                    if (_canSendMessage == YES) {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkingReachableViaWIFINotification
                                                                            object:nil
                                                                          userInfo:nil];
                    }
                    
                    break;
                    
                case AFNetworkReachabilityStatusNotReachable:
                default:
                    
                    if (_canSendMessage == YES) {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:NetworkingNotReachableNotification
                                                                            object:nil
                                                                          userInfo:nil];
                    }
                    
                    break;
            }
        }];
    }
}

+ (void)startMonitoring {
    
    _canSendMessage = YES;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)stopMonitoring {
    
    _canSendMessage = NO;
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

+ (BOOL)isReachable {
    
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

+ (BOOL)isReachableViaWWAN {
    
    return [AFNetworkReachabilityManager sharedManager].isReachableViaWWAN;
}

+ (BOOL)isReachableViaWiFi {
    
    return [AFNetworkReachabilityManager sharedManager].isReachableViaWiFi;
}



@end
