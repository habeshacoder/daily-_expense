String capitalizeTitle(String title) {
  if (title.isEmpty) return title;

  // Split the title into words
  List<String> words = title.split(' ');

  // Capitalize the first letter of each word
  List<String> capitalizedWords = words.map((word) {
    if (word.length > 1) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    } else {
      return word.toUpperCase(); // Handle single letter words
    }
  }).toList();

  // Join the capitalized words back into a single string
  return capitalizedWords.join(' ');
}
