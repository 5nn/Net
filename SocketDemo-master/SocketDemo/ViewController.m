//
//  ViewController.m
//  SocketDemo
//
//  Created by mike on 14/11/2016.
//  Copyright © 2016 mike. All rights reserved.
//

#import "ViewController.h"
#import <SocketRocket.h>
#import <Masonry.h>
#import "UIColor+HEX.h"
@interface ViewController ()<SRWebSocketDelegate>

@property (nonatomic, strong) SRWebSocket *webSocket;

@property (nonatomic, strong) UIButton *connectButton;
@property (nonatomic, strong) UIButton *sendMessage;
@property (nonatomic, strong) UIButton *statusButton;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation ViewController

#pragma mark view cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.connectButton];
    [self.view addSubview:self.sendMessage];
    [self.view addSubview:self.statusButton];
    [self.view addSubview:self.closeButton];
 
    [self layoutSubButtonView];
    
       
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.webSocket close];//关闭连接
    self.webSocket = nil;
    
}


- (void)dealloc{
 
    
    
}

#pragma layoutSubButtonView
- (void)layoutSubButtonView{
    __weak typeof(self) weakSelf = self;
    
    
    [self.connectButton  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.view.mas_centerY);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(50);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    [self.statusButton  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.connectButton.mas_bottom).with.offset(10);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(50);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    
    [self.sendMessage  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.statusButton.mas_bottom).with.offset(10);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(50);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    
    [self.closeButton  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.sendMessage.mas_bottom).with.offset(10);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(50);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    
    
    
    
}



#pragma mark rewrite getter and setter
/**
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 
 该方法放入appdelegate里面就可以造成一个长连接，(as long as your application is alive)
 
 */
- (SRWebSocket *)webSocket{
    if (!_webSocket) {
        
        _webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:@"wss://echo.websocket.org"]];
        _webSocket.delegate = self;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); // 获得全局并发队列;
        [_webSocket setDelegateDispatchQueue:queue];
        
      }
    return  _webSocket;
}




- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.backgroundColor = [UIColor orangeColor];
        [_closeButton setTitle:@"close" forState:UIControlStateNormal];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _closeButton.showsTouchWhenHighlighted = YES;
        
        [_closeButton addTarget:self action:@selector(closeButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;

}
- (UIButton *)statusButton{
    if (!_statusButton) {
        _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _statusButton.backgroundColor = [UIColor orangeColor];
        [_statusButton setTitle:@"status" forState:UIControlStateNormal];
        [_statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _statusButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _statusButton.showsTouchWhenHighlighted = YES;
        
        [_statusButton addTarget:self action:@selector(statusButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _statusButton;
    
}

- (UIButton *)sendMessage{
    if (!_sendMessage) {
        _sendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendMessage.backgroundColor = [UIColor orangeColor];
        [_sendMessage setTitle:@"sendMessage" forState:UIControlStateNormal];
        [_sendMessage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendMessage.titleLabel.font = [UIFont systemFontOfSize:13];
        _sendMessage.showsTouchWhenHighlighted = YES;
        
        [_sendMessage addTarget:self action:@selector(sendMessageEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendMessage;

}
- (UIButton *)connectButton{
    if (!_connectButton) {
        _connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _connectButton.backgroundColor = [UIColor orangeColor];
        [_connectButton setTitle:@"connect" forState:UIControlStateNormal];
        [_connectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _connectButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _connectButton.showsTouchWhenHighlighted = YES;
        
        [_connectButton addTarget:self action:@selector(connectEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _connectButton;
}




#pragma mark  -button Event

- (void)closeButtonEvent{
    if (self.webSocket) {
       
         [self.webSocket close];
        self.webSocket = nil;
       
    
    }
}

- (void)statusButtonEvent{

    if (self.webSocket) {
        switch (self.webSocket.readyState) {
            case SR_CONNECTING:
                NSLog(@"--connecting");
                break;
            case  SR_OPEN:
                NSLog(@"--open");
                break;
            case SR_CLOSING:
                NSLog(@"--closing");
                break;
            default:
                NSLog(@"--closed");
                break;
        }
    }
}

- (void)sendMessageEvent{
    if (self.webSocket.readyState == SR_OPEN) {
        int x = arc4random() % 100;
        NSString *str = [NSString stringWithFormat:@"sendMessage:%d",x];
        [self.webSocket send:str];
    }
}

- (void)connectEvent{
    
    if (self.webSocket.readyState == SR_CONNECTING) {
        NSLog(@"open or connecting");
            [self.webSocket open];
    }else if(self.webSocket.readyState == SR_CLOSING){
        NSLog(@"sr_closing");

    }if (self.webSocket.readyState == SR_CLOSED) {
         self.webSocket = nil;
      
        [self.webSocket open];
    }else{
        //
    }
}


#pragma mark -webSocket delegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSString *str = (NSString *)message;
    NSLog(@"message:%@",str);
}



- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    
    
    if (webSocket.readyState ==  SR_OPEN) {
        [webSocket send:@"123456789"];
    }

}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@"连接错误");
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"reson:%@",reason);
}
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    
}

// Return YES to convert messages sent as Text to an NSString. Return NO to skip NSData -> NSString conversion for Text messages. Defaults to YES.
- (BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket{
    return YES;
}
@end
