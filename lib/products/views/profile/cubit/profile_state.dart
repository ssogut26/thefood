part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  ProfileState({
    this.country,
  });

  String? country;

  @override
  List<Object?> get props => [country];

  ProfileState copyWith({
    String? country,
  }) {
    return ProfileState(
      country: country ?? this.country,
    );
  }
}
