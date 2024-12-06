String toTitleCase(String input) {
  if (input.isEmpty) return input;
  return input.split(' ').map((word) {
    if (word.isEmpty) return word; // Handle empty words
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}
