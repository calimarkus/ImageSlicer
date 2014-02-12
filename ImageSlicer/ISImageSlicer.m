//
//  ISImageSlicer.m
//  ImageSlicer
//
//  Created by Markus on 12.02.14.
//  Copyright (c) 2014 nxtbgthng. All rights reserved.
//

#import "ISImageSlicer.h"

@implementation ISImageSlicer

- (void)imageFromSourceImages:(NSArray*)sourceImages
                     progress:(void(^)(CGFloat percentage))progress
                   completion:(void(^)(UIImage *resultImage))completion;
{
    // basic validity checks
    NSAssert(sourceImages.count > 1, @"No sourceImages given.");
    NSAssert(self.pattern.count > 1, @"pattern needs to have two elements at least.");
    NSAssert(self.stripeWidth > 0, @"stripeWidth cannot be less than 1.");
    
    // get size of big image
    UIImage *firstImage = sourceImages[0];
    CGSize size = firstImage.size;
    size.width *= sourceImages.count;
    
    // run in background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // draw image stripes
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
        
        NSInteger xPos = 0;
        NSInteger patternIndex = 0;
        while (xPos < size.width) {
            // find imageIndex from pattern
            NSInteger imageIndex = [self.pattern[patternIndex] intValue];
            NSAssert((imageIndex < sourceImages.count), @"Invalid pattern (%@) or too few images (%d).", self.pattern, (int)sourceImages.count);
            
            // use correct images
            UIImage *image = sourceImages[imageIndex];
            NSAssert((image != nil), @"Couldn't load image for index %d", (int)imageIndex);
            
            // draw image
            CGFloat relativePosition = xPos/size.width;
            NSInteger relativeImagePosition = (image.size.width * relativePosition);
            relativeImagePosition = MAX(0, round(relativeImagePosition - self.stripeWidth/2.0));
            relativeImagePosition = MIN(image.size.width-self.stripeWidth, relativeImagePosition);
            CGRect cropRect = CGRectMake(relativeImagePosition, 0, self.stripeWidth, size.height);
            CGImageRef croppedImage = CGImageCreateWithImageInRect(image.CGImage, cropRect);
            [[UIImage imageWithCGImage:croppedImage] drawAtPoint:CGPointMake(xPos, 0)];
            
            // increment
            patternIndex = (patternIndex+1) % self.pattern.count;
            xPos += self.stripeWidth;
            
            // call progress block
            if (progress != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    progress(xPos/size.width);
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
            if (completion) {
                completion(image);
            }
        });
    });
}

@end
