import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helper/models/base_model.dart';

class BottomListPicker<T extends BaseModel> extends StatefulWidget {
  final TextEditingController textController;
  final Future<List<T>?> fecthData;
  final String showedField;
  const BottomListPicker({Key? key, required this.textController, required this.fecthData, required this.showedField})
      : super(key: key);

  @override
  State<BottomListPicker> createState() => _BottomListPickerState();

  static Future<void> showListBottomSheet<T extends BaseModel>(
      {required BuildContext context,
      required TextEditingController textController,
      required Future<List<T>?> fecthData,
      required String showedField}) async {
    await showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(5),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (context) {
          return BottomListPicker(
            textController: textController,
            fecthData: fecthData,
            showedField: showedField,
          );
        });
  }
}

class _BottomListPickerState<T extends BaseModel> extends State<BottomListPicker> {
  List<Map<String, dynamic>>? data;
  bool loading = true;
  String error = "";
  @override
  void initState() {
    super.initState();
    widget.fecthData.then((value) {
      var result = value as List<T>;
      data = [];
      for (var element in result) {
        data!.add(element.toJson());
      }
    }).catchError((err) {
      setState(() {
        error = err.toString();
      });
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Tamam",
              style: TextStyle(color: Colors.blue),
            ),
          ),
          Expanded(
              child: loading
                  ? Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : error.isNotEmpty
                      ? Center(
                          child: Text(
                            error,
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : CupertinoPicker(
                          onSelectedItemChanged: (index) {
                            widget.textController.text = data![index][widget.showedField];
                          },
                          scrollController: FixedExtentScrollController(
                              initialItem: data?.indexWhere(
                                      (element) => element[widget.showedField] == widget.textController.text) ??
                                  0),
                          itemExtent: 35,
                          looping: false,
                          children: List.generate(data?.length ?? 0, (index) {
                            return Text(
                              data![index][widget.showedField],
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline5,
                            );
                          }))),
        ],
      ),
    );
  }
}
