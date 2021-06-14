import 'package:flutter/material.dart';

class NoteFormWidget extends StatelessWidget {
  final String? content;
  final ValueChanged<String> onChangedContent;

  const NoteFormWidget({
    Key? key,
    this.content = '',
    required this.onChangedContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildContent(),
          SizedBox(height: 16),
        ],
      ),
    ),
  );


  Widget _buildContent() => TextFormField(
    maxLines: 5,
    initialValue: content,
    style: TextStyle(color: Colors.white60, fontSize: 18),
    decoration: InputDecoration(
      border: InputBorder.none,
      hintText: 'Type something...',
      hintStyle: TextStyle(color: Colors.white60),
    ),
    validator: (title) => title != null && title.isEmpty
        ? 'The description cannot be empty'
        : null,
    onChanged: onChangedContent,
  );
}