//
//  ISViewController.m
//  ImageSlicer
//
//  Created by Markus on 26.10.13.
//  Copyright (c) 2013 nxtbgthng. All rights reserved.
//

#import "NSFileManager+DesktopPath.h"

#import "ISViewController.h"

@interface ISViewController ()
@property (nonatomic,strong) UIProgressView *progressView;
@end

@implementation ISViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"ImageSlicer";
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Start"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(startAction:)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = CGRectInset(self.view.bounds, 40, 40);
    frame.origin.y = 100.0;
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = frame;
    [self.view addSubview:self.progressView];
}

- (void)startAction:(UIBarButtonItem*)sender;
{
    sender.enabled = NO;
    
    // get source images
    NSArray *images = @[[UIImage imageNamed:@"01.jpg"],
                        [UIImage imageNamed:@"02.jpg"],
                        [UIImage imageNamed:@"03.jpg"],
                        [UIImage imageNamed:@"04.jpg"]];
    
    // create new image & save
    __weak typeof(self) blockSelf = self;
    [self imageFromSourceImages:images
                    stripeWidth:3
                        pattern:@[@(0),@(1),@(2),@(1),@(0),@(3)]
                       progress:^(CGFloat progress){
                           // handle progress
                           blockSelf.progressView.progress = progress;
                       }
                     completion:^(UIImage *resultImage){
                         // save image
                         if(resultImage) {
                             NSString *path = [[NSFileManager defaultManager] desktopPathForDirectory:@"ImageSlicer-Results"];
                             path = [path stringByAppendingPathComponent:@"SlicedImage.jpg"];
                             NSData *imageData = UIImageJPEGRepresentation(resultImage, 0.8);
                             [imageData writeToFile:path atomically:YES];
                         }
                     }];
}

- (void)imageFromSourceImages:(NSArray*)images
                  stripeWidth:(NSInteger)stripeWidth
                      pattern:(NSArray*)pattern
                     progress:(void(^)(CGFloat percentage))progress
                   completion:(void(^)(UIImage *resultImage))completion;
{
    // basic validity checks
    if (images.count == 0  ||
        stripeWidth <= 0   ||
        pattern.count == 0 ||
        completion == nil) {
        return;
    }
    
    // get size of big image
    UIImage *firstImage = images[0];
    CGSize size = firstImage.size;
    size.width *= images.count;
    
    // run in background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // draw image stripes
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        
        NSInteger xpos = 0;
        NSInteger patternIndex = 0;
        while (xpos < size.width) {
            
            // find imageIndex from pattern
            NSInteger imageIndex = [pattern[patternIndex] intValue];
            NSAssert((imageIndex < images.count), @"Invalid pattern or too few images.");
            
            // use correct images
            UIImage *image = images[imageIndex];
            NSAssert((image != nil), @"Couldn't load image");
            
            // draw image
            [image drawAtPoint:CGPointMake(xpos,0)];
            
            // increment
            patternIndex = (patternIndex+1) % pattern.count;
            xpos += stripeWidth;
            
            // call progress block
            if (progress != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progress(xpos/size.width);
                });
            }
        }
        
        // get image from context
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // call completion on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progress) {
                progress(1.0);
            }
            
            completion(image);
        });
    });
}

@end
