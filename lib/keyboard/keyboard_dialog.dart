import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'keyboard_data.dart';
import 'keyborad_input.dart';
import 'keyboard_type.dart';

/// 键盘对话框类，用于展示并处理自定义键盘输入
class KeyBoardDialog extends StatefulWidget {

    /// 确认按钮点击回调函数
    final Function? onConfirm;

    /// 输入按键点击回调函数
    final Function? onInput;

    const KeyBoardDialog({super.key, this.onConfirm, this.onInput});

    @override
    // 忽略库私有类型在公共API中的使用
    _KeyBoardDialogState createState() => _KeyBoardDialogState();
}

/// 键盘对话框的状态类，管理键盘的显示和行为
class _KeyBoardDialogState extends State<KeyBoardDialog> {

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

    /// 定义键盘输入列表，管理当前输入框的状态
    static final List<KeyBoardInput> _keyboardInputList = [
        KeyBoardInput(value: "", key: "number", text: "计算数量"),
        KeyBoardInput(value: "", key: "money",  text: "计算金额"),
    ];

    /// 当前输入的键类型标识
    String inputKey = "number";

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
                    children: _keyboardInputList.map((e) => buildKeyboardInput(e, context)).toList(),
                ),
                Container(
                    // 键盘区域
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                    decoration: const BoxDecoration(
                        color: Colors.white
                    ),
                    child: Row(
                        children: [
                            SizedBox(
                                // 数字键区域
                                width: MediaQuery.of(context).size.width / 4 * 3,
                                child: Wrap(
                                    spacing: 0,
                                    runSpacing: 0,
                                    children: _keyboardDataList.map((item) => buildKeyboardItem(item, context)).toList(),
                                ),
                            ),
                            SizedBox(
                                // 功能键区域
                                width: MediaQuery.of(context).size.width / 4,
                                child: Column(
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
            behavior: HitTestBehavior.opaque,
            onTap: () {
                // 处理按钮点击事件
                String value = keyBoardData.value.toString();
                String text = _keyboardInputList[inputIndex].value.toString();

                

                // 根据按键类型更新输入框内容
                if (KeyBoardType.num == keyBoardData.type) {
                    if (widget.onInput != null) {
                        widget.onInput!(value);
                    }

                    if (keyBoardData.value == '-') {
                        if (value.isEmpty || value == '-') {
                            text = '-';
                        } else {
                            text = (double.parse(text) * -1).toString();
                        }
                    } else {
                        text = text + value;
                    }
                }

                if (KeyBoardType.delete == keyBoardData.type) {
                    if (text.isNotEmpty) {
                        text = text.substring(0, text.length - 1);
                    }
                }

                if (KeyBoardType.confirm == keyBoardData.type) {
                    if (widget.onConfirm != null) {
                        widget.onConfirm!(_keyboardInputList.map((e) => e.value).toList());
                    }
                }

                setState(() {
                    _keyboardInputList[inputIndex].value = text;
                });
            },
            child: Container(
                // 按钮的视觉样式
                width: MediaQuery.of(context).size.width / 4,
                height: keyBoardData.type == KeyBoardType.num ? MediaQuery.of(context).size.width / 6 : MediaQuery.of(context).size.width / 6 * 2,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: keyBoardData.type == KeyBoardType.confirm ? const Color(0xFF3185FC) : Colors.transparent,
                    border: Border(
                        bottom: BorderSide(width: keyBoardData.type == KeyBoardType.num ? 0.5 : 0, color: Colors.black12),
                        right: const BorderSide(width: 0.5, color: Colors.black12),
                    ),
                ),
                child: keyBoardData.type == KeyBoardType.num ? Text(keyBoardData.value, style: const TextStyle(fontSize: 23, color: Colors.black54, fontWeight: FontWeight.bold)) : keyBoardData.type == KeyBoardType.delete ? const Icon(CupertinoIcons.delete_left, size: 30, color: Colors.red) : Text(keyBoardData.value, textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
            )
        );
    }

    /// 构建输入框区域
    Widget buildKeyboardInput(KeyBoardInput keyBoardInput, BuildContext context) {
        return GestureDetector(
            onTap: () {
                // 处理输入框点击事件，切换当前活动的输入框
                for (int i = 0; i < _keyboardInputList.length; i++) {
                    if (_keyboardInputList[i].key == keyBoardInput.key) {
                        setState(() {
                            inputIndex = i;
                            inputKey = keyBoardInput.key.toString();
                        });
                    }
                }
            },
            child: Container(
                // 输入框的视觉样式
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(width: 0.5, color: inputKey == keyBoardInput.key ? Colors.black : Colors.black12),
                    ),
                ),
                child: Row(
                    children: [
                        Text(keyBoardInput.text.toString(), style: const TextStyle(fontSize: 18, color: Colors.black54)),
                        Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(formatThousands(keyBoardInput.value.toString()), style: const TextStyle(fontSize: 18, color: Colors.black87)),
                        )
                    ],
                ),
            ),
        );
    }

    /// 格式化数字，插入千位分隔符
    String formatThousands(String text) {
        return text.toString();
    }
}