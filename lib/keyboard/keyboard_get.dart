import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'keyboard_data.dart';
import 'keyborad_input.dart';
import 'keyboard_type.dart';

/// 键盘对话框类，用于展示并处理自定义键盘输入
class KeyBoardGet extends StatefulWidget {

    /// 确认按钮点击回调函数
    final Function? onConfirm;

    /// 输入按键点击回调函数
    final Function? onInput;

    const KeyBoardGet({super.key, this.onConfirm, this.onInput});

    @override
    _KeyBoardGetState createState() => _KeyBoardGetState();
}

/// 键盘对话框的状态类，管理键盘的显示和行为
class _KeyBoardGetState extends State<KeyBoardGet> {

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
        const KeyBoardData(KeyBoardType.confirm, "确认"),
    ];

    TextEditingController numberController = TextEditingController();
    TextEditingController moneyController = TextEditingController();

    /// 定义键盘输入列表，管理当前输入框的状态
    static final List<KeyBoardInput> _keyboardInputList = [
        KeyBoardInput(hintText: "点击输入数量", key: "number", text: "计算数量", controller: TextEditingController()),
        KeyBoardInput(hintText: "点击输入金额", key: "money",  text: "计算金额", controller: TextEditingController()),
    ];

    /// 当前活动的输入框索引
    int inputIndex = 0;

    @override
    void initState() {
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        // 构建键盘对话框的UI
        return ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
                Column(
                    // 显示输入区域
                    children: _keyboardInputList.asMap().entries.map((e) => buildKeyboardInput(e.key, context)).toList(),
                ),
                Container(
                    // 键盘区域
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom,left: 10,right: 10, top: 10),
                    decoration: const BoxDecoration(
                        color: Color(0xFFEEEEEE)
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
                )
            ],
        );
    }

    /// 构建键盘按钮
    Widget buildKeyboardItem(KeyBoardData keyBoardData, BuildContext context) {
        return GestureDetector(
            onTap: () {

                print("按键 ${keyBoardData.toString()}");
                

                final text = _keyboardInputList[inputIndex].controller!.text;
                final textSelection   = _keyboardInputList[inputIndex].controller!.selection;
                final TextEditingController controller = _keyboardInputList[inputIndex].controller!;

                print(textSelection.start);
                print(textSelection.end);

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
                        widget.onConfirm!(_keyboardInputList.map((e) => e.controller!.text).toList());
                    }
                }



            },
            child: Container(
                // 按钮的视觉样式
                width: (MediaQuery.of(context).size.width - 50) / 4 ,
                margin: EdgeInsets.only(top: keyBoardData.type == KeyBoardType.confirm?10:0),
                height: keyBoardData.type == KeyBoardType.confirm ? MediaQuery.of(context).size.width / 6 * 3 + 20: MediaQuery.of(context).size.width / 6,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: keyBoardData.type == KeyBoardType.confirm ? const Color(0xFF3185FC) : Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: keyBoardData.type == KeyBoardType.num ? Text(keyBoardData.value, style: const TextStyle(fontSize: 23, color: Colors.black54, fontWeight: FontWeight.bold)) : keyBoardData.type == KeyBoardType.delete ? const Icon(Icons.backspace_outlined, size: 25, color: Colors.red) : Text(keyBoardData.value, textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
            )
        );
    }

    Widget buildKeyboardInput(int index, BuildContext context) {
        return Container(
            // 输入框的视觉样式
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(width: 0.5, color: Colors.black12 ),
                ),
            ),
            child: Row(
                children: [
                    Text(_keyboardInputList[index].text.toString(), style: const TextStyle(fontSize: 18, color: Colors.black54)),

                    Flexible(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextFormField(
                                autofocus: true,
                                showCursor: true,
                                readOnly: true,
                                controller: _keyboardInputList[index].controller,
                                style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyLarge?.color, 
                                ),
                                decoration: InputDecoration(
                                    counterText: "",
                                    border: InputBorder.none,
                                    hintText: _keyboardInputList[index].hintText,
                                    hintStyle: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).textTheme.bodySmall?.color
                                    )
                                ),
                                onTap: () =>setState(() {
                                    inputIndex = index;
                                }),
                                onChanged: (e) {
                                },
                            ),
                        )
                    )
                ],
            ),
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