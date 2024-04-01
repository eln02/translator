import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:translator/api.dart';
import 'package:translator/loading_indicator.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: TranslationWidget(),
        ),
      ),
    );
  }
}

class TranslationWidget extends StatefulWidget {
  const TranslationWidget({super.key});

  @override
  _TranslationWidgetState createState() => _TranslationWidgetState();
}

class _TranslationWidgetState extends State<TranslationWidget> {
  Future<String>? _fetchTranslationFuture;
  final TextEditingController _textController = TextEditingController();
  bool language = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          height: 7,
        ),
        SizedBox(
          height: 24,
          child: TextButton(
              onPressed: () => setState(() {
                    language = !language;
                  }),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey[850]),
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              child: Text(language ? 'ru⇄en' : 'en⇄ru',
                  style: const TextStyle(color: Colors.white, fontSize: 12))),
        ),
        const SizedBox(
          height: 18,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          height: 46,
          child: TextField(
            controller: _textController,
            cursorColor: Colors.blue,
            enableInteractiveSelection: false,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28.0),
                borderSide: const BorderSide(color: Colors.white, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28.0),
                borderSide: const BorderSide(color: Colors.blue, width: 2.0),
              ),
              border: const OutlineInputBorder(),
              labelText: 'Введите текст',
              labelStyle: const TextStyle(color: Colors.white),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: const Icon(Icons.list_alt, color: Colors.white),
                onPressed: () {}),
            IconButton(
              icon: const Icon(Icons.arrow_circle_right_outlined,
                  color: Colors.white),
              onPressed: () {
                setState(() {
                  _fetchTranslationFuture =
                      fetchTranslation(_textController.text, language);
                });
              },
            ),
            IconButton(
                icon: const Icon(Icons.cancel_outlined, color: Colors.white),
                onPressed: () {
                  _textController.text = '';
                }),
          ],
        ),
        FutureBuilder<String>(
          future: _fetchTranslationFuture,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const DottedLoadingIndicator();
            } else if (snapshot.hasError) {
              return Text('Ошибка: ${snapshot.error}');
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  snapshot.data ?? '',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
