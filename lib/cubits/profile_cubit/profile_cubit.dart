import 'package:bloc/bloc.dart';
import 'package:hezmaa/Services/get_profile.dart';
import 'package:hezmaa/Services/post_profile.dart';

import 'package:hezmaa/cubits/profile_cubit/profile_cubit_state.dart';
import 'dart:io';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileServiceget profileServiceGet;
  final ProfileServicepost profileServicePost;

  ProfileCubit({
    required this.profileServiceGet,
    required this.profileServicePost,
  }) : super(ProfileInitial());

  Future<void> fetchProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await profileServiceGet.fetchProfile();
      emit(ProfileSuccess(profile)); // Fetching profile data
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String email,
    required String password,
    File? image,
  }) async {
    emit(ProfileLoading());
    try {
      print('تحديث الملف الشخصي:');
      print('الاسم: $name');
      print('الهاتف: $phone');
      print('البريد الإلكتروني: $email');
      print('الرقم السري: $password');
      print('الصورة: ${image?.path}');

      final updatedProfile = await profileServicePost.updateProfile(
        name: name,
        phone: phone,
        email: email,
        password: password,
        image: image,
      );

      print('تم تحديث الملف الشخصي بنجاح: $updatedProfile');
      emit(ProfileSuccess(updatedProfile, isProfileUpdated: true));

      await fetchProfile();
    } catch (e) {
      print('خطأ في تحديث الملف الشخصي: $e');
      emit(ProfileFailure(e.toString()));
    }
  }
}
