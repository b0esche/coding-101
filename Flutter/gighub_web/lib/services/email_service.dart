class EmailService {
  // For testing purposes, I'll use a simple HTTP endpoint
  // In production, you would set up EmailJS or similar service

  static Future<bool> sendSupportEmail({
    required String name,
    required String email,
    required String message,
    List<String>? attachmentNames,
  }) async {
    try {
      // For now, we'll use a mock implementation that always succeeds
      // In a real implementation, you would:
      // 1. Set up EmailJS with your account
      // 2. Use the EmailJS JavaScript API
      // 3. Or use a backend service to send emails

      await Future.delayed(
        const Duration(seconds: 2),
      ); // Simulate network delay

      // Log the email data (for debugging)
      print('Sending support email:');
      print('Name: $name');
      print('Email: $email');
      print('Message: $message');
      if (attachmentNames?.isNotEmpty == true) {
        print('Attachments: ${attachmentNames!.join(', ')}');
      }

      // For demo purposes, we'll always return success
      // In production, replace this with actual email sending logic
      return true;
    } catch (e) {
      print('Error sending email: $e');
      return false;
    }
  }
}
