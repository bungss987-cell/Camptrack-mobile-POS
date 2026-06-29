/// Centralized form validators for the CampTrack app.
class Validators {
  Validators._();

  /// Validates that a field is not empty
  static String? required(String? value, [String fieldName = 'Field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName wajib diisi';
    }
    return null;
  }

  /// Validates email format
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email wajib diisi';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }

    return null;
  }

  /// Validates password (min 6 characters)
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi';
    }

    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }

    return null;
  }

  /// Validates password confirmation matches
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password wajib diisi';
    }

    if (value != password) {
      return 'Password tidak cocok';
    }

    return null;
  }

  /// Validates phone number (Indonesian format)
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor HP wajib diisi';
    }

    // Remove spaces and dashes
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');

    // Indonesian phone: starts with 08 or +628, 10-14 digits total
    final phoneRegex = RegExp(r'^(\+62|62|0)8[1-9][0-9]{7,11}$');

    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Format nomor HP tidak valid (contoh: 081234567890)';
    }

    return null;
  }

  /// Validates a name (min 2 characters, only letters and spaces)
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama wajib diisi';
    }

    if (value.trim().length < 2) {
      return 'Nama minimal 2 karakter';
    }

    return null;
  }

  /// Validates address (min 10 characters)
  static String? address(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Alamat wajib diisi';
    }

    if (value.trim().length < 10) {
      return 'Alamat terlalu pendek (minimal 10 karakter)';
    }

    return null;
  }

  /// Validates that quantity is >= 1 and <= max
  static String? quantity(String? value, int maxStock) {
    if (value == null || value.isEmpty) {
      return 'Jumlah wajib diisi';
    }

    final qty = int.tryParse(value);
    if (qty == null) {
      return 'Masukkan angka yang valid';
    }

    if (qty < 1) {
      return 'Minimal 1 unit';
    }

    if (qty > maxStock) {
      return 'Stok tersedia hanya $maxStock unit';
    }

    return null;
  }

  /// Validates date is not in the past
  static String? futureDate(DateTime? value) {
    if (value == null) {
      return 'Tanggal wajib dipilih';
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (value.isBefore(today)) {
      return 'Tanggal tidak boleh di masa lalu';
    }

    return null;
  }

  /// Validates end date is after start date
  static String? endDateAfterStart(DateTime? endDate, DateTime? startDate) {
    if (endDate == null) {
      return 'Tanggal kembali wajib dipilih';
    }

    if (startDate == null) {
      return 'Pilih tanggal pinjam terlebih dahulu';
    }

    if (endDate.isBefore(startDate)) {
      return 'Tanggal kembali harus setelah tanggal pinjam';
    }

    return null;
  }
}
