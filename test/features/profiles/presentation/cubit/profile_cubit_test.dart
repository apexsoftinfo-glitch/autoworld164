import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/features/profiles/presentation/cubit/profile_cubit.dart';

import '../../../../support/mocks.dart';

void main() {
  late MockSharedUserRepository sharedUserRepository;

  setUp(() {
    sharedUserRepository = MockSharedUserRepository();
  });

  blocTest<ProfileCubit, ProfileState>(
    'emits success when saving first name succeeds',
    build: () {
      when(
        () => sharedUserRepository.updateFirstName(
          userId: any(named: 'userId'),
          firstName: any(named: 'firstName'),
        ),
      ).thenAnswer((_) async {});
      return ProfileCubit(sharedUserRepository);
    },
    act: (cubit) => cubit.saveFirstName(userId: 'guest-1', firstName: 'Adam'),
    expect: () => [
      const ProfileState.initial(isSaving: true),
      const ProfileState.initial(successKey: 'profile_saved'),
    ],
  );
}
