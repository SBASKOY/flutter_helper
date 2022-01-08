import 'package:flutter/material.dart';

class CustomTextDivider extends StatelessWidget {
  final String? text;
  const CustomTextDivider({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Expanded(child: getContainer),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(this.text ?? ""),
          ),
          Expanded(
            child: getContainer,
          )
        ],
      ),
    );
  }

  Widget get getContainer => Container(height: 1, decoration: BoxDecoration(border: Border.all(color: Colors.grey)));
}
