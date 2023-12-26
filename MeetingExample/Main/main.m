//
//  main.m
//  MeetingExample
//
//  Created by SailorGa on 2021/10/25.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWAppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        /// Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([FWAppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
