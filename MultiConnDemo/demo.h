


#import <UIKit/UIKit.h>

#import <MultipeerConnectivity/MultipeerConnectivity.h>



@interface demo : UIViewController <MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate>

@property (weak, nonatomic) IBOutlet UITextView *txtStatus;

@property (weak, nonatomic) IBOutlet UIButton *buttonCreate;

- (IBAction)refresh:(id)sender;

- (void)advertising;



@end

