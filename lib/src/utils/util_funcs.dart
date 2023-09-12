// Html 용 특수문자를 일반문자로 변환
String htmlEscapeToNormal(String input, {bool escape = true}) {
  var table = const [
    ['&', '&amp;'],
    ['<', '&lt;'],
    ['>', '&gt;'],
    ['"', '&quot;'],
    ["'", '&#x27;'],
    ['\n\n', '<p>'],
    ['', '</p>'],
    ['/', '&#x2F;'],
    ['`', '&#96;'],
    ['=', '&#x3D;'],
  ];
  if (!escape) {
    table = table.reversed.toList();
  }
  for (var item in table) {
    input = input.replaceAll(item[1], item[0]);
  }
  return input;
}
