class StringUtils {
  static String replaceTemplate(String template, Map<String, String> replacements) {
    String result = template;
    replacements.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }
}
