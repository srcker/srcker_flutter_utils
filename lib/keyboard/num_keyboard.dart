
import 'package:flutter/material.dart';

import 'keyboard_data.dart';
import 'keyboard_type.dart';

/// 键盘对话框类，用于展示并处理自定义键盘输入
class NumKeyBoard extends StatefulWidget {

    final String buttonText;
    final Color buttonColor;
    final Color backgroundColor;
    final Color keyColor;
    final TextStyle keyTextStyle;
    final TextStyle confirmTextStyle;
    final Icon deleteIcon;

    /// 确认按钮点击回调函数
    final Function? onConfirm;

    /// 输入按键点击回调函数
    final Function? onInput;

    final TextEditingController controller;

    const NumKeyBoard({
        super.key, 
        this.onConfirm, 
        this.onInput, 
        this.buttonText = "确认", 
        this.buttonColor = Colors.green, 
        required this.controller, 
        this.backgroundColor = const Color(0xFFF8F8F8), 
        this.keyColor = Colors.white, 
        this.keyTextStyle = const TextStyle(fontSize: 23, color: Colors.black87, fontWeight: FontWeight.bold), 
        this.confirmTextStyle = const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold), 
        this.deleteIcon = const Icon(Icons.backspace, size: 25, color: Colors.black87)
    });

    @override
    _NumKeyBoardState createState() => _NumKeyBoardState();
}

/// 键盘对话框的状态类，管理键盘的显示和行为
class _NumKeyBoardState extends State<NumKeyBoard> {

    /// 定义键盘数据列表，包括数字和运算符等键
    static final List<KeyBoardData> _keyboardDataList = [
        const KeyBoardData(KeyBoardType.num, "7"),
        const KeyBoardData(KeyBoardType.num, "8"),
        const KeyBoardData(KeyBoardType.num, "9"),
        const KeyBoardData(KeyBoardType.num, "4"),
        const KeyBoardData(KeyBoardType.num, "5"),
        const KeyBoardData(KeyBoardType.num, "6"),
        const KeyBoardData(KeyBoardType.num, "1"),
        const KeyBoardData(KeyBoardType.num, "2"),
        const KeyBoardData(KeyBoardType.num, "3"),
        const KeyBoardData(KeyBoardType.num, "0"),
        const KeyBoardData(KeyBoardType.num, "-"),
        const KeyBoardData(KeyBoardType.num, ".")
    ];

    /// 定义键盘事件列表，包括删除和确认键
    static final List<KeyBoardData> _keyboardEventList = [
        const KeyBoardData(KeyBoardType.delete, ""),
        const KeyBoardData(KeyBoardType.confirm, ""),
    ];


    @override
    Widget build(BuildContext context) {
        // 构建键盘对话框的UI
        return Container(
            // 键盘区域
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom,left: 10,right: 10, top: 10),
            decoration: BoxDecoration(
                color: widget.backgroundColor
            ),
            child: Row(
                children: [
                    SizedBox(
                        // 数字键区域
                        width: (MediaQuery.of(context).size.width - 20)  / 4 * 3,
                        child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: _keyboardDataList.map((item) => buildKeyboardItem(item, context)).toList(),
                        ),
                    ),
                    SizedBox(
                        // 功能键区域
                        width: ( MediaQuery.of(context).size.width - 20)  / 4,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: _keyboardEventList.map((item) => buildKeyboardItem(item, context)).toList(),
                        ),
                    ),
                ],
            ),
        );
    }

    /// 构建键盘按钮
    Widget buildKeyboardItem(KeyBoardData keyBoardData, BuildContext context) {
        return GestureDetector(
            onTap: () {


                final TextEditingController controller = widget.controller;

                final text = controller.text;
                final textSelection = controller.selection;
                // 处理删除操作
                if(KeyBoardType.delete == keyBoardData.type){
                    final selectionLength = textSelection.end - textSelection.start;
                    if (selectionLength > 0) {
                        final newText = text.replaceRange(textSelection.start, textSelection.end, '');
                        controller.text = newText;
                        controller.selection = textSelection.copyWith(
                            baseOffset: textSelection.start,
                            extentOffset: textSelection.start,
                        );
                        return;
                    }else{
                        if (textSelection.start == 0) {
                            return;
                        }
                        final previousCodeUnit = text.codeUnitAt(textSelection.start - 1);
                        final offset   = _isUtf16Surrogate(previousCodeUnit) ? 2 : 1;
                        final newStart = textSelection.start - offset;
                        final newEnd   = textSelection.start;
                        final newText  = text.replaceRange(newStart, newEnd, '');

                        controller.text = newText;
                        controller.selection = textSelection.copyWith(baseOffset: newStart, extentOffset: newStart, );
                    }
                }

                // 如果是键盘输入
                if (KeyBoardType.num == keyBoardData.type) {

                    if((text.isNotEmpty && textSelection.start > 0 && keyBoardData.value == '-') || (text.contains('-') && keyBoardData.value == '-')){
                        return;
                    }

                    final newText = text.replaceRange(textSelection.start, textSelection.end, keyBoardData.value);
                    controller.text = newText;
                    controller.selection = textSelection.copyWith(baseOffset: textSelection.start + 1, extentOffset: textSelection.start + 1);
                }
                
                if (KeyBoardType.confirm == keyBoardData.type) {
                    if (widget.onConfirm != null) {
                        widget.onConfirm!(controller.text);
                    }
                }
            },

            child: Container(
                // 按钮的视觉样式
                width: (MediaQuery.of(context).size.width - 50) / 4,
                margin: EdgeInsets.only(top: keyBoardData.type == KeyBoardType.confirm?10:0),
                height: keyBoardData.type == KeyBoardType.confirm ? MediaQuery.of(context).size.width / 6 * 3 + 20: MediaQuery.of(context).size.width / 6,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: keyBoardData.type == KeyBoardType.confirm ? widget.buttonColor : Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: keyBoardData.type == KeyBoardType.num ? Text(keyBoardData.value, style: widget.keyTextStyle) : keyBoardData.type == KeyBoardType.delete ? widget.deleteIcon : Text(widget.buttonText, textDirection: TextDirection.rtl, style: widget.confirmTextStyle),
            )
        );
    }


    /// 格式化数字，插入千位分隔符
    String formatThousands(String text) {
        return text.toString();       
    }

    bool _isUtf16Surrogate(int value) {
        return value & 0xF800 == 0xD800;
    }
}