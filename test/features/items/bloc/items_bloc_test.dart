import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:project/src/features/items/bloc/items_bloc.dart';
import 'package:project/src/features/items/data/repositories/items_repository.dart';

import 'items_bloc_test.mocks.dart';

@GenerateMocks([ItemsRepository])
void main() {
  group('ItemsBloc', () {
    late ItemsBloc itemsBloc;
    late MockItemsRepository mockItemsRepository;

    setUp(() {
      mockItemsRepository = MockItemsRepository();
      itemsBloc = ItemsBloc(itemsRepository: mockItemsRepository);
    });

    tearDown(() {
      itemsBloc.close();
    });

    test('initial state is ItemsInitial', () {
      expect(itemsBloc.state, ItemsInitial());
    });

    blocTest<ItemsBloc, ItemsState>(
      'emits [ItemsLoading, ItemsLoadSuccess] when fetching items is successful',
      build: () {
        when(mockItemsRepository.getItemsInRoom(any)).thenAnswer(
          (_) async => [],
        );
        return itemsBloc;
      },
      act: (bloc) => bloc.add(const ItemsFetchRequested(roomId: '1')),
      expect: () => [ItemsLoading(), isA<ItemsLoadSuccess>()],
    );

    blocTest<ItemsBloc, ItemsState>(
      'emits [ItemsLoading, ItemsError] when fetching items fails',
      build: () {
        when(mockItemsRepository.getItemsInRoom(any)).thenThrow(Exception('Failed to fetch items'));
        return itemsBloc;
      },
      act: (bloc) => bloc.add(const ItemsFetchRequested(roomId: '1')),
      expect: () => [ItemsLoading(), isA<ItemsError>()],
    );
  });
}
