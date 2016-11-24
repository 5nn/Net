//
//  NetworkingIndicator.h
//  Networking
//
//  Created by mike on 17/11/2016.
//  Copyright © 2016 mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkingIndicator : NSObject

/**
 *  是否显示网络加载指示器
 *
 *  @param show 是否显示
 */
+ (void)showNetworkActivityIndicator:(BOOL)show;

@end
