import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/event_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../utils/theme.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _maxAttendeesController = TextEditingController();
  final _priceController = TextEditingController();

  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  bool _isFree = true;
  String? _selectedImage;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _maxAttendeesController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Cover Image
              const Text(
                'Event Cover Image',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error, color: Colors.red),
                              Text('Failed to load image'),
                            ],
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  )
                      : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined,
                          size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Add Cover Image',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Event Title
              CustomTextField(
                controller: _titleController,
                label: 'Event Title',
                hint: 'Enter event title',
                validator: (value) =>
                value?.isEmpty ?? true ? 'Title is required' : null,
              ),
              const SizedBox(height: 20),

              // Event Description
              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe your event',
                maxLines: 4,
                validator: (value) =>
                value?.isEmpty ?? true ? 'Description is required' : null,
              ),
              const SizedBox(height: 20),

              // Location
              CustomTextField(
                controller: _locationController,
                label: 'Location',
                hint: 'Event location',
                prefixIcon: Icons.location_on_outlined,
                validator: (value) =>
                value?.isEmpty ?? true ? 'Location is required' : null,
              ),
              const SizedBox(height: 24),

              // Date and Time Section
              const Text(
                'Date & Time',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildDateTimeField(
                      'Start Date',
                      _startDate != null
                          ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                          : null,
                          () => _selectDate(true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDateTimeField(
                      'Start Time',
                      _startTime?.format(context),
                          () => _selectTime(true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildDateTimeField(
                      'End Date',
                      _endDate != null
                          ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                          : null,
                          () => _selectDate(false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDateTimeField(
                      'End Time',
                      _endTime?.format(context),
                          () => _selectTime(false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Max Attendees
              CustomTextField(
                controller: _maxAttendeesController,
                label: 'Maximum Attendees',
                hint: 'Enter max number',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.people_outline,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Max attendees is required';
                  }
                  if (int.tryParse(value!) == null) {
                    return 'Enter valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Pricing Section
              const Text(
                'Pricing',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Free'),
                      value: true,
                      groupValue: _isFree,
                      onChanged: (value) => setState(() => _isFree = value!),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: const Text('Paid'),
                      value: false,
                      groupValue: _isFree,
                      onChanged: (value) => setState(() => _isFree = value!),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),

              if (!_isFree) ...[
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _priceController,
                  label: 'Price (\$)',
                  hint: 'Enter price',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.attach_money,
                  validator: (value) {
                    if (!_isFree && (value?.isEmpty ?? true)) {
                      return 'Price is required';
                    }
                    if (!_isFree && double.tryParse(value!) == null) {
                      return 'Enter valid price';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 40),

              // Create Button
              Consumer<EventProvider>(
                builder: (context, eventProvider, child) {
                  return CustomButton(
                    onPressed: eventProvider.isLoading ? null : _createEvent,
                    text: 'Create Event',
                    isLoading: eventProvider.isLoading,
                    width: double.infinity,
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeField(String label, String? value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              value ?? 'Select $label',
              style: TextStyle(
                fontSize: 14,
                color: value != null ? Colors.black : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        if (isStart) {
          _startDate = date;
        } else {
          _endDate = date;
        }
      });
    }
  }

  Future<void> _selectTime(bool isStart) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        if (isStart) {
          _startTime = time;
        } else {
          _endTime = time;
        }
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        // In a real app, upload to storage and get URL
        // For demo, use a placeholder image with timestamp
        setState(() {
          _selectedImage =
          'https://picsum.photos/300/180?random=${DateTime.now().millisecondsSinceEpoch}';
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image selected successfully!'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
      debugPrint('Image picker error: $e');
    }
  }

  Future<void> _createEvent() async {
    if (!_formKey.currentState!.validate()) return;

    if (_startDate == null ||
        _startTime == null ||
        _endDate == null ||
        _endTime == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select date and time')),
        );
      }
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    // Get current user info safely
    final currentUser = authProvider.currentUser;
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign in to create events')),
        );
      }
      return;
    }

    final startDateTime = DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
      _startTime!.hour,
      _startTime!.minute,
    );

    final endDateTime = DateTime(
      _endDate!.year,
      _endDate!.month,
      _endDate!.day,
      _endTime!.hour,
      _endTime!.minute,
    );

    // Validate dates
    if (endDateTime.isBefore(startDateTime)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End date cannot be before start date')),
        );
      }
      return;
    }

    // Create the event using EventProvider
    final success = await eventProvider.createEvent(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      startDate: startDateTime,
      endDate: endDateTime,
      location: _locationController.text.trim(),
      organizerName: currentUser.name,
      maxAttendees: int.parse(_maxAttendeesController.text),
      isFree: _isFree,
      price: _isFree ? null : double.parse(_priceController.text),
    );

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event created successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
            Text(eventProvider.errorMessage ?? 'Failed to create event'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}