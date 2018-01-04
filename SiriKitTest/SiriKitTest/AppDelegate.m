//
//  AppDelegate.m
//  SiriKitTest
//
//  Created by 杜洁鹏 on 04/01/2018.
//  Copyright © 2018 杜洁鹏. All rights reserved.
//

#import "AppDelegate.h"
#import <Intents/Intents.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [INPreferences requestSiriAuthorization:^(INSiriAuthorizationStatus status) {
        
    }];
    return YES;
}

@end
