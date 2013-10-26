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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // get source images
    NSArray *images = @[[UIImage imageNamed:@"01.jpg"],
                        [UIImage imageNamed:@"02.jpg"],
                        [UIImage imageNamed:@"03.jpg"],
                        [UIImage imageNamed:@"04.jpg"]];
    
    // create new image
    UIImage *image = [self imageFromSourceImages:images
                                     stripeWidth:3
                                         pattern:@[@(0),@(1),@(2),@(1),@(0),@(3)]];
    
    // save image
    if(image) {
        NSString *path = [[NSFileManager defaultManager] desktopPathForDirectory:@"ImageSlicer-Results"];
        path = [path stringByAppendingPathComponent:@"SlicedImage.jpg"];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        [imageData writeToFile:path atomically:YES];
    }
}

- (UIImage*)imageFromSourceImages:(NSArray*)images
                      stripeWidth:(NSInteger)stripeWidth
                          pattern:(NSArray*)pattern;
{
    if (images.count == 0 || stripeWidth <= 0 || pattern.count == 0) return nil;
    
    // get size of big image
    UIImage *firstImage = images[0];
    CGSize size = firstImage.size;
    size.width *= images.count;
    
    // draw image stripes
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    NSInteger xpos = 0;
    NSInteger patternIndex = 0;
    while (xpos < size.width) {
        
        // find correct image
        NSInteger imageIndex = [pattern[patternIndex] intValue];
        UIImage *image = images[imageIndex];
        
        // draw image
        [image drawAtPoint:CGPointMake(xpos,0)];
        
        // increment
        patternIndex = (patternIndex+1) % pattern.count;
        xpos += stripeWidth;
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
