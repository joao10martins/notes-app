import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miquido_notes_app/bloc/add_note/add_note_bloc.dart';
import 'package:miquido_notes_app/model/note.dart';
import 'package:miquido_notes_app/widgets/note_form_widget.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({
    Key? key,
    this.note,
  }) : super(key: key);

  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late String content;

  @override
  void initState() {
    super.initState();
    content = widget.note?.content ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddNoteBloc>(
      create: (BuildContext context) => AddNoteBloc()..load(widget.note?.id ?? 0),
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<AddNoteBloc, AddNoteState>(
        builder: (BuildContext context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [buildButton(context)],
            ),
            body: _buildContent(context, state)
          );
        }
    );
  }

  Widget _buildContent(BuildContext context, AddNoteState state) {
    if (state is AddNoteLoading) return _LoadingAddNoteWidget();
    if (state is AddNoteError)
      return _ErrorAddNoteWidget(refreshCallback: _fetchData, message: state.error);
    if (state is AddNoteLoaded)
      return _buildForm(context, state);
    return SizedBox.shrink();
  }

  Widget _buildForm(BuildContext context, AddNoteLoaded state) {
    return Form(
      key: _formKey,
      child: NoteFormWidget(
        content: state.note.content,
        onChangedContent: (content) => setState(() => this.content = content),
      ),
    );
  }

  Widget buildButton(BuildContext context) {
    final isFormValid = content.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: () => addOrUpdateNote(context),
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateNote(BuildContext context) async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      if (widget.note != null) {
        context.read<AddNoteBloc>().updateNote(
          widget.note!.copy(
            content: content
          )
        );
      } else {
        context.read<AddNoteBloc>().createNote(
            Note(
                content: content,
                creationDate: DateTime.now()
            )
        );
      }

      Navigator.of(context).pop();
    }
  }

  void _fetchData() {
    context.read<AddNoteBloc>().load(widget.note?.id ?? 0);
  }
}

class _ErrorAddNoteWidget extends StatelessWidget {
  final Function() refreshCallback;
  final String? message;

  const _ErrorAddNoteWidget(
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

class _LoadingAddNoteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}