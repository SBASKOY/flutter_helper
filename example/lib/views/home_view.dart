import 'package:example/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_helper/flutter_helper.dart';
import 'package:flutter_helper/formatter/phone.dart';
import 'package:flutter_helper/manager/network.dart';
import 'package:flutter_helper/widgets/divider.dart';
import 'package:flutter_helper/widgets/forms/password_text_field.dart';
import 'package:flutter_helper/widgets/forms/text_field.dart';
import 'package:flutter_helper/widgets/scrollbar/scrollbar.dart';
import 'package:flutter_helper/widgets/snackbar/snackbar.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    // you can call main.dart file
    NetworkManager.instance.setBaseUrl("https://jsonplaceholder.typicode.com/");
  }

  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController listPickerController = new TextEditingController();
  List<String> data = List.generate(100, (index) => "index $index");

  void _showSnackBar() {
    CustomErrorSnackBar.showSnackBarWithText(context, "Show SnackBar", color: Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Helper"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          CustomPasswordTextField(
            controller: passwordController,
            hintText: "Password",
          ),
          const CustomTextDivider(text: "Text Divider"),
          CustomFormField(
            controller: listPickerController,
            readOnly: true,
            hintText: "Select post",
            suffixIcon: Icons.list,
            onTap: () {
              BottomListPicker.showListBottomSheet<Post>(
                  context: context,
                  textController: listPickerController,
                  fecthData: NetworkManager.instance.httpGet<List<Post>?, Post>("posts", model: Post()),
                  showedField: "title");
            },
          ),
          const CustomTextDivider(text: "Formatter"),
          CustomFormField(
            hintText: "(000) 000 0000",
            type: TextInputType.number,
            formatter: [FilteringTextInputFormatter.allow(new RegExp("[0-9() ]")), PhoneFormatter()],
          ),
          const CustomTextDivider(text: "SnackBar"),
          TextButton(onPressed: _showSnackBar, child: const Text("Show SnackBar")),
          const CustomTextDivider(text: "Padding"),
          const Text("Padding").paddingAll(),
          CustomScrollBar(
            child: ListView(
              children: [
                ...List.generate(
                    data.length,
                    (index) => ListTile(
                          title: Text(data[index]),
                        ))
              ],
            ),
          ).addExpanded()
        ],
      ),
    );
  }
}
