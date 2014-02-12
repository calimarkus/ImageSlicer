//
//  ISImageSlicer.h
//  ImageSlicer
//
//  Created by Markus on 12.02.14.
//  Copyright (c) 2014 nxtbgthng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISImageSlicer : NSObject

@property (nonatomic, assign) NSInteger stripeWidth;
@property (nonatomic, copy) NSArray *pattern;

- (void)imageFromSourceImages:(NSArray*)sourceImages
                     progress:(void(^)(CGFloat percentage))progress
                   completion:(void(^)(UIImage *resultImage))completion;

@end
