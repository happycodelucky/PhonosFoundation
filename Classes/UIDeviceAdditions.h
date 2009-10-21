//
//  UIDeviceAdditions.h
//  PhonosFoundations
//
//  Created by Paul Bates on 10/17/09.
//  Copyright 2009 The Evil Radish Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 * enum UIDeviceType
 *
 * Discussion:
 *     The device type model, so far only an iPhone or iPod Touch.
 */
typedef enum {
	UIDeviceTypeiPhone,      // iPhone device.
	UIDeviceTypeiPodTouch    // iPod Touch device.
} UIDeviceType;

/*
 * enum UIDeviceConnectivity
 *
 * Discussion:
 *     Device connectivity status.
 */
typedef enum {
	UIDeviceConnectivityNone,         // No connection available.
	UIDeviceConnectivityCellular,     // 3G, EDGE or GPRS network connection available.
	UIDeviceConnectivityWiFi          // Wi-Fi network connection available.
} UIDeviceConnectivity;

/*
 * interface UIDevice
 *
 * Discussion:
 *     Additions to the UIDevice Core Foundation class for simpiler access to
 *     device status information.
 */
@interface UIDevice()

@property (nonatomic, readonly, retain) NSString *machine;            // return machine hardware identifier string (e.g. @"iPhone1,1", @"iPod2,1", ..)
@property (nonatomic, readonly) UIDeviceType type;                    // return current device type (iPod/iPhone).
@property (nonatomic, readonly) int generation;                       // return current device generation.
@property (nonatomic, readonly) UIDeviceConnectivity connectivity;    // return current device network connectivty.
@property (nonatomic, readonly) BOOL cameraAvailable;                 // returns YES if device has an integrated camera.
@property (nonatomic, readonly) BOOL compassAvailable;                // returns YES if device has an installed compass/heading unit.
@property (nonatomic, readonly) BOOL gpsAvailable;                    // returns YES if device has an installed GPS unit.
@property (nonatomic, readonly) BOOL microphoneAvailable;             // returns YES if device has an installed microphone receiver unit.

@end
