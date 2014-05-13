//
//  ISSaveImageToDesktopActivity.h
//  ImageSlicer
//
//  Created by Markus on 13.05.14.
//  Copyright (c) 2014 nxtbgthng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISSaveImageToDesktopActivity : UIActivity

@property (nonatomic, copy) NSString *filename;

- (id)initWithFileName:(NSString*)filename;

@end
