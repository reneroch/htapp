//
//  Hearing_TestAppDelegate.h
//  Hearing Test
//
//  Created by Dan Rene Rasmussen on 7/10/11.
//  Copyright 2011 Qi Analytics LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Hearing_TestViewController;

@interface Hearing_TestAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet Hearing_TestViewController *viewController;

@end
