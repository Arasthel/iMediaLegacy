/*
 iMedia Browser Framework <http://karelia.com/imedia/>
 
 Copyright (c) 2005-2010 by Karelia Software et al.
 
 iMedia Browser is based on code originally developed by Jason Terhorst,
 further developed for Sandvox by Greg Hulands, Dan Wood, and Terrence Talbot.
 The new architecture for version 2.0 was developed by Peter Baumgartner.
 Contributions have also been made by Matt Gough, Martin Wennerberg and others
 as indicated in source files.
 
 The iMedia Browser Framework is licensed under the following terms:
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in all or substantial portions of the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to permit
 persons to whom the Software is furnished to do so, subject to the following
 conditions:
 
	Redistributions of source code must retain the original terms stated here,
	including this list of conditions, the disclaimer noted below, and the
	following copyright notice: Copyright (c) 2005-2010 by Karelia Software et al.
 
	Redistributions in binary form must include, in an end-user-visible manner,
	e.g., About window, Acknowledgments window, or similar, either a) the original
	terms stated here, including this list of conditions, the disclaimer noted
	below, and the aforementioned copyright notice, or b) the aforementioned
	copyright notice and a link to karelia.com/imedia.
 
	Neither the name of Karelia Software, nor Sandvox, nor the names of
	contributors to iMedia Browser may be used to endorse or promote products
	derived from the Software without prior and express written permission from
	Karelia Software or individual contributors, as appropriate.
 
 Disclaimer: THE SOFTWARE IS PROVIDED BY THE COPYRIGHT OWNER AND CONTRIBUTORS
 "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
 LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
 AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT, OR OTHERWISE, ARISING FROM, OUT OF, OR IN CONNECTION WITH, THE
 SOFTWARE OR THE USE OF, OR OTHER DEALINGS IN, THE SOFTWARE.
*/


// Author: Peter Baumgartner


//----------------------------------------------------------------------------------------------------------------------


#pragma mark HEADERS

#import "IMBFlickrObject.h"


//----------------------------------------------------------------------------------------------------------------------


@implementation IMBFlickrObject


//----------------------------------------------------------------------------------------------------------------------


// Override this method to make QuickLook work with remote flickr content on the internet. This is a naive 
// implementation that simply synchronously downloads the thumbnail and stores it in a local file in the temp  
// items folder. We don't even do a cleanup (hopefully the OS will take care of that ;-)...

// Is there even a way to do a asynchronous QuickLook preview load?  I don't see any methods for notification when
// something is loaded. Maybe some hints here: QuickLookDownloader sample code from Apple, along with 
// http://development.christopherdrum.com/blog/?p=109


- (NSURL*) previewItemURL
{
//	NSLog (@"%s",__FUNCTION__);
	NSURL* quickLookURL = [self.metadata objectForKey:@"quickLookURL"];
	NSURL* previewItemURL = nil;
	
	if (quickLookURL)
	{
		// The is our temp download folder...
		
		NSString* folder = [[NSFileManager threadSafeManager] sharedTemporaryFolder:@"quicklook"];

		// Build a path for the download file...
		
		NSString* filename = [[quickLookURL path] lastPathComponent];
		NSString* path = [folder stringByAppendingPathComponent:filename];
		
		// If the file is already there, then use it...
		
		if ([[NSFileManager threadSafeManager] fileExistsAtPath:path])
		{
			previewItemURL = [NSURL fileURLWithPath:path];
		}

		// If not, then download it...
	
		else
		{
			NSData* data = [NSData dataWithContentsOfURL:quickLookURL];
			previewItemURL = [NSURL fileURLWithPath:path];
			[data writeToURL:previewItemURL atomically:NO];
		}
	}
	
	return previewItemURL;
}


//----------------------------------------------------------------------------------------------------------------------


- (NSString *)previewItemTitle
{
	return self.name;
}


- (BOOL) isSelectable 
{
	return [super isSelectable]; // [[self.metadata objectForKey:@"can_download"] boolValue];
}


//----------------------------------------------------------------------------------------------------------------------


@end
