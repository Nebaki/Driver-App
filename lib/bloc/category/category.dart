import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:driverapp/models/models.dart';
import 'package:driverapp/repository/repositories.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;
  CategoryBloc({required this.categoryRepository}) : super(CategoryLoading());

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is CategoryLoad) {
      yield CategoryLoading();

      try {
        final category = await categoryRepository.getCategoryById(event.id);
        yield CategoryLoadSuccess(category: category);
      } catch (e) {
        if (e.toString().split(" ")[1] == "401") {
          yield CategoryUnAuthorised();
        } else {
          yield (CategoryOperationFailure());
        }
        yield CategoryOperationFailure();
      }
    }
  }
}

abstract class CategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoryLoad extends CategoryEvent {
  final String id;
  CategoryLoad({required this.id});
  @override
  List<Object?> get props => [id];
}

abstract class CategoryState extends Equatable {
  const CategoryState();
  @override
  List<Object?> get props => [];
}

class CategoryLoading extends CategoryState {}

class CategoryLoadSuccess extends CategoryState {
  final Category category;
  const CategoryLoadSuccess({required this.category});
  @override
  List<Object?> get props => [category];
}

class CategoryOperationFailure extends CategoryState {}

class CategoryUnAuthorised extends CategoryState {}
