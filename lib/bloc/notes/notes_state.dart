part of 'notes_bloc.dart';

abstract class NotesState extends Equatable {
  final int numberOfResults;

  NotesState(this.numberOfResults);

  @override
  List<Object> get props => [numberOfResults];
}

class NotesLoading extends NotesState {
  NotesLoading() : super(0);
}

class NotesLoaded extends NotesState {
  NotesLoaded(this.notes) : super(notes.length);

  final List<Note> notes;

  @override
  List<Object> get props => [notes];
}

class NotesError extends NotesState {
  NotesError(this.error) : super(0);

  final dynamic error;

  @override
  List<Object> get props => [error];
}
