import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/event_model.dart';
import '../utils/theme.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: SizedBox(
                height: 180,
                width: double.infinity,
                child: event.coverImage != null
                    ? CachedNetworkImage(
                  imageUrl: event.coverImage!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => _buildPlaceholderImage(),
                  fadeInDuration: const Duration(milliseconds: 300),
                  fadeOutDuration: const Duration(milliseconds: 300),
                )
                    : _buildPlaceholderImage(),
              ),
            ),

            // Event Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Badge and Title
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: event.isToday
                              ? AppTheme.primaryColor
                              : AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          event.isToday ? 'TODAY' : _getDateLabel(),
                          style: TextStyle(
                            color: event.isToday ? Colors.white : AppTheme.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Title
                      Expanded(
                        child: Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Time and Location
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event.formattedTime,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${event.distance.toStringAsFixed(1)} km away',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Organizer and Attendees
                  Row(
                    children: [
                      // Organizer
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  event.organizerName,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Attendees
                      _buildAttendeesWidget(),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    event.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

                  // Footer with Price and Join Button
                  Row(
                    children: [
                      // Price
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: event.isFree
                              ? AppTheme.successColor.withValues(alpha: 0.1)
                              : AppTheme.warningColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          event.isFree ? 'FREE' : '\$${event.price?.toStringAsFixed(0) ?? '0'}',
                          style: TextStyle(
                            color: event.isFree ? AppTheme.successColor : AppTheme.warningColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),

                      // Join Button
                      SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: event.isFull ? null : onTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: event.isFull
                                ? Colors.grey[300]
                                : AppTheme.primaryColor,
                            foregroundColor: event.isFull
                                ? Colors.grey[600]
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            elevation: event.isFull ? 0 : 2,
                          ),
                          child: Text(
                            event.isFull ? 'Full' : 'Join Event',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppTheme.primaryColor.withValues(alpha: 0.1),
      child: const Center(
        child: Icon(
          Icons.event,
          size: 40,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  String _getDateLabel() {
    final now = DateTime.now();
    final eventDate = event.startDate;

    // Today
    if (eventDate.year == now.year &&
        eventDate.month == now.month &&
        eventDate.day == now.day) {
      return 'TODAY';
    }

    // Tomorrow
    final tomorrow = now.add(const Duration(days: 1));
    if (eventDate.year == tomorrow.year &&
        eventDate.month == tomorrow.month &&
        eventDate.day == tomorrow.day) {
      return 'TOM';
    }

    // This week
    final daysDifference = eventDate.difference(now).inDays;
    if (daysDifference >= 0 && daysDifference <= 7) {
      const weekdays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
      return weekdays[eventDate.weekday % 7];
    }

    // Show date
    return '${eventDate.day}/${eventDate.month}';
  }

  Widget _buildAttendeesWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Attendee avatars (stack)
        if (event.currentAttendees > 0) ...[
          SizedBox(
            width: event.currentAttendees > 3 ? 60 : (event.currentAttendees * 20.0),
            height: 24,
            child: Stack(
              children: List.generate(
                (event.currentAttendees > 3 ? 3 : event.currentAttendees),
                    (index) => Positioned(
                  left: index * 16.0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _getAvatarColor(index),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],

        // More indicator and count
        if (event.currentAttendees > 3)
          Text(
            '+${event.currentAttendees - 3}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          )
        else if (event.currentAttendees > 0)
          Text(
            '${event.currentAttendees}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          )
        else
          Text(
            'No attendees yet',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
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
