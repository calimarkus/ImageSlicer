//
//  NSFileManager+Desktop.h
//  Sideways
//
//  Created by Markus on 24.06.13.
//  Copyright (c) 2013 nxtbgthng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Desktop)

- (NSString*)desktopPathForDirectory:(NSString*)subDirectory;

@end
