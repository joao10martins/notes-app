import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miquido_notes_app/model/note.dart';
import 'package:miquido_notes_app/database/database.dart';
import 'package:equatable/equatable.dart';

part 'notes_state.dart';

class NotesBloc extends Cubit<NotesState> {
  NotesBloc() : super(NotesLoading());

  Future<void> load() async {
    emit(NotesLoading());
    try {
      final List<Note> notes = await NotesDatabase.instance.readAllNotes();

      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(e));
    }
  }

}
