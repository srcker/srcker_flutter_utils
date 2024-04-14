/// 键盘数据类，用于封装键盘的类型和对应的值。
import 'keyboard_type.dart';

class KeyBoardData {

    // 键盘类型
    final KeyBoardType type;
    // 键盘显示的值
    final String value;

    /// 构造函数，初始化键盘数据。
    /// 
    /// @param type 键盘的类型，定义了键盘的布局和功能。
    /// @param value 键盘上显示的值，可以是数字、字符或其他符号。
    const KeyBoardData(this.type, this.value);


    @override
    String toString(){
        return "KeyBoardData({type: $type, value: $value})";
    }
}