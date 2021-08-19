import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/movie.dart';

class MovieDialog extends StatefulWidget {
  final Movie? transaction;
  final Function(String name, String director) onClickedDone;

  const MovieDialog({
    Key? key,
    this.transaction,
    required this.onClickedDone,
  }) : super(key: key);

  @override
  _MovieDialogState createState() => _MovieDialogState();
}

class _MovieDialogState extends State<MovieDialog> {
  String imagepath = "";
  final picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final directorController = TextEditingController();

  // bool isExpense = true;

  @override
  void initState() {
    super.initState();

    if (widget.transaction != null) {
      final transaction = widget.transaction!;

      nameController.text = transaction.name;
      directorController.text = transaction.director;
      // isExpense = transaction.isExpense;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    directorController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;
    final title = isEditing ? 'Edit Movie' : 'Add Movie';
    final img;
    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8),
              buildName(),
              SizedBox(height: 8),
              buildAmount(),
              SizedBox(height: 8),

              // buildRadioButtons(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
        ElevatedButton(
          child: Text("Choose an image"),
          onPressed: () async {
            final pickedFile =
                await picker.getImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              setState(() {
                imagepath = pickedFile.path;
              });
            }
          },
        )
      ],
    );
  }

  Widget buildName() => TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Name of the movie',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter the name of the movie' : null,
      );

  Widget buildAmount() => TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter the name of the director',
        ),
        keyboardType: TextInputType.text,
        validator: (director) => director != null && director.isEmpty
            ? 'Enter the name of the director '
            : null,
        // validator: (amount) => amount != null && double.tryParse(amount) == null
        //     ? 'Enter a valid number'
        //     : null,
        controller: directorController,
      );

  // Widget buildRadioButtons() => Column(
  //       children: [
  //         RadioListTile<bool>(
  //           title: Text('Expense'),
  //           value: true,
  //           groupValue: isExpense,
  //           onChanged: (value) => setState(() => isExpense = value!),
  //         ),
  //         RadioListTile<bool>(
  //           title: Text('Income'),
  //           value: false,
  //           groupValue: isExpense,
  //           onChanged: (value) => setState(() => isExpense = value!),
  //         ),
  //       ],
  //     );

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final name = nameController.text;
          // final amount = double.tryParse(amountController.text) ?? 0;
          final director = directorController.text;
          widget.onClickedDone(
            name,
            director,
          );

          Navigator.of(context).pop();
        }
      },
    );
  }
}
