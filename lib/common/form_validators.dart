dynamic validatePhone(dynamic value) {
  if (value == null || value.isEmpty) {
    return 'Phone number is required';
  }
  return null;
}
