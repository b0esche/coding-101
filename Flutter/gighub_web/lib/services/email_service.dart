import 'dart:js' as js;
import 'dart:async';

class EmailService {
  static Future<bool> sendSupportEmail({
    required String name,
    required String email,
    required String message,
    List<String>? attachmentNames,
  }) async {
    // Only try EmailJS - no fallback to mailto
    return await _sendViaEmailJS(name, email, message, attachmentNames);
  }

  static Future<bool> _sendViaEmailJS(
    String name,
    String email,
    String message,
    List<String>? attachmentNames,
  ) async {
    // Check if EmailJS is loaded first
    if (js.context['emailjs'] == null) {
      throw Exception(
        'EmailJS library is not loaded. Please refresh the page and try again.',
      );
    }

    final emailjs = js.context['emailjs'];
    if (emailjs == null) {
      throw Exception(
        'EmailJS is not available. Please check your internet connection.',
      );
    }

    // Format timestamp
    final now = DateTime.now();
    final timeString =
        '${now.day}/${now.month}/${now.year} at ${now.hour}:${now.minute.toString().padLeft(2, '0')}';

    // Prepare template parameters - EmailJS requires verified sender
    final templateParams = {
      // Email must come from verified address (your Gmail)
      'from_name': 'GigHub Support System',
      'from_email': 'b0eschex@gmail.com', // Must be your verified email
      // CRITICAL: This makes replies go to the user
      'reply_to': email, // User's email - this is where replies will go!
      // Email routing
      'to_email': 'b0eschex@gmail.com', // Your email receives it
      'to_name': 'GigHub Support',

      // User information for n8n processing
      'user_name': name,
      'user_email': email, // This is the key for n8n to know who to reply to
      'contact_email': email, // Backup field for user email
      // Email content
      'subject': 'New GigHub Support Request from $name',
      'message':
          '🎧 Support Request from: $name ($email)\n\n$message\n\n${attachmentNames?.isNotEmpty == true ? 'Attachments: ${attachmentNames!.join(', ')}\n\n' : ''}📧 Reply to this email to respond directly to the user.\n⏰ Submitted: $timeString',

      // Template variables for customization
      'name': name,
      'time': timeString,
      'user_message': message,
      'customer_name': name, // Alternative field name
      'customer_email': email, // Alternative field name
    };

    final jsTemplateParams = js.JsObject.jsify(templateParams);

    final completer = Completer<bool>();

    // Success callback
    final onSuccess = js.allowInterop((dynamic result) {
      if (!completer.isCompleted) {
        completer.complete(true);
      }
    });

    // Error callback
    final onError = js.allowInterop((dynamic error) {
      if (!completer.isCompleted) {
        String errorMessage = 'Unknown EmailJS error';

        try {
          // Try to extract meaningful error information
          if (error != null) {
            // Check if it's a JS object with error properties
            if (error is js.JsObject) {
              final status = error['status'];
              final text = error['text'];
              final message = error['message'];

              if (status != null || text != null || message != null) {
                errorMessage =
                    'EmailJS Error - Status: ${status ?? 'unknown'}, Text: ${text ?? 'none'}, Message: ${message ?? 'none'}';
              } else {
                errorMessage = 'EmailJS Error: ${error.toString()}';
              }
            } else {
              errorMessage = 'EmailJS Error: ${error.toString()}';
            }
          }
        } catch (e) {
          errorMessage = 'EmailJS Error (details unavailable): $e';
        }

        completer.completeError(errorMessage);
      }
    });

    try {
      // Try the newer EmailJS send method first
      try {
        final promise = emailjs.callMethod('send', [
          'service_q635zng', // Your service ID
          'template_4bvvpvt', // Your template ID
          jsTemplateParams, // Template parameters
          'hSu3Ct4QWW8iGNm7J', // Public key as 4th parameter (newer method)
        ]);

        // Handle promise resolution
        promise.callMethod('then', [onSuccess]);
        promise.callMethod('catch', [onError]);
      } catch (newMethodError) {
        // Fallback to older method without public key parameter
        final promise = emailjs.callMethod('send', [
          'service_q635zng', // Your service ID
          'template_4bvvpvt', // Your template ID
          jsTemplateParams, // Template parameters
        ]);

        // Handle promise resolution
        promise.callMethod('then', [onSuccess]);
        promise.callMethod('catch', [onError]);
      }

      // Wait for the result with a timeout
      return await completer.future.timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception(
            'Email sending timed out after 15 seconds. This might indicate a network issue or incorrect EmailJS configuration. Please verify your service ID (service_q635zng) and template ID (template_4bvvpvt) in your EmailJS dashboard.',
          );
        },
      );
    } catch (e) {
      throw Exception('Failed to send email via EmailJS: $e');
    }
  }
}
