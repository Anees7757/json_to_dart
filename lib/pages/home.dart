import 'package:flutter/material.dart';
import 'package:dart_style/dart_style.dart';
import 'package:flutter/services.dart';
import '../model_generator/model_generator.dart';
import '../validation/json_validation.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController jsonController = TextEditingController();
  TextEditingController classNameController = TextEditingController();
  String code = """""";

  final formatter = DartFormatter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Json to Dart"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      margin: const EdgeInsets.only(top: 20.0),
                      width: 400,
                      child: TextField(
                        controller: jsonController,
                        maxLines: 10,
                        autofocus: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white70,
                          hintText: 'Enter Json',
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ), //json
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 300,
                      child: TextField(
                        controller: classNameController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            hintText: "Class Name",
                            fillColor: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      child: const Text('Generate'),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.blue)))),
                      onPressed: () {
                        setState(() {
                          if (jsonController.text != "") {
                            if (Validation().isJsonValid(jsonController.text)) {
                              if (classNameController.text == "") {
                                code = Generator().jsonToDart(
                                    jsonController.text.trim(),
                                    "Autogenerated");
                              } else {
                                code = Generator().jsonToDart(
                                    jsonController.text.trim(),
                                    classNameController.text);
                              }
                            } else {
                              code = "Invalid Json";
                            }
                          }
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      child: const Text('Copy to Clipboard'),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.grey)))),
                      onPressed: () async {
                        if (jsonController.text != "") {
                          await Clipboard.setData(ClipboardData(text: code));
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 100),
                Container(
                  width: 500,
                  padding: const EdgeInsets.all(5.0),
                  margin: const EdgeInsets.only(top: 20.0),
                  child: SelectableText(formatter.format(code)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
