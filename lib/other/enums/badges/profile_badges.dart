import 'package:cityvista/other/enums/badges/badge_type.dart';

enum ProfileBadges {
  local(
    "Local",
    "Post 10 places in Cityvista.",
    10,
    BadgeType.places
  ),
  feedbackChampion(
    "Feedback Champion",
    "Leave 10 reviews in Cityvista.",
    10,
    BadgeType.reviews
  );

  const ProfileBadges(this.name, this.description, this.count, this.type);

  final String name;
  final String description;
  final int count;
  final BadgeType type;
}