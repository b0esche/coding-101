import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../theme/palette.dart';
import '../services/email_service.dart';

class ContactSupportDialog extends StatefulWidget {
  const ContactSupportDialog({super.key});

  @override
  State<ContactSupportDialog> createState() => _ContactSupportDialogState();
}

class _ContactSupportDialogState extends State<ContactSupportDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  final List<PlatformFile> _selectedFiles = [];
  bool _isLoading = false;

  final int _maxMessageLength = 500;
  final int _maxFiles = 3;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
      );

      if (result != null) {
        if (_selectedFiles.length + result.files.length > _maxFiles) {
          _showErrorSnackBar('Maximum $_maxFiles screenshots allowed');
          return;
        }

        setState(() {
          _selectedFiles.addAll(result.files);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error picking files: $e');
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.sometypeMono(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.sometypeMono(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get attachment names
      List<String> attachmentNames = _selectedFiles
          .map((file) => file.name)
          .toList();

      // Send email via EmailService
      bool success = await EmailService.sendSupportEmail(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        message: _messageController.text.trim(),
        attachmentNames: attachmentNames.isNotEmpty ? attachmentNames : null,
      );

      if (success) {
        _showSuccessSnackBar('Your message has been sent successfully!');
        Navigator.of(context).pop();
      } else {
        _showErrorSnackBar('Failed to send message. Please try again.');
      }
    } catch (e) {
      _showErrorSnackBar('Error sending message: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Palette.primalBlack,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.support_agent_rounded,
                      size: 28,
                      color: Palette.forgedGold,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Contact Support',
                        style: GoogleFonts.sometypeMono(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Palette.glazedWhite,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close_rounded,
                        color: Palette.concreteGrey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Name Field
                Text(
                  'Name *',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Palette.forgedGold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  style: GoogleFonts.sometypeMono(color: Palette.glazedWhite),
                  decoration: InputDecoration(
                    hintText: 'Enter your full name',
                    hintStyle: GoogleFonts.sometypeMono(
                      color: Palette.concreteGrey,
                    ),
                    filled: true,
                    fillColor: Palette.shadowGrey.o(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Palette.concreteGrey.o(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Palette.concreteGrey.o(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Palette.forgedGold),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Email Field
                Text(
                  'Email Address *',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Palette.forgedGold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.sometypeMono(color: Palette.glazedWhite),
                  decoration: InputDecoration(
                    hintText: 'Enter your email address',
                    hintStyle: GoogleFonts.sometypeMono(
                      color: Palette.concreteGrey,
                    ),
                    filled: true,
                    fillColor: Palette.shadowGrey.o(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Palette.concreteGrey.o(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Palette.concreteGrey.o(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Palette.forgedGold),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email address is required';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Message Field
                Text(
                  'Message * (${_messageController.text.length}/$_maxMessageLength)',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Palette.forgedGold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _messageController,
                  maxLines: 6,
                  maxLength: _maxMessageLength,
                  style: GoogleFonts.sometypeMono(color: Palette.glazedWhite),
                  decoration: InputDecoration(
                    hintText: 'Describe your issue or question...',
                    hintStyle: GoogleFonts.sometypeMono(
                      color: Palette.concreteGrey,
                    ),
                    filled: true,
                    fillColor: Palette.shadowGrey.o(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Palette.concreteGrey.o(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Palette.concreteGrey.o(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Palette.forgedGold),
                    ),
                    counterStyle: GoogleFonts.sometypeMono(
                      color: Palette.concreteGrey,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {}); // Update character count
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Message is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Screenshots Section
                Text(
                  'Screenshots (Optional, max $_maxFiles)',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Palette.forgedGold,
                  ),
                ),
                const SizedBox(height: 8),

                if (_selectedFiles.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Palette.shadowGrey.o(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Palette.concreteGrey.o(0.3)),
                    ),
                    child: Column(
                      children: _selectedFiles.asMap().entries.map((entry) {
                        int index = entry.key;
                        PlatformFile file = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.image_rounded,
                                color: Palette.accentBlue,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  file.name,
                                  style: GoogleFonts.sometypeMono(
                                    color: Palette.glazedWhite,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                onPressed: () => _removeFile(index),
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 24,
                                  minHeight: 24,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                if (_selectedFiles.length < _maxFiles)
                  OutlinedButton.icon(
                    onPressed: _pickFiles,
                    icon: Icon(
                      Icons.add_photo_alternate_rounded,
                      color: Palette.accentBlue,
                    ),
                    label: Text(
                      'Add Screenshots',
                      style: GoogleFonts.sometypeMono(
                        color: Palette.accentBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Palette.accentBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.forgedGold,
                      foregroundColor: Palette.primalBlack,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Palette.primalBlack,
                              ),
                            ),
                          )
                        : Text(
                            'Send Message',
                            style: GoogleFonts.sometypeMono(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // Info Text
                Text(
                  'Your message will be sent directly to our support team.',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 12,
                    color: Palette.concreteGrey,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
