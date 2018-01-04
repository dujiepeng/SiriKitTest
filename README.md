# SiriKitTest

### 项目创建过程
 1. 创建项目 `SiriKitTest `。
 2. 开启项目支持Siri `Targets` - `SiriKitTest` - `Capabilities` - `Siri` - `On` 
 3. 创建 Siri 的 Extension， `File` - `Target` - `iOS` - `Intents Extension`, 命名为 `SiriKitTestIntent`，使用默认的UI，**不勾选**`Include UI Extension` - `Finish`,此时会提示Activate "SiriKitTestIntent" scheme? 选择`Activate`
 
### 添加权限


1. `Targets` - `SiriKitTest` - `Info` 添加一项 **Privacy - Siri Usage Description**, Value是提示语，此处随便写，本项目中写的是"Using Siri"
2. 在AppDelegate.m中，添加权限判断代码:

	```
	#import <Intents/Intents.h>
	[INPreferences requestSiriAuthorization:^(INSiriAuthorizationStatus status) 	{
   	  // 此处就会提示第一步中设置的 "Using Siri"
	}];
	``` 
  
3.设置支持的唤醒，需要在extension中设置支持哪些**Intent**(下文解释)，`Targets` - `SiriKitTestIntent` - `NSExtension` - `NSExtensionAttributes`,在这个下面可以看到有**[IntentsSupported](#IntentsSupported)**和**[IntentsRestrictedWhileLocked](#IntentsRestrictedWhileLocked)，这里面对应的item，就是指要支持的**Intent**，目前新版xcode创建的**Intents Extension**会在IntentsSupported中自动加几项，本项目只演示发消息，所以只保留**INSendMessageIntent**就可以了。
	

###  SiriKit简单讲解

SiriKit支持的东西目前还是比较丰富的，这个具体可以参考Intents.framework下的头文件。

Intent，就是“意图”，命名很直接，在看Intents.framework头文件的时候只要是Intent结尾的，就是目前SiriKit可以做的。 每个Intent结尾的文件中，一般都会有对应的protocol，其中大部分以“Handling”结尾，说明可以捕获意图

当创建`SiriKitTestIntent`后，会自动生`IntentHandler`类，`IntentHandler`继承自`INExtension`,同时实现了`INSendMessageIntentHandling`,`INSearchForMessagesIntentHandling`,`INSetMessageAttributeIntentHandling`三个protocol，，此处以`INSendMessageIntentHandling`举例，为了描述清晰，本项目中删除了INSearchForMessagesIntentHandling, INSetMessageAttributeIntentHandling 和相关方法。

### 集成环信

1. 此处使用[Cocoapods](#Cocoapods)集成，要注意两个target中都要添加环信的framework。具体可以参考Podfile文件
2. 在Project目录下执行[`Pod install`](#podInstallError1)
3. 安装完成后，关闭Project，使用生成的workspace访问项目。
4. 在SiriKitTestIntent中实现sdk的初始化和登录，发消息方法，并确保这些是在生命周期内完成(为了保证是同步，本项目中使用了信号量在等待)。

### 坑点

1. 在尝试唤醒Siri的时候，发现根本不会进入。siri始终提示我"<u>I wish I could, but SiriKitTest hasn't set that up with me yet</u>”, 找了很多地方，最后发现是ios本身问题，升级到最新的ios11，问题解决。
2. 在唤醒的时候总是打开app，而不是产生Intent，后来发现，因为在代码里报错了，没有办法继续，所以iOS不在使用extension，而是自动打开了主App.
3. 网上的文章都比较老旧，很多地方介绍不全(比如权限部分)。

----


<span id="IntentsSupported"> `IntentsSupported`: 允许Siri接收哪些**Intent**。</span>

<span id="IntentsRestrictedWhileLocked"> `IntentsRestrictedWhileLocked `: 锁屏时，禁止Siri使用哪些**Intent**。</span>

<span id="Cocoapods"> `Cocoapods`: [Cocoapods安装](http://www.code4app.com/article/cocoapods-install-usage)</span>

<span id="podInstallError1"> `Pod install失败`: 如果此处提示网络失败，一般是被墙了，尝试多试几次或者使用vpn；如果提示找不到sdk，可以先执行`Pod setup`，之后再执行`Pod install`</span>

