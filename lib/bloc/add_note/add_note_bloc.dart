import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miquido_notes_app/model/note.dart';
import 'package:miquido_notes_app/database/database.dart';
import 'package:equatable/equatable.dart';

part 'add_note_state.dart';

class AddNoteBloc extends Cubit<AddNoteState> {
  AddNoteBloc() : super(AddNoteLoading());

  Future<void> load(int id) async {
    emit(AddNoteLoading());
    if(id == 0) {
      emit(AddNoteLoaded(
          Note(content: '', creationDate: DateTime.now())
      ));
    } else {
      try {
        final Note loadedNote = await NotesDatabase.instance.readNote(id);

        emit(AddNoteLoaded(loadedNote));
      } catch (e, stack) {
        debugPrintStack(label: 'Error $e', stackTrace: stack);
        emit(AddNoteError(e));
      }
    }
  }


  void createNote(Note note) async {
    await NotesDatabase.instance.createNote(note);
  }

  void updateNote(Note note) async {
    await NotesDatabase.instance.updateNote(note);
  }

  void deleteNote(int id) async {
    await NotesDatabase.instance.deleteNote(id);
  }
}
