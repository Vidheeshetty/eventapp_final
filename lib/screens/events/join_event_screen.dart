import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/event_model.dart';
import '../../utils/routes.dart';
import '../../utils/theme.dart';
import '../../widgets/custom_button.dart';

class JoinEventScreen extends StatefulWidget {
  const JoinEventScreen({super.key});

  @override
  State<JoinEventScreen> createState() => _JoinEventScreenState();
}

class _JoinEventScreenState extends State<JoinEventScreen> {
  EventModel? event;
  bool isLoading = true;
  int selectedAttendees = 1;
  String? eventId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && eventId == null) {
      eventId = args['eventId'] as String;
      _loadEvent(eventId!);
    }
  }

  Future<void> _loadEvent(String eventId) async {
    try {
      final eventProvider = context.read<EventProvider>();
      final loadedEvent = await eventProvider.getEventById(eventId);

      if (mounted) {
        setState(() {
          event = loadedEvent;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading event: $e');
      if (mounted) {
        setState(() {
          event = null;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Join Event')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (event == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Join Event')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('Event not found', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Event'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event!.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        event!.formattedTime,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event!.location,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Icon(Icons.near_me, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${event!.distance.toStringAsFixed(1)} km away',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Number of Attendees Section
            const Text(
              'Number of Attendees',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: selectedAttendees > 1
                        ? () => setState(() => selectedAttendees--)
                        : null,
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selectedAttendees > 1
                            ? AppTheme.primaryColor
                            : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.remove,
                        color: selectedAttendees > 1 ? Colors.white : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),

                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.primaryColor, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '$selectedAttendees',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),

                  IconButton(
                    onPressed: (selectedAttendees < _getMaxSelectable())
                        ? () => setState(() => selectedAttendees++)
                        : null,
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (selectedAttendees < _getMaxSelectable())
                            ? AppTheme.primaryColor
                            : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        color: (selectedAttendees < _getMaxSelectable())
                            ? Colors.white
                            : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Text(
              'Select number of spots to reserve (you + guests)',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Event Details Section
            const Text(
              'Event Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: event!.isFree ? Colors.green : AppTheme.warningColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          event!.isFree ? 'FREE' : '\$${event!.price?.toStringAsFixed(0) ?? '0'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        _calculateDuration(),
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      SizedBox(width: 8),
                      Text('All materials provided', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 4),

                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      SizedBox(width: 8),
                      Text('Refreshments included', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Availability Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.people, color: Colors.blue[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${event!.maxAttendees - event!.currentAttendees} spots remaining out of ${event!.maxAttendees} total',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Important Note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange[700]),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Please arrive 10 minutes early for check-in and safety briefing.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100), // Space for bottom button
          ],
        ),
      ),

      // Bottom Proceed Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Consumer<EventProvider>(
            builder: (context, eventProvider, child) {
              return CustomButton(
                onPressed: eventProvider.isLoading ? null : _handleJoinEvent,
                text: 'Proceed',
                isLoading: eventProvider.isLoading,
                width: double.infinity,
              );
            },
          ),
        ),
      ),
    );
  }

  int _getMaxSelectable() {
    const maxGuestsAllowed = 5; // You can make this configurable
    final availableSpots = event!.maxAttendees - event!.currentAttendees;
    return availableSpots > maxGuestsAllowed ? maxGuestsAllowed : availableSpots;
  }

  String _calculateDuration() {
    final duration = event!.endDate.difference(event!.startDate);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  Future<void> _handleJoinEvent() async {
    try {
      final authProvider = context.read<AuthProvider>();
      final eventProvider = context.read<EventProvider>();

      if (authProvider.currentUser == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please sign in to join events')),
          );
        }
        return;
      }

      // Check if there are enough spots available
      final availableSpots = event!.maxAttendees - event!.currentAttendees;
      if (selectedAttendees > availableSpots) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Only $availableSpots spots remaining'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
        return;
      }

      // Join the event using the user ID
      final userId = authProvider.currentUser!.id;
      final success = await eventProvider.joinEvent(event!.id, userId);

      if (mounted) {
        if (success) {
          // Navigate to confirmation screen
          AppRoutes.navigateToConfirmation(context, {
            'event': event!,
            'attendeeCount': selectedAttendees,
          });
        } else {
          // Show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(eventProvider.errorMessage ?? 'Failed to join event'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error joining event: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred while joining the event'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}