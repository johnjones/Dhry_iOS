#import "ViewController.h"
#import <libkern/OSAtomic.h>

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

-(IBAction) runPressed: (id)sender {
	if(!OSAtomicCompareAndSwapIntBarrier(0,1,&dhryRunning)) { return; }
	[self.nrunsField resignFirstResponder]; // hide keyboard
	self.runButton.enabled=NO;
	int n=[[self.nrunsField text] intValue];
	if(n>0) {
		NSNumber *nruns=[NSNumber numberWithInt:n];
		[NSThread detachNewThreadSelector:@selector(dhryThreadWithNRuns:) toTarget:self withObject:nruns];
	}
}

extern int dhrymain (long num_runs, char *buf, char *buf_end);
#define BUF_SZ 4096
-(void)dhryThreadWithNRuns: (NSNumber*)nruns; {
	@autoreleasepool {
		char resbuf[BUF_SZ];
		int n=[nruns intValue];
		[NSThread sleepForTimeInterval:.7]; // Wait for UI to settle
		dhrymain(n,resbuf,&resbuf[BUF_SZ]);
		NSString *res_str=[NSString stringWithCString:resbuf encoding:NSASCIIStringEncoding];
		dispatch_sync(dispatch_get_main_queue(), ^{
			[self.resView setText:res_str];
			[UIView setAnimationsEnabled:YES];
			[self.resView scrollRangeToVisible:NSMakeRange(self.resView.text.length-1, 1)];
			[UIView setAnimationsEnabled:NO];
			self.runButton.enabled=YES;
		});
		OSMemoryBarrier();
		dhryRunning=0;
	}
}
@end
