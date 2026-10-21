import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/cubit/action_guard.dart';
import 'package:flutter_starter/core/errors/failure.dart';
import 'package:flutter_starter/core/utils/action_token.dart';
import 'package:flutter_starter/features/example/bloc/example_detail_event.dart';
import 'package:flutter_starter/features/example/bloc/example_detail_state.dart';
import 'package:flutter_starter/features/example/data/models/item_model.dart';
import 'package:flutter_starter/features/example/data/repositories/item_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExampleDetailBloc extends Bloc<ExampleDetailEvent, ExampleDetailState>
    with ActionGuard<ExampleDetailState> {
  final ItemRepository _repository;

  ExampleDetailBloc(this._repository)
    : super(const ExampleDetailState.initial()) {
    on<ExampleDetailEvent>((event, emit) async {
      await event.when(
        load: (id, token) => _onLoad(id, emit, token: token),
        refresh: (id, token) => _onRefresh(id, emit, token: token),
      );
    });
  }

  Future<void> _onLoad(
    int id,
    Emitter<ExampleDetailState> emit, {
    ActionToken? token,
  }) async {
    emit(const ExampleDetailState.loading());

    final result = await guard<ItemModel>(
      () async {
        final repoResult = await _repository.getItem(id);
        return repoResult.fold((item) => item, (failure) => throw failure);
      },
      key: 'load_item_detail_$id',
      token: token,
      emitter: emit,
      retries: 2,
    );

    result.fold((item) => emit(ExampleDetailState.loaded(item)), (failure) {
      if (failure is! CancelledFailure) {
        emit(ExampleDetailState.error(failure));
      }
    });
  }

  Future<void> _onRefresh(
    int id,
    Emitter<ExampleDetailState> emit, {
    ActionToken? token,
  }) async {
    final result = await guard<ItemModel>(
      () async {
        final repoResult = await _repository.getItem(id);
        return repoResult.fold((item) => item, (failure) => throw failure);
      },
      key: 'refresh_item_detail_$id',
      token: token,
      emitter: emit,
    );

    result.fold((item) => emit(ExampleDetailState.loaded(item)), (failure) {
      if (failure is! CancelledFailure) {
        emit(ExampleDetailState.error(failure));
      }
    });
  }
}
