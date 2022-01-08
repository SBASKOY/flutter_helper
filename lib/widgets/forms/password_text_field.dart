import 'package:flutter/material.dart';

class CustomPasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  const CustomPasswordTextField({Key? key, this.controller, this.labelText, this.validator, this.hintText}) : super(key: key);

  @override
  _CustomPasswordTextFiedlState createState() => _CustomPasswordTextFiedlState();
}

class _CustomPasswordTextFiedlState extends State<CustomPasswordTextField> {
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: widget.validator,
        controller: widget.controller,
        obscureText: _passwordVisible,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              }),
        ),
      ),
    );
  }
}
