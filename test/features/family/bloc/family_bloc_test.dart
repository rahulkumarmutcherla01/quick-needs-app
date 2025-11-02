import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:project/src/features/family/bloc/family_bloc.dart';
import 'package:project/src/features/family/data/models/family.dart';
import 'package:project/src/features/family/data/repositories/family_repository.dart';

import 'family_bloc_test.mocks.dart';

@GenerateMocks([FamilyRepository])
void main() {
  group('FamilyBloc', () {
    late FamilyBloc familyBloc;
    late MockFamilyRepository mockFamilyRepository;

    setUp(() {
      mockFamilyRepository = MockFamilyRepository();
      familyBloc = FamilyBloc(familyRepository: mockFamilyRepository);
    });

    tearDown(() {
      familyBloc.close();
    });

    test('initial state is FamilyInitial', () {
      expect(familyBloc.state, FamilyInitial());
    });

    blocTest<FamilyBloc, FamilyState>(
      'emits [FamilyLoading, FamilyCreationSuccess] when family creation is successful',
      build: () {
        when(mockFamilyRepository.createFamily(
          familyName: anyNamed('familyName'),
          familySurname: anyNamed('familySurname'),
          city: anyNamed('city'),
        )).thenAnswer(
          (_) async => const Family(id: '1', familyName: 'Test Family', familyCode: '12345678'),
        );
        return familyBloc;
      },
      act: (bloc) => bloc.add(const FamilyCreateRequested(familyName: 'Test Family')),
      expect: () => [FamilyLoading(), isA<FamilyCreationSuccess>()],
    );

    blocTest<FamilyBloc, FamilyState>(
      'emits [FamilyLoading, FamilyError] when family creation fails',
      build: () {
        when(mockFamilyRepository.createFamily(
          familyName: anyNamed('familyName'),
          familySurname: anyNamed('familySurname'),
          city: anyNamed('city'),
        )).thenThrow(Exception('Family creation failed'));
        return familyBloc;
      },
      act: (bloc) => bloc.add(const FamilyCreateRequested(familyName: 'Test Family')),
      expect: () => [FamilyLoading(), isA<FamilyError>()],
    );

    blocTest<FamilyBloc, FamilyState>(
      'emits [FamilyLoading, FamilyJoinApproved] when joining a family is successful',
      build: () {
        when(mockFamilyRepository.joinFamily(any)).thenAnswer((_) async => {});
        return familyBloc;
      },
      act: (bloc) => bloc.add(const FamilyJoinRequested(familyCode: '12345678')),
      expect: () => [FamilyLoading(), isA<FamilyJoinApproved>()],
    );

    blocTest<FamilyBloc, FamilyState>(
      'emits [FamilyLoading, FamilyError] when joining a family fails',
      build: () {
        when(mockFamilyRepository.joinFamily(any)).thenThrow(Exception('Joining family failed'));
        return familyBloc;
      },
      act: (bloc) => bloc.add(const FamilyJoinRequested(familyCode: '12345678')),
      expect: () => [FamilyLoading(), isA<FamilyError>()],
    );
  });
}
