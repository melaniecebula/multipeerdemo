


#import <UIKit/UIKit.h>

#import <MultipeerConnectivity/MultipeerConnectivity.h>



@interface demo : UIViewController <MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate>

@property (weak, nonatomic) IBOutlet UITextView *txtStatus;

@property (weak, nonatomic) IBOutlet UIButton *browseButton;

@property (weak, nonatomic) IBOutlet UIButton *advertiseButton;

@end

