import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../Data/models/rave.dart';
import '../../../../Data/models/users.dart';
import '../../../../Data/models/group_chat.dart';
import '../../../../Data/interfaces/database_repository.dart';
import '../../../../Data/services/localization_service.dart';
import 'user_search_dialog.dart';

class CreateRaveDialog extends StatefulWidget {
  const CreateRaveDialog({super.key});

  @override
  State<CreateRaveDialog> createState() => _CreateRaveDialogState();
}

class _CreateRaveDialogState extends State<CreateRaveDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ticketShopController = TextEditingController();
  final _additionalLinkController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  bool _isMultiDay = false;
  bool _createGroupChat = true;
  List<AppUser> _selectedDJs = [];
  List<AppUser> _selectedCollaborators = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _ticketShopController.dispose();
    _additionalLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0A0A0A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF333333), width: 1),
      ),
      title: Text(
        AppLocale.createRave.getString(context),
        style: const TextStyle(
          color: Color(0xFFD4AF37),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: AppLocale.raveName.getString(context),
                  validator:
                      (value) =>
                          value?.trim().isEmpty == true
                              ? 'Name is required'
                              : null,
                ),
                const SizedBox(height: 16),

                _buildDateTimeSection(),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _locationController,
                  label: AppLocale.raveLocation.getString(context),
                  validator:
                      (value) =>
                          value?.trim().isEmpty == true
                              ? 'Location is required'
                              : null,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _descriptionController,
                  label: AppLocale.raveDescription.getString(context),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _ticketShopController,
                  label: AppLocale.ticketShop.getString(context),
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _additionalLinkController,
                  label: AppLocale.additionalLink.getString(context),
                ),
                const SizedBox(height: 16),

                _buildUserSelection(),
                const SizedBox(height: 16),

                _buildGroupChatOption(),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(
            AppLocale.cancel.getString(context),
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _createRave,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4AF37),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child:
              _isLoading
                  ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  )
                  : Text(
                    AppLocale.createRave.getString(context),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF333333)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD4AF37)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
      ),
    );
  }

  Widget _buildDateTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _isMultiDay,
              onChanged: (value) {
                setState(() {
                  _isMultiDay = value ?? false;
                  if (!_isMultiDay) {
                    _endDate = null;
                  }
                });
              },
              activeColor: const Color(0xFFD4AF37),
            ),
            Text(
              AppLocale.multiDay.getString(context),
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: _buildDateField(
                label: AppLocale.raveDate.getString(context),
                date: _startDate,
                onTap: () => _selectDate(context, true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: _buildTimeField()),
          ],
        ),

        if (_isMultiDay) ...[
          const SizedBox(height: 12),
          _buildDateField(
            label: AppLocale.endDate.getString(context),
            date: _endDate,
            onTap: () => _selectDate(context, false),
          ),
        ],
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF333333)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today,
              color: Color(0xFFD4AF37),
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                date != null ? DateFormat('MMM dd, yyyy').format(date) : label,
                style: TextStyle(
                  color: date != null ? Colors.white : Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField() {
    return GestureDetector(
      onTap: () => _selectTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF333333)),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: Color(0xFFD4AF37), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _startTime != null
                    ? _startTime!.format(context)
                    : AppLocale.startTime.getString(context),
                style: TextStyle(
                  color: _startTime != null ? Colors.white : Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUserSelectionButton(
          label: AppLocale.addDJs.getString(context),
          users: _selectedDJs,
          userType: UserType.dj,
          onChanged: (users) => setState(() => _selectedDJs = users),
        ),
        const SizedBox(height: 12),
        _buildUserSelectionButton(
          label: AppLocale.addCollaborators.getString(context),
          users: _selectedCollaborators,
          userType: UserType.booker,
          onChanged: (users) => setState(() => _selectedCollaborators = users),
        ),
      ],
    );
  }

  Widget _buildUserSelectionButton({
    required String label,
    required List<AppUser> users,
    required UserType userType,
    required Function(List<AppUser>) onChanged,
  }) {
    return GestureDetector(
      onTap: () => _showUserSearch(userType, users, onChanged),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF333333)),
        ),
        child: Row(
          children: [
            Icon(
              userType == UserType.dj ? Icons.headset : Icons.people,
              color: const Color(0xFFD4AF37),
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child:
                  users.isEmpty
                      ? Text(
                        label,
                        style: const TextStyle(color: Colors.white70),
                      )
                      : Wrap(
                        spacing: 4,
                        children:
                            users.map((user) {
                              String name = '';
                              if (user is DJ) name = user.name;
                              if (user is Booker) name = user.name;
                              return Chip(
                                label: Text(
                                  name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                backgroundColor: const Color(0xFFD4AF37),
                                deleteIcon: const Icon(
                                  Icons.close,
                                  color: Colors.black,
                                  size: 16,
                                ),
                                onDeleted: () {
                                  final updatedUsers = List<AppUser>.from(users)
                                    ..remove(user);
                                  onChanged(updatedUsers);
                                },
                              );
                            }).toList(),
                      ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupChatOption() {
    return Row(
      children: [
        Checkbox(
          value: _createGroupChat,
          onChanged: (value) {
            setState(() {
              _createGroupChat = value ?? true;
            });
          },
          activeColor: const Color(0xFFD4AF37),
        ),
        Expanded(
          child: Text(
            AppLocale.createGroupChat.getString(context),
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isStartDate
              ? (_startDate ?? DateTime.now())
              : (_endDate ?? _startDate ?? DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFD4AF37),
              onPrimary: Colors.black,
              surface: Color(0xFF1A1A1A),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // If end date is before start date, reset it
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFD4AF37),
              onPrimary: Colors.black,
              surface: Color(0xFF1A1A1A),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  void _showUserSearch(
    UserType userType,
    List<AppUser> currentUsers,
    Function(List<AppUser>) onChanged,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => UserSearchDialog(
            userType: userType,
            selectedUsers: currentUsers,
            onUsersSelected: onChanged,
          ),
    );
  }

  Future<void> _createRave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a start date')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception('User not authenticated');

      // Combine date and time
      DateTime startDateTime = _startDate!;
      if (_startTime != null) {
        startDateTime = DateTime(
          _startDate!.year,
          _startDate!.month,
          _startDate!.day,
          _startTime!.hour,
          _startTime!.minute,
        );
      }

      final rave = Rave(
        id: '', // Will be set by Firestore
        name: _nameController.text.trim(),
        organizerId: currentUser.uid,
        startDate: startDateTime,
        endDate: _endDate,
        startTime: _startTime?.format(context) ?? '00:00',
        location: _locationController.text.trim(),
        description: _descriptionController.text.trim(),
        ticketShopLink:
            _ticketShopController.text.trim().isNotEmpty
                ? _ticketShopController.text.trim()
                : null,
        additionalLink:
            _additionalLinkController.text.trim().isNotEmpty
                ? _additionalLinkController.text.trim()
                : null,
        djIds: _selectedDJs.map((dj) => dj.id).toList(),
        collaboratorIds:
            _selectedCollaborators.map((collab) => collab.id).toList(),
        attendingUserIds: [],
        hasGroupChat: _createGroupChat,
        groupChatId: _createGroupChat ? null : '', // Will be created if needed
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Create the rave in Firestore
      final docRef = await FirebaseFirestore.instance
          .collection('raves')
          .add(rave.toJson());

      // Update the rave with its ID
      await docRef.update({'id': docRef.id});

      // Create group chat if requested
      if (_createGroupChat) {
        await _createGroupChatForRave(docRef.id, rave);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocale.raveCreated.getString(context)),
            backgroundColor: const Color(0xFFD4AF37),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocale.raveCreationFailed.getString(context)}: $e',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _createGroupChatForRave(String raveId, Rave rave) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return;
      }

      // Calculate auto-delete time (48 hours after rave end)
      final raveEndTime =
          rave.endDate ??
          rave.startDate.add(
            Duration(hours: 6),
          ); // Default 6 hours if no end date
      final autoDeleteAt = raveEndTime.add(Duration(hours: 48));

      // Collect all member IDs
      final memberIds =
          <String>{
            currentUser.uid, // Organizer
            ..._selectedDJs.map((dj) => dj.id),
            ..._selectedCollaborators.map((collab) => collab.id),
          }.toList();

      final groupChat = GroupChat(
        id: '', // Will be set by repository
        raveId: raveId,
        name: rave.name,
        memberIds: memberIds,
        createdAt: DateTime.now(),
        autoDeleteAt: autoDeleteAt,
      );

      // Create the group chat using repository
      final createdGroupChat = await context
          .read<DatabaseRepository>()
          .createGroupChat(groupChat);

      // Update the rave with the group chat ID
      await FirebaseFirestore.instance.collection('raves').doc(raveId).update({
        'groupChatId': createdGroupChat.id,
      });
    } catch (_) {
      // Don't fail the rave creation if group chat fails
    }
  }
}
