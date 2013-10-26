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

@end

@implementation ISViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSArray *images = @[[UIImage imageNamed:@"01"],
                        [UIImage imageNamed:@"02"],
                        [UIImage imageNamed:@"03"],
                        [UIImage imageNamed:@"04"]];
    UIImage *image = [self imageFromSourceImages:images];
}

- (UIImage*)imageFromSourceImages:(NSArray*)images;
{
    
}

@end
