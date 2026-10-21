import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/cubit/action_guard.dart';
import 'package:flutter_starter/features/example/bloc/example_detail_event.dart';
import 'package:flutter_starter/features/example/bloc/example_detail_state.dart';
import 'package:flutter_starter/features/example/data/models/item_dto.dart';
import 'package:flutter_starter/features/example/data/repositories/i_item_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExampleDetailBloc extends Bloc<ExampleDetailEvent, ExampleDetailState>
    with ActionGuard<ExampleDetailState> {
  final IItemRepository _repository;

  ExampleDetailBloc(this._repository)
    : super(const ExampleDetailState.initial()) {
    on<ExampleDetailEvent>((event, emit) async {
      await event.when(
        load: (id) => _onLoad(id, emit),
        refresh: (id) => _onRefresh(id, emit),
      );
    });
  }

  Future<void> _onLoad(int id, Emitter<ExampleDetailState> emit) async {
    emit(const ExampleDetailState.loading());

    final result = await guard<ItemDto>(
      () async {
        final repoResult = await _repository.getItem(id);
        return repoResult.fold((item) => item, (failure) => throw failure);
      },
      key: 'load_item_detail_$id',
      emitter: emit,
      retries: 2,
    );

    result.fold(
      (item) => emit(ExampleDetailState.loaded(item)),
      (failure) => emit(ExampleDetailState.error(failure)),
    );
  }

  Future<void> _onRefresh(int id, Emitter<ExampleDetailState> emit) async {
    final result = await guard<ItemDto>(
      () async {
        final repoResult = await _repository.getItem(id);
        return repoResult.fold((item) => item, (failure) => throw failure);
      },
      key: 'refresh_item_detail_$id',
      emitter: emit,
    );

    result.fold(
      (item) => emit(ExampleDetailState.loaded(item)),
      (failure) => emit(ExampleDetailState.error(failure)),
    );
  }
}
