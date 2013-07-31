//
//  MultiConnDemoViewController.m
//  MultiConnDemo
//
//  Created by Melanie Cebula on 7/30/13.
//  Copyright (c) 2013 Melanie Cebula. All rights reserved.
//

#import "MultiConnDemoViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@interface MultiConnDemoViewController ()

@property (nonatomic, strong) MCSession *session;
@end

@implementation MultiConnDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    MCPeerID *myPeerID = [[MCPeerID alloc] initWithDisplayName:@"Melanie"];
    _session = [[MCSession alloc] initWithPeer:myPeerID];
    _session.delegate = self;
    
    MCAdvertiserAssistant *assistant = [[MCAdvertiserAssistant alloc] initWithServiceType:@"MCdemo" discoveryInfo:nil session:_session];
    [assistant start];
    
    //messages
    NSArray *peerIDs = [_session connectedPeers];
    [_session sendData:[NSData data] toPeers:peerIDs withMode:MCSessionSendDataUnreliable error:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    MCBrowserViewController *browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"MCdemo" session:_session];
    browserVC.delegate = self;
    [self presentViewController:browserVC animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MCBrowserViewControllerDelegate??

- (void)browserViewControllerDidFinish: (MCBrowserViewController *)browserVC {
    [browserVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSLog(@"session peer didchangestate");
    NSLog(@"%d", state);
}


@end
