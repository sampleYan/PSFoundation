/*
 *  MTUniversalHelper.h
 *  MTUniversal
 *
 *  Created by Matthias Tretter on 09.10.10.
 *  Copyright 2010 @myell0w. All rights reserved.
 *
 */

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark AutoRotation
///////////////////////////////////////////////////////////////////////////////////////////////////////

// Rotate to all Orientations on iPad, on iPhone support only Portrait Orientation
#define kRotateOnIPad(interfaceOrientation) (isIPad() || interfaceOrientation == UIInterfaceOrientationPortrait)
// deprecated:
#define ROTATE_ON_IPAD isIPad() || interfaceOrientation == UIInterfaceOrientationPortrait

// creates a rect with the first 4 parameters on iPhone and the last 4 parameters on iPad
#define MTRectMake(x1,y1,w1,h1,x2,y2,w2,h2) (isIPad() ? CGRectMake(x2,y2,w2,h2) : CGRectMake(x1,y1,w1,h1))

// creates a point with the first 2 parameters on iPhone and the second 2 parameters on iPad
#define MTPointMake(x1,y1,x2,y2)    (isIPad() ? CGPointMake(x2,y2) : CGPointMake(x1,y1))

///////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Functions for managing device-specific Resources on iPhone/iPad
///////////////////////////////////////////////////////////////////////////////////////////////////////

// returns the image name depending on the current device by appending "-iPad" when on iPad
NSString* MTDeviceSpecificImageName(NSString *imageName);
// you can specify your own appendix
NSString* MTDeviceSpecificImageNameWithAppendix(NSString *imageName, NSString *appendix);
// takes the current orientation on iPad into account by appending "-iPad-L" when in Landscape-Mode, otherwise "-iPad"
NSString* MTDeviceSpecificImageNameForOrientation(NSString *imageName, UIInterfaceOrientation orientation);
NSString* MTDeviceSpecificImageNameForOrientationWithAppendix(NSString *imageName, UIInterfaceOrientation orientation, NSString *appendix);
// Create Device-Specific Nib-Name
NSString* MTNibName(NSString *name);
