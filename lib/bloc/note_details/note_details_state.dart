part of 'note_details_bloc.dart';

abstract class NoteDetailState extends Equatable {
  NoteDetailState();

  @override
  List<Object> get props => [];
}

class NoteDetailLoading extends NoteDetailState {
  NoteDetailLoading() : super();
}

class NoteDetailLoaded extends NoteDetailState {
  NoteDetailLoaded(this.note) : super();

  final Note note;

  @override
  List<Object> get props => [note];
}

class NoteDetailError extends NoteDetailState {
  NoteDetailError(this.error) : super();

  final dynamic error;

  @override
  List<Object> get props => [error];
}
