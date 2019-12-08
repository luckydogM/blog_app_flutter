
String ParseHtmlString(String htmlString) {
  var document = htmlString.replaceAll(new RegExp(r'<.*?>'), '');
  return document;
}
