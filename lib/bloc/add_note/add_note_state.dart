part of 'add_note_bloc.dart';

abstract class AddNoteState extends Equatable {
  @override
  List<Object> get props => [];
}

class AddNoteLoading extends AddNoteState {
  AddNoteLoading() : super();
}

class AddNoteLoaded extends AddNoteState {
  AddNoteLoaded(this.note) : super();

  final Note note;

  @override
  List<Object> get props => [note];
}

class AddNoteError extends AddNoteState {
  AddNoteError(this.error) : super();

  final dynamic error;

  @override
  List<Object> get props => [error];
}
