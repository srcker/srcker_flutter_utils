# FlutterUtils


### 颜色Color工具类
- 颜色Color工具类。主要是将RGB或者ARGB颜色转化为Color对象，16进制颜色字符串等等。
    ```
    hexToColor                               : 将#A357D6颜色转化为16进制的Color
    toColor                                  : 将#FF6325颜色或者#50A357D6转化为16进制的Color
    colorString                              : 将color颜色转变为字符串
    colorString                              : 检查字符串是否为十六进制
    ```


### 日期转化工具类
- 日期转化工具类。主要是获取当前日期，按指定格式格式化时间，以及多种格式化日期工具方法
    ```
    getNowDateTime                           : 获取当前日期返回DateTime
    getYesterday                             : 获取昨天日期返回DateTime
    getNowUtcDateTime                        : 获取当前日期返回DateTime(utc)
    getNowDateTimeFormat                     : 获取当前日期，返回指定格式
    getUtcDateTimeFormat                     : 获取当前日期，返回指定格式
    isYesterday                              : 根据时间判断是否是昨天
    getNowDateMs                             : 将#获取当前毫秒值，返回int
    getNowDateString                         : 获取现在日期字符串，默认是：yyyy-MM-dd HH:mm:ss，返回字符串
    formatDate                               : 格式化时间，第一个字段是dateTime，第二个可选项表示格式
    formatDateString                         : 格式化日期字符串，第一个字段例如：'2021-07-18 16:03:10'，第二个字段例如："yyyy/M/d HH:mm:ss"
    formatDateMilliseconds                   : 格式化日期毫秒时间，第一个字段例如：1213423143312，第二个字段例如："yyyy/M/d HH:mm:ss"
    getWeekday                               : 获取dateTime是星期几
    getWeekdayByMilliseconds                 : 获取毫秒值对应是星期几
    isToday                                  : 根据时间戳判断是否是今天
    isYesterday                              : 根据时间判断是否是昨天
    ```


### 屏幕参数工具类
- 屏幕参数工具类。获取屏幕的宽，高，像素密度，状态栏等属性。后期完善适配工作……
    ```
    screenWidthDp                            : 当前设备宽度 dp
    screenHeightDp                           : 当前设备高度 dp
    pixelRatio                               : 设备的像素密度
    screenWidth                              : 当前设备宽度 px = dp * 密度
    screenHeight                             : 当前设备高度 px = dp * 密度
    
    statusBarHeight                          : 状态栏高度 dp 刘海屏会更高
    bottomBarHeight                          : 底部安全区距离 dp
    textScaleFactory                         : 像素的字体像素数，字体的缩放比例
    ```






### Text文本工具类
- 文本相关工具类如下：
    ```
    isEmpty                                  : 判断文本内容是否为空
    isNotEmpty                               : 判断文本内容是否不为空
    startsWith                               : 判断字符串是以xx开头
    contains                                 : 判断字符串中是否包含xx
    abbreviate                               : 使用点缩写字符串
    compare                                  : 比较两个字符串是否相同
    hammingDistance                          : 比较两个长度一样的字符串有几个字符不同
    formatDigitPattern                       : 每隔 x位 加 pattern。比如用来格式化银行卡
    formatSpace4                             : 每隔4位加空格
    hideNumber                               : 隐藏手机号中间n位，比如隐藏手机号 13667225184 为 136****5184
    replace                                  : 替换字符串中的数据
    split                                    : 按照规则切割字符串，返回数组
    reverse                                  : 反转字符串
    ```



