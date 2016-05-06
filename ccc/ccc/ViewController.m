//
//  ViewController.m
//  ccc
//
//  Created by Czing on 15/10/26.
//  Copyright © 2015年 Czing. All rights reserved.
//

#import "ViewController.h"

#import "UIImageView+WebCache.h"
#import "MJRefresh.h"


#import "SocketIO.h"
#import "SocketIOPacket.h"
#import "SocketIOJSONSerialization.h"

#import <SocketRocket/SRWebSocket.h>


@interface ViewController ()<SocketIODelegate,SRWebSocketDelegate>

{
    SRWebSocket *_webSocket;
    NSMutableArray *_messages;

}


@property(nonatomic,strong)SocketIO *socketIO;
@property(nonatomic,strong)NSMutableArray *messages;




@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    
//    
    UIImageView *imaView = [[UIImageView alloc]init];
    imaView .frame = CGRectMake(100, 50, 200, 300);
    [self.view addSubview:imaView];
    
    
    NSURL *url = [NSURL URLWithString:@"http://images.china.cn/attachement/jpg/site1000/20151027/b8aeed99a01e1799608f21.jpg"];
    
    
    [imaView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default"] options:SDWebImageProgressiveDownload];
    
    UITextView * view =  [[UITextView alloc]initWithFrame:CGRectMake(150, 380, 80, 60)];
    view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:view];
//
//    _socketIO = [[SocketIO alloc] initWithDelegate:self];
//    [_socketIO connectToHost:@"ws://192.168.2.199:8080/echo" onPort:8080];
    
    UIButton *btn = [UIButton  buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(0, 380, 320, 200);
    [btn addTarget:self action:@selector(btn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
    [self _reconnect];
    
    
}
-(void)btn
{

    [_webSocket send:@"你好吗"];

}
//- (void) socketIODidConnect:(SocketIO *)socket
//{
//    NSLog(@"socket.io connected.");
//}
//
//-(void)sendMessageToWebSocket:(NSString *)str
//{
//    SocketIOCallback cb = ^(id argsData) {
//        NSDictionary *response = argsData;
//        // do something with response
//        NSLog(@"ack arrived: %@", response);
//    };
//    [_socketIO sendMessage:str withAcknowledge:cb];
//}
//
//
//
//
//- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
//{
//    NSLog(@"didReceiveEvent()");
//    NSString *receiveData=packet.data;
//    NSData *utf8Data = [receiveData dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *dictemp=(NSDictionary *)[SocketIOJSONSerialization objectFromJSONData:utf8Data error:nil];
//    NSDictionary *aadic=(NSDictionary *)[[dictemp objectForKey:@"args"] objectAtIndex:0];
//    NSString * temp = [aadic objectForKey:@"text"];
//    
//    NSLog(@"temp==%@",temp);
//    if (![temp isEqualToString:@"connectok"]) {
//        [self.messages addObject:temp];
//        
//        //        if((self.messages.count - 1) % 2)
//        //            [MessageSoundEffect playMessageSentSound];
//        //        else
//        //            [MessageSoundEffect playMessageReceivedSound];
//        //
//        //        [self finishSend];
//    }
//
//}
//
//- (void) socketIO:(SocketIO *)socket failedToConnectWithError:(NSError *)error
//{
//    NSLog(@"failedToConnectWithError() %@", error);
//}
//
//- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}




- (void)_reconnect;
{
    _webSocket.delegate = nil;
    [_webSocket close];
    
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://192.168.2.199:8080/echo"]]];
    _webSocket.delegate = self;
    
    //self.title = @"Opening Connection...";
    
   
    [_webSocket open];
    

    
}




- (void)reconnect:(id)sender;
{
    [self _reconnect];
}

- (void)sendPing:(id)sender;
{
    [_webSocket sendPing:nil];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    
  
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    _webSocket.delegate = nil;
    [_webSocket close];
    _webSocket = nil;
}



-(void)webSocketDidOpen:(SRWebSocket *)webSocket
{

   NSLog(@"Websocket Connected");

}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    self.title = @"Connection Failed! (see logs)";
    _webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"Received \"%@\"", message);
   
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    self.title = @"Connection Closed! (see logs)";
    _webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload;
{
    NSLog(@"Websocket received pong");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
