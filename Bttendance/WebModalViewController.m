#import "WebModalViewController.h"
#import "BTColor.h"

@interface WebModalViewController ()

@end

@implementation WebModalViewController

@synthesize URLString = URLString_;

- (id)initWithURLString:(NSString *)URLString; {
    self = [super init];
    if (self) {
        self.URLString = URLString;
        activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        backButton.titleLabel.text = NSLocalizedString(@"Close", nil);
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setRightBarButtonItem:backButtonItem];
        self.navigationItem.leftItemsSupplementBackButton = NO;
    }
    return self;
}

- (void)back:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)loadView {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    UIWebView *webView = (UIWebView *)self.view;
    [webView setScalesPageToFit:YES];
    webView.delegate = self;
    [webView setBackgroundColor:[BTColor BT_grey:1]];
    [webView setOpaque:NO];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]]];
    
    titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Bttendance", @"Service name Bttendance");
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [self showNavigation];
}

- (void)showNavigation {
    //Navigation showing
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark UIWebViewDelegate callbacks

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicator stopAnimating];
    titlelabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
