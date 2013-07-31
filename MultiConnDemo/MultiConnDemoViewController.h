//
//  MultiConnDemoViewController.h
//  MultiConnDemo
//
//  Created by Melanie Cebula on 7/30/13.
//  Copyright (c) 2013 Melanie Cebula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MultiConnDemoViewController : UIViewController <MCAdvertiserAssistantDelegate, MCBrowserViewControllerDelegate, MCSessionDelegate>

@end
