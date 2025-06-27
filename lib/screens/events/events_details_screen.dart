import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/event_provider.dart';
import '../../models/event_model.dart';
import '../../utils/routes.dart';
import '../../utils/theme.dart';
import '../../widgets/custom_button.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  EventModel? event;
  bool isLoading = true;
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
        appBar: AppBar(title: const Text('Event Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (event == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Event Details')),
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
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: event!.coverImage != null
                  ? CachedNetworkImage(
                imageUrl: event!.coverImage!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => _buildPlaceholderImage(),
              )
                  : _buildPlaceholderImage(),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Share functionality would be implemented here')),
                    );
                  },
                ),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      event!.isToday ? 'TODAY' : _formatDate(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    event!.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Time and Location
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey[600], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        event!.formattedTime,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey[600], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event!.location,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Map functionality would be implemented here')),
                          );
                        },
                        child: const Text('View on Map'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Organizer Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              event!.organizerName.isNotEmpty ? event!.organizerName[0].toUpperCase() : 'O',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Organizer',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                event!.organizerName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Contact organizer functionality would be implemented here')),
                            );
                          },
                          icon: const Icon(Icons.message_outlined),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Attendees Section
                  Row(
                    children: [
                      const Text(
                        'Attendees',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${event!.currentAttendees}',
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Attendee Avatars
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: event!.currentAttendees > 8 ? 8 : event!.currentAttendees,
                      itemBuilder: (context, index) {
                        if (index == 7 && event!.currentAttendees > 8) {
                          return Container(
                            width: 50,
                            height: 50,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '+${event!.currentAttendees - 7}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }

                        return Container(
                          width: 50,
                          height: 50,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: _getAvatarColor(index),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              'U${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description Section
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    event!.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Event Details
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow('Duration', '${_calculateDuration()} hours'),
                        if (!event!.isFree) ...[
                          const Divider(),
                          _buildDetailRow('Price', '\$${event!.price?.toStringAsFixed(0) ?? '0'}'),
                        ],
                        const Divider(),
                        _buildDetailRow('Max Attendees', '${event!.maxAttendees}'),
                        const Divider(),
                        _buildDetailRow('Available Spots', '${event!.maxAttendees - event!.currentAttendees}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Join Button
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
          child: CustomButton(
            onPressed: event!.isFull
                ? null
                : () => AppRoutes.navigateToJoinEvent(context, event!.id),
            text: event!.isFull ? 'Event Full' : 'Join Event',
            backgroundColor: event!.isFull ? Colors.grey : AppTheme.primaryColor,
            width: double.infinity,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppTheme.primaryColor.withValues(alpha: 0.2),
      child: const Center(
        child: Icon(
          Icons.event,
          size: 80,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate() {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${event!.startDate.day} ${months[event!.startDate.month - 1]}';
  }

  String _calculateDuration() {
    final duration = event!.endDate.difference(event!.startDate);
    return (duration.inHours).toString();
  }

  Color _getAvatarColor(int index) {
    final colors = [
      AppTheme.primaryColor,
      AppTheme.successColor,
      AppTheme.warningColor,
      AppTheme.secondaryColor,
      Colors.teal,
      Colors.indigo,
      Colors.orange,
      Colors.pink,
    ];
    return colors[index % colors.length];
  }
}
