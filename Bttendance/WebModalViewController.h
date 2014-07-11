#import <UIKit/UIKit.h>

@interface WebModalViewController : UIViewController <UIWebViewDelegate> {
    UIActivityIndicatorView *activityIndicator;
    UILabel *titlelabel;
}
- (id)initWithURLString:(NSString *)URLString;

@property(strong, nonatomic) NSString *URLString;

@end
