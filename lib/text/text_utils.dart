class TextUtils {


    /// 判断文本内容是否为空
    static bool isEmpty(String text) => text == null || text.isEmpty;

    /// 判断文本内容是否不为空
    static bool isNotEmpty(String text) => !isEmpty(text);

    /// 判断字符串是以xx开头
    static bool startsWith(String str, Pattern prefix, [int index = 0]) => str != null && str.startsWith(prefix, index);

    /// 判断一个字符串以任何给定的前缀开始
    static bool startsWithAny(String str, List<Pattern> prefixes, [int index = 0]) => str != null && prefixes.any((prefix) => str.startsWith(prefix, index));

    /// 判断字符串中是否包含xx
    static bool contains(String str, Pattern searchPattern, [int startIndex = 0]) => str != null && str.contains(searchPattern, startIndex);

    /// 判断一个字符串是否包含任何给定的搜索模式
    static bool containsAny(String str, List<Pattern> searchPatterns, [int startIndex = 0]) => str != null && searchPatterns.any((prefix) => str.contains(prefix, startIndex));

    /// 使用点缩写字符串
    static String abbreviate(String str, int maxWidth, {int offset = 0}) {
        if (isEmpty(str) || str.length <= maxWidth) {
            return str;
        }

        final start = offset < 3 ? offset : maxWidth - 3;
        final end = maxWidth - (offset < 3 ? 3 : offset < maxWidth - 3 ? 0 : 6);

        return '...${str.substring(start, end)}...';
    }

    /// 比较两个字符串是否相同
    static int compare(String str1, String str2) {
        if (str1 == str2) {
            return 0;
        }
        if (str1 == null || str2 == null) {
            return str1 == null ? -1 : 1;
        }
        return str1.compareTo(str2);
    }

    /// 比较两个长度一样的字符串有几个字符不同
    static int hammingDistance(String str1, String str2) {
        if (str1.length != str2.length) {
            throw FormatException('Strings must have the same length');
        }
        var distance = 0;
        for (var i = 0; i < str1.length; i++) {
            if (str1[i] != str2[i]) {
            distance++;
            }
        }
        return distance;
    }

    /// 每隔 x 位加 pattern。比如用来格式化银行卡
    static String formatDigitPattern(String text, {int digit = 4, String pattern = ' '}) {
        final regex = RegExp('(.{$digit})');
        return text.replaceAllMapped(regex, (match) => '${match.group(0)}$pattern').replaceAll(RegExp('$pattern\$'), '');
    }

    /// 每隔 x 位加 pattern, 从末尾开始
    static String formatDigitPatternEnd(String text, {int digit = 4, String pattern = ' '}) {
        final temp = reverse(text);
        final formattedTemp = formatDigitPattern(temp, digit: digit, pattern: pattern);
        return reverse(formattedTemp);
    }

    /// 每隔 4 位加空格
    static String formatSpace4(String text) => formatDigitPattern(text);

    /// 每隔 3 三位加逗号
    /// num 数字或数字字符串。int型。
    static String formatComma3(Object num) => formatDigitPatternEnd(num.toString(), digit: 3, pattern: ',');

    /// 每隔 3 三位加逗号
    /// num 数字或数字字符串。double型。
    static String formatDoubleComma3(Object num, {int digit = 3, String pattern = ','}) {
        final parts = num.toString().split('.');
        final left = formatDigitPatternEnd(parts[0], digit: digit, pattern: pattern);
        final right = parts.length > 1 ? parts[1] : '';
        return '$left.$right';
    }

    /// 隐藏手机号中间 n 位
    static String hideNumber(String phoneNo, {int start = 3, int end = 7, String replacement = '****'}) {
        return phoneNo.replaceRange(start, end, replacement);
    }

    /// 替换字符串中的数据
    static String replace(String text, Pattern from, String replace) {
        return text.replaceAll(from, replace);
    }

    /// 按照正则切割字符串
    static List<String> split(String text, Pattern pattern) => text.split(pattern);

    /// 反转字符串
    static String reverse(String text) {
        if (isEmpty(text)) {
            return '';
        }
        final sb = StringBuffer();
        for (var i = text.length - 1; i >= 0; i--) {
            final codeUnitAt = text.codeUnitAt(i);
            sb.writeCharCode(codeUnitAt);
        }
        return sb.toString();
    }

    String currencyFormat(int money) {
        if (money == null) {
            return "";
        }
        final moneyStr = money.toString();
        var finalStr = "";
        final groupSize = 3;
        final oddNumberLength = moneyStr.length - (moneyStr.length ~/ groupSize) * groupSize;
        if (oddNumberLength > 0) {
            finalStr += moneyStr.substring(0, oddNumberLength);
            if (moneyStr.length > groupSize) {
            finalStr += ",";
            }
        }
        for (var i = oddNumberLength; i < moneyStr.length; i += groupSize) {
            finalStr += moneyStr.substring(i, i + groupSize);
            if (i + groupSize < moneyStr.length - 1) {
            finalStr += ",";
            }
        }
        return finalStr;
    }
}
