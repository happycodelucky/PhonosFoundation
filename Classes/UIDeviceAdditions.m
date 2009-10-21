//
//  UIDeviceAdditions.m
//  PhonosFoundations
//
//  Created by Paul Bates on 10/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIDeviceAdditions.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/types.h>
#import <sys/sysctl.h>
#import <sys/socket.h>
#import <netinet/in.h>

static NSString const *kDeviceGenerationiPhone = @"iPhone1,1";
static NSString const *kDeviceGenerationiPhone3G = @"iPhone1,2";
static NSString const *kDeviceGenerationiPhone3GS = @"iPhone2,1";
static NSString const *kDeviceGenerationiPodTouch1G = @"iPod1,1";
static NSString const *kDeviceGenerationiPodTouch2G = @"iPod2,1";
static NSString const *kDeviceGenerationiPodTouch3G = @"iPod2,2";
static NSString const *kDeviceNameiPhone = @"iPhone";
static NSString const *kDeviceNameiPodTouch = @"iPod Touch";

@implementation UIDevice

@dynamic machine;
@dynamic type;
@dynamic generation;
@dynamic connectivity;
@dynamic cameraAvailable;
@dynamic compassAvailable;
@dynamic gpsAvailable;
@dynamic microphoneAvailable;

#pragma mark -
#pragma mark Device Information

- (NSString *)machine
{	
	static NSString *_machine = nil;
	
	@synchronized(self) {
		if (_machine == nil) {
			size_t len = 0;
			int mib[] = {CTL_HW, HW_MACHINE};
			if (sysctl(mib, 2, NULL, &len, NULL, 0) == 0) {
				char *buffer = malloc(len);
				if (buffer){
					if (sysctl(mib, 2, buffer, &len, NULL, 0) == 0) {
						_machine = [[NSString alloc] initWithCString:buffer encoding:NSASCIIStringEncoding];
					}
					free(buffer);
				}
			} else {
				NSLog(@"Unable to fetch the platform machine information from sysctl");
			}
			
			NSAssert(_machine == nil, @"_platform not correctly set");
		}		
	}
	
	return _machine;
}

- (UIDeviceType)type
{
	NSString *deviceName = [self name];
	if (deviceName != nil) {
		if ([kDeviceNameiPhone isEqualToString:deviceName])
			return UIDeviceTypeiPhone;
		
		if ([kDeviceNameiPodTouch isEqualToString:deviceName])
			return UIDeviceTypeiPodTouch;
	}
	NSAssert(FALSE, @"Unable to determine device type.");
	return UIDeviceTypeiPodTouch;
}

- (int)generation
{
	UIDeviceType _type = self.type;
	NSString *_machine = self.machine;
	if (_type == UIDeviceTypeiPhone) {
		if ([kDeviceGenerationiPhone3GS isEqualToString:_machine])
			return 3;
		if ([kDeviceGenerationiPhone3G isEqualToString:_machine])
			return 2;
		if ([kDeviceGenerationiPhone isEqualToString:_machine])
			return 1;
	} else if (_type == UIDeviceTypeiPodTouch) {
		if ([kDeviceGenerationiPodTouch3G isEqualToString:_machine])
			return 3;
		if ([kDeviceGenerationiPodTouch2G isEqualToString:_machine])
			return 2;
		if ([kDeviceGenerationiPodTouch1G isEqualToString:_machine])
			return 1;
	}
	
	NSAssert(FALSE, @"Unable to determine device generation");
	return 0;
}

#pragma mark -
#pragma mark Network Status

- (UIDeviceConnectivity)connectivity
{
    // Create zero address
    struct sockaddr_in sockAddr;
    bzero(&sockAddr, sizeof(sockAddr));
    sockAddr.sin_len = sizeof(sockAddr);
    sockAddr.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef nrRef = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&sockAddr);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(nrRef, &flags);
	if (!didRetrieveFlags) {
		NSLog(@"Unable to fetch the network reachablity flags");
	}

	CFRelease(nrRef);	
	
	if (!didRetrieveFlags || (flags & kSCNetworkReachabilityFlagsReachable) != kSCNetworkReachabilityFlagsReachable)
		// Unable to connect to a network (no signal or airplane mode activated)
		return UIDeviceConnectivityNone;
	
	if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
		// Only a cellular network connection is available.
		return UIDeviceConnectivityCellular;
	
	// WiFi connection available.
	return UIDeviceConnectivityWiFi;
}

#pragma mark -
#pragma mark Integrated Hardware

- (BOOL)cameraAvailable
{
	return self.type == UIDeviceTypeiPhone;
}

- (BOOL)compassAvailable
{
	return self.type == UIDeviceTypeiPhone && self.generation > 3;
}

- (BOOL)gpsAvailable
{
	return self.type == UIDeviceTypeiPhone && self.generation > 2;	
}

- (BOOL)microphoneAvailable
{
	return self.type == UIDeviceTypeiPhone;	
}

@end
