#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
	int dhryRunning;
}

- (IBAction) runPressed: (id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nrunsField;
@property (weak, nonatomic) IBOutlet UITextView *resView;
@property (weak, nonatomic) IBOutlet UIButton *runButton;
-(void)dhryThreadWithNRuns:(NSNumber*)nruns;

@end

