# SiriKitTest

### 项目创建过程
 1. 创建项目 `SiriKitTest `。
 2. 开启项目支持Siri `Targets` - `SiriKitTest` - `Capabilities` - `Siri` - `On` 
 3. 创建 Siri 的 Extension， `File` - `Target` - `iOS` - `Intents Extension`, 命名为 `SiriKitTestIntent`，使用默认的UI，**不勾选**`Include UI Extension` - `Finish`,此时会提示Activate "SiriKitTestIntent" scheme? 选择`Activate`
 
### 添加权限
 1. `Targets` - `SiriKitTest` - `Info` 添加一项 **Privacy - Siri Usage Description**, Value是提示语，此处随便写，本项目中写的是"Using Siri"
 2. 在AppDelegate.m中，添加权限判断代码

	```
	#import <Intents/Intents.h>
	[INPreferences requestSiriAuthorization:^(INSiriAuthorizationStatus status) 	{
   	  // 此处就会提示第一步中设置的 "Using Siri"
	}];
	
	```

###  SiriKit简单讲解

SiriKit支持的东西目前还是比较丰富的，这个具体可以参考Intents.framework下的头文件。

Intent，就是“意图”，命名很直接，在看Intents.framework头文件的时候只要是Intent结尾的，就是目前SiriKit可以做的。 每个Intent结尾的文件中，一般都会有对应的protocol，其中大部分以“Handling”结尾，说明可以捕获意图

当创建`SiriKitTestIntent`后，会自动生`IntentHandler`类，`IntentHandler`继承自`INExtension`,同时实现了`INSendMessageIntentHandling`,`INSearchForMessagesIntentHandling`,`INSetMessageAttributeIntentHandling`三个protocol，，此处以`INSendMessageIntentHandling`举例，为了描述清晰，本项目中删除了INSearchForMessagesIntentHandling, INSetMessageAttributeIntentHandling 和相关方法。