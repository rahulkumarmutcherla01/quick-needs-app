import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:project/src/features/family/bloc/family_details_bloc.dart';
import 'package:project/src/features/family/data/models/family.dart';
import 'package:project/src/features/family/data/repositories/family_repository.dart';

import 'family_details_bloc_test.mocks.dart';

@GenerateMocks([FamilyRepository])
void main() {
  group('FamilyDetailsBloc', () {
    late FamilyDetailsBloc familyDetailsBloc;
    late MockFamilyRepository mockFamilyRepository;

    setUp(() {
      mockFamilyRepository = MockFamilyRepository();
      familyDetailsBloc = FamilyDetailsBloc(familyRepository: mockFamilyRepository);
    });

    tearDown(() {
      familyDetailsBloc.close();
    });

    test('initial state is FamilyDetailsInitial', () {
      expect(familyDetailsBloc.state, FamilyDetailsInitial());
    });

    blocTest<FamilyDetailsBloc, FamilyDetailsState>(
      'emits [FamilyDetailsLoading, FamilyDetailsLoadSuccess] when fetching details is successful',
      build: () {
        when(mockFamilyRepository.getFamilyDetails()).thenAnswer(
          (_) async => const Family(id: '1', familyName: 'Test Family', familyCode: '12345678'),
        );
        return familyDetailsBloc;
      },
      act: (bloc) => bloc.add(FamilyDetailsFetchRequested()),
      expect: () => [FamilyDetailsLoading(), isA<FamilyDetailsLoadSuccess>()],
    );

    blocTest<FamilyDetailsBloc, FamilyDetailsState>(
      'emits [FamilyDetailsLoading, FamilyDetailsError] when fetching details fails',
      build: () {
        when(mockFamilyRepository.getFamilyDetails()).thenThrow(Exception('Failed to fetch details'));
        return familyDetailsBloc;
      },
      act: (bloc) => bloc.add(FamilyDetailsFetchRequested()),
      expect: () => [FamilyDetailsLoading(), isA<FamilyDetailsError>()],
    );
  });
}
