import 'dart:io';

import 'package:appsagainsthumanity/data/features/users/model/user.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => throw UnimplementedError();
}

class ScreenLoaded extends ProfileEvent {}

@immutable
class UserLoaded extends ProfileEvent {
  final User user;

  UserLoaded(this.user);

  @override
  List<Object> get props => [user];
}

@immutable
class DisplayNameChanged extends ProfileEvent {
  final String name;

  DisplayNameChanged(this.name);

  @override
  List<Object> get props => [name];
}

@immutable
class PhotoChanged extends ProfileEvent {
  final PickedFile file;

  PhotoChanged(this.file);

  @override
  List<Object> get props => [file];
}

class DeleteProfilePhoto extends ProfileEvent {}
