

//

//  ViewController.m

//  p2p

//

//  Created by Antonio González Artime on 13/06/13.

//  Copyright (c) 2013 Antonio González Artime. All rights reserved.

#import "demo.h"


@interface demo ()
{
    
}

@property (strong, nonatomic) MCSession * session;

@property (strong, nonatomic) MCPeerID * myPeerId;

@property (strong, nonatomic) MCNearbyServiceBrowser *browser;

@property (strong, nonatomic) MCNearbyServiceAdvertiser * advertiser;

@end


@implementation demo


- (void)viewDidLoad

{
    [super viewDidLoad];
    
    _advertiseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_advertiseButton addTarget:self
               action:@selector(aMethod:)
     forControlEvents:UIControlEventTouchDown];
    [_advertiseButton setTitle:@"advertise" forState:UIControlStateNormal];
    _advertiseButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:_advertiseButton];
    
    _browseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_browseButton addTarget:self action:@selector(bMethod:) forControlEvents:UIControlStateNormal];
    [_browseButton setTitle:@"browse" forState:UIControlStateNormal];
    _browseButton.frame = CGRectMake(180.0, 210.0, 160.0, 40.0);
    [self.view addSubview:_browseButton];

    // Do any additional setup after loading the view, typically from a nib.
    
    NSUUID * uuid = [NSUUID UUID];
    
    self.myPeerId = [[MCPeerID alloc] initWithDisplayName:[uuid UUIDString]];
    
    NSString *serviceType=@"p2ptest";
    
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.myPeerId serviceType:serviceType];
    
    self.browser.delegate=self;
    
    
    self.session = [[MCSession alloc] initWithPeer:self.myPeerId securityIdentity:nil encryptionPreference:MCEncryptionNone];
    
    self.session.delegate = self;
    
    
    //[self.browser startBrowsingForPeers];
    
    //[self advertising];
}

- (void)aMethod:(id)selector {
    NSLog(@"a method");
    [self advertising];
}

- (void)bMethod:(id)sender {
    NSLog(@"b method");
    [self.browser startBrowsingForPeers];
}


- (void)didReceiveMemoryWarning

{
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}


- (void)advertising{
    
    NSLog(@"ViewController :: launch (Starting Advertise)");
    
    NSDictionary * discoveryInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"foo", @"bar", @"bar", @"foo", nil];
    
    self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.myPeerId discoveryInfo:discoveryInfo serviceType:@"p2ptest"];
    
    self.advertiser.delegate = self;
    
    [self.advertiser startAdvertisingPeer];
    
}

#pragma mark - MCSessionDelegate

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
    NSLog(@"MCSessionDelegate :: didReceiveData :: Received %@ from %@",[data description],peerID);
    
    NSString * message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Received Message" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alert show];
    
}

- (void)session:(MCSession *)session didReceiveResourceAtURL:(NSURL *)resourceURL fromPeer:(MCPeerID *)peerID {
    
    NSLog(@"MCSessionDelegate :: didReceiveResourceAtURL :: Received Resource %@ from %@",[resourceURL description],peerID);
    
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
    NSLog(@"MCSessionDelegate :: didReceiveStream :: Received Stream %@ from %@",[stream description],peerID);
    
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    
    NSLog(@"MCSessionDelegate :: didChangeState :: PeerId %@ changed to state %d",peerID,state);
    
    if (state == MCSessionStateConnected && self.session) {
        
        NSError *error;
        [self.session sendData:[@"UNRELIABLE MESSAGE" dataUsingEncoding:NSUTF8StringEncoding] toPeers:[NSArray arrayWithObject:peerID] withMode:MCSessionSendDataUnreliable error:&error];
        
        [self.session sendData:[@"RELIABLE MESSAGE" dataUsingEncoding:NSUTF8StringEncoding] toPeers:[NSArray arrayWithObject:peerID] withMode:MCSessionSendDataReliable error:&error];
        
    }
    
}

- (BOOL)session:(MCSession *)session shouldAcceptCertificate:(SecCertificateRef)peerCert forPeer:(MCPeerID *)peerID {
    
    NSLog(@"MCPickerViewControllerDelegate :: shouldAcceptCertificate from peerID :: %@",peerID);
    
    return TRUE;
    
}


#pragma mark - MCNearbyServiceAdvertiserDelegate

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error {
    
    NSLog(@"MCNearbyServiceAdvertiserDelegate :: didNotStartAdvertisingPeer :: %@",error);
    
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler {
    
    NSLog(@"MCNearbyServiceAdvertiserDelegate :: didReceiveInvitationFromPeer :: peerId :: %@",peerID);
    
    invitationHandler(TRUE,self.session);
    
}

#pragma mark - MCNearbyServiceBrowserDelegate

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error {
    
    NSLog(@"MCNearbyServiceABrowserDelegate :: didNotStartBrowsingForPeers :: error :: %@",error);
    
    
}

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    
    NSLog(@"MCNearbyServiceABrowserDelegate :: foundPeer :: PeerID : %@ :: DiscoveryInfo : %@",peerID,info.description);
    
    NSLog(@"Creamos sesión automáticamente");
    
    [self.browser invitePeer:peerID toSession:self.session withContext:[@"HOLA TIO" dataUsingEncoding:NSUTF8StringEncoding] timeout:10];
    
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    
    NSLog(@"MCNearbyServiceABrowserDelegate :: lostPeer :: PeerID : %@",peerID);
    
}

@end
