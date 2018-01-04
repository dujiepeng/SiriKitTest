//
//  IntentHandler.m
//  SiriKitTestIntent
//
//  Created by 杜洁鹏 on 04/01/2018.
//  Copyright © 2018 杜洁鹏. All rights reserved.
//

#import "IntentHandler.h"
#import <Hyphenate/Hyphenate.h>

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"

@interface IntentHandler () <INSendMessageIntentHandling>

@end

@implementation IntentHandler

- (id)handlerForIntent:(INIntent *)intent {
    // This is the default implementation.  If you want different objects to handle different intents,
    // you can override this and return the handler you want for that particular intent.
    
    return self;
}

#pragma mark - INSendMessageIntentHandling
// 必须实现，在Siri操作界面点击Send的时候，会回调到该方法。
- (void)handleSendMessage:(INSendMessageIntent *)intent completion:(void (^)(INSendMessageIntentResponse *response))completion {
    
    // Implement your application logic to send a message here.
    EMOptions *options = [EMOptions optionsWithAppkey:@"easemob-demo#chatdemoui"];
    options.enableConsoleLog = YES;
    [EMClient.sharedClient initializeSDKWithOptions:options];
    
    __block INSendMessageIntentResponseCode code = INSendMessageIntentResponseCodeFailure;
    
    // 获取到数据
    NSString *toUsername = intent.recipients.lastObject.displayName;
    NSString *text = intent.content;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    // 此处需要得到登录账号
    [EMClient.sharedClient loginWithUsername:@"du003" password:@"1" completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:text];
            EMMessage *msg = [[EMMessage alloc] initWithConversationID:toUsername
                                                                  from:@"du003"
                                                                    to:toUsername
                                                                  body:body
                                                                   ext:nil];
            [EMClient.sharedClient.chatManager sendMessage:msg progress:nil completion:
             ^(EMMessage *message, EMError *error) {
                 if (!error) {
                     code = INSendMessageIntentResponseCodeSuccess;
                 }
                 dispatch_semaphore_signal(semaphore);
             }];
        }else {
            dispatch_semaphore_signal(semaphore);
        }
    }];
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INSendMessageIntent class])];
    
    // 等待30秒，如果没有返回，会出现超时，之后siri会表现为“让我再想想”之类的情况。
    dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC));
    
    INSendMessageIntentResponse *response = [[INSendMessageIntentResponse alloc] initWithCode:code userActivity:userActivity];
    completion(response);
}


@end
