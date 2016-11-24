//
//  NetworkingIndicator.m
//  Networking
//
//  Created by mike on 17/11/2016.
//  Copyright © 2016 mike. All rights reserved.
//

#import "NetworkingIndicator.h"
#import <UIKit+AFNetworking.h>
@implementation NetworkingIndicator

+ (void)showNetworkActivityIndicator:(BOOL)show {
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:show];
}


@end
