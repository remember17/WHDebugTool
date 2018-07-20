# WHDebugTool
调试小工具🔨

![WHDebugTool](https://upload-images.jianshu.io/upload_images/3873004-477d1ad4ac10ce46.gif?imageMogr2/auto-orient/strip)

### 1、快速使用方法

1.0 把WHDebugTool文件拖入项目

1.1 导入头文件
```objc
#import "WHDebugToolManager.h"
```

1.2 调用开关方法
一行代码开启或关闭监测。
```objc
// 这个方法调用的时候会判断监测是不是处于打开的状态，如果打开了则关闭，如果没有打开就开启。
[[WHDebugToolManager sharedInstance] toggleWith:DebugToolTypeAll];
```

1.3 可选：也可以通过如下方式初始化和关闭
```objc
// 打开
- (void)showWith:(DebugToolType)type;
// 关闭
- (void)hideWith:(DebugToolType)type;
```

### 2.  参数说明

初始化方法中带有一个枚举参数
这个参数可以让三种监测随意组合。例如只想要监测FPS，就传入DebugToolTypeFPS
```objc
    DebugToolTypeAll = 0,   // FPS & Memory & CPU
    DebugToolTypeFPS,       // FPS
    DebugToolTypeMemory,    // Memory
    DebugToolTypeCPU,       // CPU
    DebugToolTypeFPSMemory, // FPS & Memory
    DebugToolTypeFPSCPU,    // FPS & CPU
    DebugToolTypeCPUMemory, // Memory & CPU
```