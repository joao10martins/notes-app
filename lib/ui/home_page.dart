import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:miquido_notes_app/bloc/notes/notes_bloc.dart';
import 'package:miquido_notes_app/widgets/note_card_widget.dart';

import 'add_note_page.dart';
import 'note_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotesBloc>(
      create: (BuildContext context) => NotesBloc()..load(),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
        builder: (BuildContext context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Notes',
                style: TextStyle(fontSize: 24),
              ),
            ),
            body: _buildContent(context, state),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black,
              child: Icon(Icons.add),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddEditNotePage()),
                );

                _fetchData(context);
              },
            ),
          );
        }
    );
  }

  Widget _buildContent(BuildContext context, NotesState state) {
    if (state is NotesLoading) return _LoadingNotesWidget();
    if (state is NotesError)
      return _ErrorNotesWidget(refreshCallback: () => _fetchData(context), message: state.error);
    if (state is NotesLoaded)
      return _buildNotes(context, state);
    return SizedBox.shrink();
  }

  Widget _buildNotes(BuildContext context, NotesLoaded state) {
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.all(8),
      itemCount: state.numberOfResults,
      staggeredTileBuilder: (index) => StaggeredTile.fit(2),
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NoteDetailPage(noteId: state.notes[index].id!),
            ));

            _fetchData(context);
          },
          child: NoteCardWidget(note: state.notes[index], index: index),
        );
      },

    );
  }

  void _fetchData(BuildContext context) {
    context.read<NotesBloc>().load();
  }
}


class _ErrorNotesWidget extends StatelessWidget {
  final Function() refreshCallback;
  final String? message;

  const _ErrorNotesWidget(
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

class _LoadingNotesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
