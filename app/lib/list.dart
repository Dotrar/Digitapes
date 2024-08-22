import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data.dart';
import 'settings.dart';
import 'tape.dart';
import 'base.dart';

class Repository {
  final DigitapesLocalProvider localdata = DigitapesLocalProvider();

  Future<List<Digitape>> getTapes() async {
    return await localdata.readData();
  }

  void addLocalTape(Digitape t) async {
    await localdata.addLocalTape(t.name, t.description);
  }
}

class DigitapeCubit extends Cubit<List<Digitape>> {
  DigitapeCubit() : super([]);

  void addTape(Digitape t) {
    repo.addLocalTape(t);
    emit([...state, t]);
  }

  void setFromRepo() async {
    final d = await repo.getTapes();
    emit(d);
  }

  final Repository repo = Repository();
}

class DigiThumbnail extends ClipRRect {
  final ImageProvider? image;
  DigiThumbnail({super.key, required this.image})
      : super(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox.square(
                dimension: 100,
                child: (image != null)
                    ? Image(image: image, fit: BoxFit.cover)
                    : const DecoratedBox(
                        decoration: BoxDecoration(color: Colors.red))));
}

class DigiHeading extends Text {
  final String text;
  const DigiHeading(this.text, {super.key})
      : super(
          text,
          textAlign: TextAlign.center,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        );
}

class DigiDescription extends Text {
  final String text;
  const DigiDescription(this.text, {super.key})
      : super(
          text,
          textAlign: TextAlign.left,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        );
}

class DigiDetails extends Container {
  final String name;
  final String description;

  DigiDetails({super.key, required this.name, required this.description})
      : super(
          margin: const EdgeInsets.fromLTRB(10, 5, 5, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DigiHeading(name),
              Expanded(
                child: DigiDescription(description),
              )
            ],
          ),
        );
}

String? tapeNameValidation(String? str) {
  if (str == null || str.isEmpty) {
    return "Please add a name";
  }
  return null;
}

class CreateTapeForm extends Form {
  final TextEditingController name;
  final TextEditingController description;
  final Function() onPressed;

  CreateTapeForm({
    super.key,
    required this.name,
    required this.description,
    required this.onPressed,
  }) : super(
            child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Create a tape"),
                    TextFormField(
                      decoration: const InputDecoration(
                          hintText: "Name for new tape",
                          border: OutlineInputBorder()),
                      validator: tapeNameValidation,
                      controller: name,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          hintText: "Description for tape",
                          border: OutlineInputBorder()),
                      minLines: 3,
                      maxLines: 3,
                      controller: description,
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: onPressed,
                        child: const Text("Save"),
                      ),
                    ),
                  ],
                )));
}

class DigitapeWidget extends Card {
  final Digitape digitape;
  final Function() onPressed;
  DigitapeWidget({super.key, required this.digitape, required this.onPressed})
      : super(
          child: InkWell(
              onTap: onPressed,
              child: SizedBox(
                  height: 100, //Todo make this a calculated
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      DigiThumbnail(image: digitape.thumbnail),
                      // small padding
                      Expanded(
                        child: DigiDetails(
                          name: digitape.name,
                          description: digitape.description,
                        ),
                      ),
                    ],
                  ))),
          margin: const EdgeInsets.all(12),
        );
}

class ListPage extends StatefulWidget {
  const ListPage({super.key, required this.title});

  final String title;

  @override
  State<ListPage> createState() => ListPageState();
}

class ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: settingsIcon,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => const SettingsPage()));
              }),
        ],
      ),
      body: Center(
        child: BlocBuilder<DigitapeCubit, List<Digitape>>(
          builder: (context, state) {
            return ListView(
                children: state
                    .map((d) => DigitapeWidget(
                        digitape: d,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => TapePage(tape: d)));
                        }))
                    .toList());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: "Create a new tape",
          child: addIcon,
          onPressed: () {
            final nameController = TextEditingController();
            final descController = TextEditingController();
            final key = GlobalKey<FormState>();

            showModalBottomSheet(
              context: context,
              enableDrag: true,
              builder: (context) {
                return Center(
                    child: CreateTapeForm(
                  key: key,
                  name: nameController,
                  description: descController,
                  onPressed: () {
                    var form = key.currentState!;
                    if (!form.validate()) {
                      return;
                    }

                    context.read<DigitapeCubit>().addTape(Digitape(
                        name: nameController.text,
                        description: descController.text,
                        thumbnail: null));
                    Navigator.pop(context);
                  },
                ));
              },
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
