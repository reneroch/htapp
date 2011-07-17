//
//  HearingTestAppDelegate.h
//  HearingTest
//
//  Created by Dan Rene Rasmussen on 7/17/11.
//  Copyright 2011 Qi Analytics LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HearingTestViewController;

@interface HearingTestAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet HearingTestViewController *viewController;

@end
