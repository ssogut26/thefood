part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.image,
  });

  final File? image;

  @override
  List<Object?> get props => [image];

  ProfileState copyWith({
    File? image,
  }) {
    return ProfileState(
      image: image ?? this.image,
    );
  }
}
