import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:project/src/features/items/bloc/rooms_bloc.dart';
import 'package:project/src/features/items/data/models/room.dart';
import 'package:project/src/features/items/data/repositories/items_repository.dart';

import 'rooms_bloc_test.mocks.dart';

@GenerateMocks([ItemsRepository])
void main() {
  group('RoomsBloc', () {
    late RoomsBloc roomsBloc;
    late MockItemsRepository mockItemsRepository;

    setUp(() {
      mockItemsRepository = MockItemsRepository();
      roomsBloc = RoomsBloc(itemsRepository: mockItemsRepository);
    });

    tearDown(() {
      roomsBloc.close();
    });

    test('initial state is RoomsInitial', () {
      expect(roomsBloc.state, RoomsInitial());
    });

    blocTest<RoomsBloc, RoomsState>(
      'emits [RoomsLoading, RoomsLoadSuccess] when fetching rooms is successful',
      build: () {
        when(mockItemsRepository.getRooms()).thenAnswer(
          (_) async => [],
        );
        return roomsBloc;
      },
      act: (bloc) => bloc.add(RoomsFetchRequested()),
      expect: () => [RoomsLoading(), isA<RoomsLoadSuccess>()],
    );

    blocTest<RoomsBloc, RoomsState>(
      'emits [RoomsLoading, RoomsError] when fetching rooms fails',
      build: () {
        when(mockItemsRepository.getRooms()).thenThrow(Exception('Failed to fetch rooms'));
        return roomsBloc;
      },
      act: (bloc) => bloc.add(RoomsFetchRequested()),
      expect: () => [RoomsLoading(), isA<RoomsError>()],
    );
  });
}
