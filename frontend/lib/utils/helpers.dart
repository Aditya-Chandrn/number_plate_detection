int calculateAge(String dob) {
  DateTime birthDate = DateTime.parse(dob); // Convert string to DateTime
  DateTime today = DateTime.now(); // Get current date

  int age = today.year - birthDate.year;

  // Adjust if birthday hasn't happened yet this year
  if (today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }

  return age;
}
