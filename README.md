# WHDebugTool

![Debug](https://upload-images.jianshu.io/upload_images/3873004-abada48f188a2408.gif?imageMogr2/auto-orient/strip)

### 1、快速使用

1.1 Pod或直接把WHDebugTool文件拖入项目

```objc 
pod 'WHDebugTool', '~> 2.0'
```

1.2 导入头文件

Pod的方式:
```objc
#import <WHDebugTool/WHDebugToolManager.h>
```

拖入WHDebugTool文件的方式：
```objc
#import "WHDebugToolManager.h"
```

1.3 调用开关方法

一行代码开启或关闭监测。
```objc
// 这个方法调用的时候会判断监测是不是处于打开的状态，如果打开了则关闭，如果没有打开就开启。
[WHDebugToolManager toggleWith:DebugToolTypeAll];
```

1.4 可选：也可以通过如下方式初始化和关闭
```objc
// 打开
+ (void)showWith:(DebugToolType)type;
// 关闭
+ (void)hide;
```

### 2.  参数说明

初始化方法中带有一个位移枚举参数
可以让三种监测随意组合。例如只想要监测FPS，就传入DebugToolTypeFPS，如果想多种组合：DebugToolTypeFPS | DebugToolTypeMemory | DebugToolTypeCPU
```objc
DebugToolTypeFPS    = 1 << 0,
DebugToolTypeCPU    = 1 << 1,
DebugToolTypeMemory = 1 << 2,
DebugToolTypeAll    = (DebugToolTypeFPS | DebugToolTypeCPU | DebugToolTypeMemory)
```
