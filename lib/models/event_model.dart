class EventModel {
  final String id;
  final String title;
  final String description;
  final String? coverImage;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final double? latitude;
  final double? longitude;
  final String organizerId;
  final String organizerName;
  final int maxAttendees;
  final int currentAttendees;
  final bool isFree;
  final double? price;
  final List<String> tags;
  final List<String> attendeeIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final EventStatus status;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    this.coverImage,
    required this.startDate,
    required this.endDate,
    required this.location,
    this.latitude,
    this.longitude,
    required this.organizerId,
    required this.organizerName,
    required this.maxAttendees,
    this.currentAttendees = 0,
    this.isFree = true,
    this.price,
    this.tags = const [],
    this.attendeeIds = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
    this.status = EventStatus.upcoming,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      coverImage: json['coverImage'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      location: json['location'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      organizerId: json['organizerId'] ?? '',
      organizerName: json['organizerName'] ?? '',
      maxAttendees: json['maxAttendees'] ?? 0,
      currentAttendees: json['currentAttendees'] ?? 0,
      isFree: json['isFree'] ?? true,
      price: json['price']?.toDouble(),
      tags: List<String>.from(json['tags'] ?? []),
      attendeeIds: List<String>.from(json['attendeeIds'] ?? []),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      status: EventStatus.values.firstWhere(
            (e) => e.toString() == 'EventStatus.${json['status']}',
        orElse: () => EventStatus.upcoming,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'coverImage': coverImage,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'maxAttendees': maxAttendees,
      'currentAttendees': currentAttendees,
      'isFree': isFree,
      'price': price,
      'tags': tags,
      'attendeeIds': attendeeIds,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }

  String get formattedDate {
    return '${startDate.day}/${startDate.month}/${startDate.year}';
  }

  String get formattedTime {
    return '${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')} - ${endDate.hour.toString().padLeft(2, '0')}:${endDate.minute.toString().padLeft(2, '0')}';
  }

  bool get isToday {
    final now = DateTime.now();
    return startDate.year == now.year &&
        startDate.month == now.month &&
        startDate.day == now.day;
  }

  bool get isFull {
    return currentAttendees >= maxAttendees;
  }

  double get distance {
    // This would be calculated based on user's location
    return 2.5; // Placeholder
  }

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? coverImage,
    DateTime? startDate,
    DateTime? endDate,
    String? location,
    double? latitude,
    double? longitude,
    String? organizerId,
    String? organizerName,
    int? maxAttendees,
    int? currentAttendees,
    bool? isFree,
    double? price,
    List<String>? tags,
    List<String>? attendeeIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    EventStatus? status,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      organizerId: organizerId ?? this.organizerId,
      organizerName: organizerName ?? this.organizerName,
      maxAttendees: maxAttendees ?? this.maxAttendees,
      currentAttendees: currentAttendees ?? this.currentAttendees,
      isFree: isFree ?? this.isFree,
      price: price ?? this.price,
      tags: tags ?? this.tags,
      attendeeIds: attendeeIds ?? this.attendeeIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
    );
  }
}

enum EventStatus {
  upcoming,
  ongoing,
  completed,
  cancelled,
}