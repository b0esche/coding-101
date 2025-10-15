import 'dart:js' as js;
import 'dart:js_util' as js_util;
import 'dart:html' as html;

class EmailService {
  static Future<bool> sendSupportEmail({
    required String name,
    required String email,
    required String message,
    List<String>? attachmentNames,
  }) async {
    try {
      // Try EmailJS first to send actual email to your Gmail
      final emailJSResult = await _tryEmailJS(
        name,
        email,
        message,
        attachmentNames,
      );
      if (emailJSResult) {
        print('Email sent successfully to b0eschex@gmail.com via EmailJS');
        return true;
      }

      // Fallback to mailto link if EmailJS fails
      print('EmailJS failed, using mailto fallback');
      return _useMailtoFallback(name, email, message, attachmentNames);
    } catch (e) {
      print('Error in sendSupportEmail: $e');
      // Still try mailto as last resort
      return _useMailtoFallback(name, email, message, attachmentNames);
    }
  }

  static Future<bool> _tryEmailJS(
    String name,
    String email,
    String message,
    List<String>? attachmentNames,
  ) async {
    try {
      // Check if EmailJS is available
      if (js.context['emailjs'] == null) {
        print('EmailJS is not available');
        return false;
      }

      // Prepare template parameters that match your EmailJS template
      // Template expects: {{name}}, {{message}}, {{time}}
      final now = DateTime.now();
      final timeString =
          '${now.day}/${now.month}/${now.year} at ${now.hour}:${now.minute.toString().padLeft(2, '0')}';

      final Map<String, dynamic> emailParams = {
        'name': name,
        'message':
            '''$message

${attachmentNames?.isNotEmpty == true ? '\nAttachments: ${attachmentNames!.join(', ')}' : ''}

Contact Email: $email''',
        'time': timeString,
      };

      print('Sending support email to b0eschex@gmail.com via EmailJS');
      print('Email params: $emailParams');

      // Call EmailJS directly - this sends a direct email through your Gmail service
      final emailjs = js.context['emailjs'];
      final jsParams = js.JsObject.jsify(emailParams);

      // Send via EmailJS - this will send a plain email to your Gmail
      // EmailJS will use your Gmail service to forward the email to b0eschex@gmail.com
      final jsPromise = emailjs.callMethod('send', [
        'service_q635zng', // Your Gmail service ID from EmailJS
        'contact_form', // Use a basic template or create a minimal one
        jsParams,
        'fDOYvXjaxKpBcGKWd', // Your public key
      ]);

      // Convert JavaScript Promise to Dart Future
      await js_util.promiseToFuture(jsPromise);

      print('Email successfully sent to b0eschex@gmail.com');
      return true;
    } catch (e) {
      print('EmailJS error: $e');
      return false;
    }
  }

  static bool _useMailtoFallback(
    String name,
    String email,
    String message,
    List<String>? attachmentNames,
  ) {
    try {
      // Create mailto URL
      final subject = Uri.encodeComponent('GigHub Support Request from $name');
      final body = Uri.encodeComponent('''
From: $name ($email)

Message: 
$message

${attachmentNames?.isNotEmpty == true ? '\nAttachments mentioned: ${attachmentNames!.join(', ')}' : ''}

---
This email was sent via GigHub Contact Support.
Please reply to: $email
''');

      final mailtoUrl = 'mailto:b0eschex@gmail.com?subject=$subject&body=$body';

      // Open mailto link
      html.window.open(mailtoUrl, '_blank');

      print('Opened mailto link');
      return true;
    } catch (e) {
      print('Mailto fallback error: $e');
      return false;
    }
  }
}
