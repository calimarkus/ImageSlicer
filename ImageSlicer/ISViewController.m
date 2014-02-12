//
//  ISViewController.m
//  ImageSlicer
//
//  Created by Markus on 26.10.13.
//  Copyright (c) 2013 nxtbgthng. All rights reserved.
//

#import "ISImageSlicer.h"
#import "NSFileManager+DesktopPath.h"

#import "ISViewController.h"

@interface ISViewController ()
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) UISlider *stripeWidthSlider;
@property (nonatomic,strong) UITextField *patternTextField;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *stepperValueLabel;

@property (nonatomic, strong) ISImageSlicer *imageSlicer;
@end

@implementation ISViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"ImageSlicer";
        
        self.imageSlicer = [[ISImageSlicer alloc] init];
        self.imageSlicer.stripeWidth = 3;
        self.imageSlicer.pattern = @[@(0),@(1),@(2),@(1),@(0),@(3)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // add stepper
    self.stripeWidthSlider = [[UISlider alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width-40, 30)];
    self.stripeWidthSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    self.stripeWidthSlider.minimumValue = 1;
    self.stripeWidthSlider.maximumValue = 100;
    self.stripeWidthSlider.value = self.imageSlicer.stripeWidth;
    [self.stripeWidthSlider addTarget:self action:@selector(sliderValueChanged:)
                     forControlEvents:UIControlEventValueChanged];
    [self.stripeWidthSlider addTarget:self action:@selector(sliderEndedEditing:)
                     forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.view addSubview:self.stripeWidthSlider];
    
    // add stepper label
    self.stepperValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, self.view.frame.size.width-40, 30)];
    self.stepperValueLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    self.stepperValueLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.stepperValueLabel];
    [self sliderValueChanged:self.stripeWidthSlider];
    
    // add image view
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - self.view.frame.size.width,
                                                                   self.view.frame.size.width, self.view.frame.size.width)];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    self.imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedImage:)]];
    [self.view addSubview:self.imageView];
    
    // add progress view
    CGRect frame = CGRectInset(self.imageView.frame, 40, 40);
    frame.origin.y = floor(self.imageView.frame.size.height/2.0);
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.progressView.frame = frame;
    self.progressView.hidden = YES;
    [self.imageView addSubview:self.progressView];
    
    // autostart
    [self redrawImage];
}

- (void)sliderValueChanged:(UISlider*)sender;
{
    self.imageSlicer.stripeWidth = sender.value;
    self.stepperValueLabel.text = [NSString stringWithFormat: @"%d pixel per stripe", (int)self.imageSlicer.stripeWidth];
}

- (void)sliderEndedEditing:(UISlider*)slider;
{
    [self redrawImage];
}

- (void)tappedImage:(UITapGestureRecognizer*)recognizer;
{
    if(self.imageView.contentMode == UIViewContentModeScaleAspectFill) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
}

- (void)redrawImage;
{
    // get source images
    NSArray *images = @[[UIImage imageNamed:@"01.jpg"],
                        [UIImage imageNamed:@"02.jpg"],
                        [UIImage imageNamed:@"03.jpg"],
                        [UIImage imageNamed:@"04.jpg"]];
    
    // show progress
    self.progressView.hidden = NO;
    self.imageView.image = nil;
    
    // create new image & save
    __weak typeof(self) blockSelf = self;
    [self.imageSlicer imageFromSourceImages:images progress:^(CGFloat progress) {
        // handle progress
        blockSelf.progressView.progress = progress;
    } completion:^(UIImage *resultImage){
        // save image
        if(resultImage) {
            NSString *path = [[NSFileManager defaultManager] desktopPathForDirectory:nil];
            path = [path stringByAppendingPathComponent:@"SlicedImage.jpg"];
            NSData *imageData = UIImageJPEGRepresentation(resultImage, 0.8);
            [imageData writeToFile:path atomically:YES];
            
            blockSelf.imageView.image = resultImage;
            blockSelf.progressView.hidden = YES;
        }
    }];
}

@end
