import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miquido_notes_app/model/note.dart';
import 'package:miquido_notes_app/database/database.dart';
import 'package:equatable/equatable.dart';

part 'note_details_state.dart';

class NoteDetailBloc extends Cubit<NoteDetailState> {
  NoteDetailBloc() : super(NoteDetailLoading());

  Future<void> load(int id) async {
    emit(NoteDetailLoading());
    try {
      final Note loadedNote = await NotesDatabase.instance.readNote(id);

      emit(NoteDetailLoaded(loadedNote));
    } catch (e, stack) {
      debugPrintStack(label: 'Error $e', stackTrace: stack);
      emit(NoteDetailError(e));
    }
  }

  void deleteNote(int id) async {
    await NotesDatabase.instance.deleteNote(id);
  }
}
