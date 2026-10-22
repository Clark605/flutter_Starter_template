import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/cubit/action_guard.dart';
import 'package:flutter_starter/core/errors/failure.dart';
import 'package:flutter_starter/core/utils/load_status.dart';
import 'package:flutter_starter/features/example/bloc/example_detail_event.dart';
import 'package:flutter_starter/features/example/bloc/example_detail_state.dart';
import 'package:flutter_starter/features/example/data/models/item_model.dart';
import 'package:flutter_starter/features/example/data/repositories/item_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExampleDetailBloc extends Bloc<ExampleDetailEvent, ExampleDetailState>
    with ActionGuard<ExampleDetailState> {
  final ItemRepository _repository;

  ExampleDetailBloc(this._repository) : super(const ExampleDetailState()) {
    on<ExampleDetailEvent>((event, emit) async {
      await event.when(
        load: (id) => _onLoad(id, emit),
        refresh: (id) => _onRefresh(id, emit),
      );
    });
  }

  Future<void> _onLoad(int id, Emitter<ExampleDetailState> emit) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));

    final result = await guard<ItemModel>(
      () => _repository.getItem(id),
      key: 'load_item_detail_$id',
      emitter: emit,
    );

    result.fold(
      (item) => emit(
        state.copyWith(status: LoadStatus.success, item: item, failure: null),
      ),
      (failure) {
        if (failure is! CancelledFailure) {
          emit(state.copyWith(status: LoadStatus.failure, failure: failure));
        }
      },
    );
  }

  Future<void> _onRefresh(int id, Emitter<ExampleDetailState> emit) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));

    final result = await guard<ItemModel>(
      () => _repository.getItem(id),
      key: 'refresh_item_detail_$id',
      emitter: emit,
    );

    result.fold(
      (item) => emit(
        state.copyWith(status: LoadStatus.success, item: item, failure: null),
      ),
      (failure) {
        if (failure is CancelledFailure) return;
        if (state.item == null) {
          emit(state.copyWith(status: LoadStatus.failure, failure: failure));
        } else {
          // Keep current item visible on failed refresh
          emit(state.copyWith(status: LoadStatus.success, failure: null));
        }
      },
    );
  }
}
