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
@property (nonatomic,strong) UIStepper *stripeWidthStepper;
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
        
        self.navigationItem.rightBarButtonItem = ({
            [[UIBarButtonItem alloc]
             initWithTitle:@"Start"
             style:UIBarButtonItemStylePlain
             target:self
             action:@selector(startAction:)];
        });
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // add stepper
    self.stripeWidthStepper = [[UIStepper alloc] initWithFrame:CGRectMake(20, 100, 0, 0)];
    self.stripeWidthStepper.minimumValue = 1;
    self.stripeWidthStepper.maximumValue = 100;
    self.stripeWidthStepper.stepValue = 10;
    self.stripeWidthStepper.value = self.imageSlicer.stripeWidth;
    [self.stripeWidthStepper addTarget:self
                                action:@selector(stepperValueChanged:)
                      forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.stripeWidthStepper];
    
    // add stepper label
    CGSize stepperSize = self.stripeWidthStepper.frame.size;
    self.stepperValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(40+stepperSize.width, 100,
                                                                       self.view.frame.size.width-80-stepperSize.width,
                                                                       stepperSize.height)];
    [self.view addSubview:self.stepperValueLabel];
    [self stepperValueChanged:self.stripeWidthStepper];
    
    // add image view
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - self.view.frame.size.width,
                                                                           self.view.frame.size.width, self.view.frame.size.width)];
    self.imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    
    // add progress view
    CGRect frame = CGRectInset(self.imageView.frame, 40, 40);
    frame.origin.y = floor(self.imageView.frame.size.height/2.0);
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = frame;
    self.progressView.hidden = YES;
    [self.imageView addSubview:self.progressView];
    
    // autostart
    [self startAction:self.navigationItem.rightBarButtonItem];
}

- (void)stepperValueChanged:(UIStepper*)sender;
{
    self.imageSlicer.stripeWidth = sender.value;
    self.stepperValueLabel.text = [NSString stringWithFormat: @"%d pixel per stripe", self.imageSlicer.stripeWidth];
}

- (void)startAction:(UIBarButtonItem*)sender;
{
    sender.enabled = NO;
    
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
        
        blockSelf.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

@end
