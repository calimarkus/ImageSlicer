//
//  NSFileManager+Desktop.m
//  Sideways
//
//  Created by Markus on 24.06.13.
//  Copyright (c) 2013 nxtbgthng. All rights reserved.
//

#import <pwd.h>

#import "NSFileManager+DesktopPath.h"

@implementation NSFileManager (Desktop)

- (NSString*)homeDirectory;
{
	NSString *logname = [NSString stringWithCString:getenv("LOGNAME") encoding:NSUTF8StringEncoding];
	struct passwd *pw = getpwnam([logname UTF8String]);
	return pw ? [NSString stringWithCString:pw->pw_dir encoding:NSUTF8StringEncoding] : [@"/Users" stringByAppendingPathComponent:logname];
}

- (NSString*)desktopPathForDirectory:(NSString*)subDirectory;
{
	NSString *saveDirectory = nil;
    
#if TARGET_IPHONE_SIMULATOR
    saveDirectory = [NSString stringWithFormat:@"%@/Desktop", [self homeDirectory]];
#else
    saveDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
#endif
    
	if (subDirectory)
		saveDirectory = [saveDirectory stringByAppendingPathComponent:subDirectory];
    
	if (![[NSFileManager defaultManager] fileExistsAtPath:saveDirectory])
	{
		NSError *error = nil;
		BOOL created = [[NSFileManager defaultManager] createDirectoryAtPath:saveDirectory withIntermediateDirectories:YES attributes:nil error:&error];
		if (!created)
			NSLog(@"%@\n%@", error, error.userInfo);
	}
    
	return saveDirectory;
}

@end
