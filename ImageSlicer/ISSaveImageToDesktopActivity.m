//
//  ISSaveImageToDesktopActivity.m
//  ImageSlicer
//
//  Created by Markus on 13.05.14.
//  Copyright (c) 2014 nxtbgthng. All rights reserved.
//

#import "NSFileManager+DesktopPath.h"

#import "ISSaveImageToDesktopActivity.h"

@interface ISSaveImageToDesktopActivity ()
@property (nonatomic, strong) UIImage *image;
@end

@implementation ISSaveImageToDesktopActivity

- (id)initWithFileName:(NSString*)filename;
{
    self = [super init];
    if (self) {
        _filename = filename;
    }
    return self;
}

- (NSString *)activityTitle
{
    return @"Save to Desktop";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"savetodesktop"];
}

#pragma mark performing

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    for (id item in activityItems) {
        return [item isKindOfClass:[UIImage class]];
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    for (id item in activityItems) {
        if([item isKindOfClass:[UIImage class]]) {
            self.image = item;
        }
    }
}

- (void)performActivity
{
    NSString *path = [[NSFileManager defaultManager] desktopPathForDirectory:nil];
    path = [path stringByAppendingPathComponent:self.filename];
    NSData *imageData = UIImageJPEGRepresentation(self.image, 0.8);
    BOOL result = [imageData writeToFile:path atomically:YES];
    [self activityDidFinish:result];
}

@end
