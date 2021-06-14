import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:miquido_notes_app/bloc/note_details/note_details_bloc.dart';

import 'add_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NoteDetailBloc>(
      create: (BuildContext context) => NoteDetailBloc()..load(widget.noteId),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<NoteDetailBloc, NoteDetailState>(
        builder: (BuildContext context, state) {
          return Scaffold(
              appBar: AppBar(
                actions: [editButton(context, state), deleteButton(context)],
              ),
              body: _buildContent(context, state)
          );
        }
    );
  }

  Widget _buildContent(BuildContext context, NoteDetailState state) {
    if (state is NoteDetailLoading) return _LoadingNoteDetailsWidget();
    if (state is NoteDetailError)
      return _ErrorNoteDetailsWidget(refreshCallback: () => _fetchData(context), message: state.error);
    if (state is NoteDetailLoaded)
      return _buildNote(context, state);
    return SizedBox.shrink();
  }

  void _fetchData(BuildContext context) {
    context.read<NoteDetailBloc>().load(widget.noteId);
  }

  Widget _buildNote(BuildContext context, NoteDetailLoaded state) {
    isLoading = false;
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      children: [
        Text(
          DateFormat.yMMMd().format(state.note.creationDate),
          style: TextStyle(color: Colors.white38),
        ),
        SizedBox(height: 8),
        Text(
          state.note.content,
          style: TextStyle(color: Colors.white70, fontSize: 18),
        )
      ],
    );
  }

  Widget editButton(BuildContext context, NoteDetailState state) => IconButton(
      icon: Icon(Icons.edit_outlined),
      onPressed: () async {
        if (state is NoteDetailLoading) return;

        if(state is NoteDetailLoaded) {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddEditNotePage(note: state.note),
          ));
        }

        _fetchData(context);
      });

  Widget deleteButton(BuildContext context) => IconButton(
    icon: Icon(Icons.delete),
    onPressed: () async {
      context.read<NoteDetailBloc>().deleteNote(widget.noteId);

      Navigator.of(context).pop();
    },
  );
}

class _ErrorNoteDetailsWidget extends StatelessWidget {
  final Function() refreshCallback;
  final String? message;

  const _ErrorNoteDetailsWidget(
      {Key? key, required this.refreshCallback, this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message ?? "Unknown error happened"),
          ElevatedButton(
              onPressed: refreshCallback,
              child: Text(
                "Try again",
              ))
        ],
      ),
    );
  }
}

class _LoadingNoteDetailsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}