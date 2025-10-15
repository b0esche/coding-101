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
    final Completer<bool> completer = Completer<bool>();

    try {
      // Check if EmailJS is loaded
      if (js.context['emailjs'] == null) {
        throw Exception('EmailJS is not loaded');
      }

      // Format timestamp
      final now = DateTime.now();
      final timeString =
          '${now.day}/${now.month}/${now.year} at ${now.hour}:${now.minute.toString().padLeft(2, '0')}';

      // Prepare template parameters
      final templateParams = {
        'name': name,
        'message':
            '$message\n\n${attachmentNames?.isNotEmpty == true ? 'Attachments: ${attachmentNames!.join(', ')}\n\n' : ''}Contact Email: $email',
        'time': timeString,
      };

      // Convert to JS object
      final jsTemplateParams = js.JsObject.jsify(templateParams);

      // Get EmailJS object
      final emailjs = js.context['emailjs'];

      // Create success and error callbacks
      final onSuccess = js.allowInterop((dynamic response) {
        if (!completer.isCompleted) {
          completer.complete(true);
        }
      });

      final onError = js.allowInterop((dynamic error) {
        if (!completer.isCompleted) {
          completer.completeError('EmailJS error: $error');
        }
      });

      // Send email using EmailJS
      final jsPromise = emailjs.callMethod('send', [
        'service_q635zng',
        'template_4bvvpvt',
        jsTemplateParams,
      ]);

      // Handle the promise
      jsPromise.callMethod('then', [onSuccess, onError]);

      // Wait for completion with timeout
      return await completer.future.timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('Email sending timed out'),
      );
    } catch (e) {
      if (!completer.isCompleted) {
        completer.completeError(e);
      }
      throw Exception('Failed to send email: $e');
    }
  }
}
