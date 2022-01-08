import 'dart:io';

import 'package:chair_inspector/business%20logic/cubit/sqflite_cubit.dart';
import 'package:chair_inspector/business%20logic/cubit/sqflite_state.dart';
import 'package:chair_inspector/colors.dart';
import 'package:chair_inspector/data/moedls/visual_note.dart';
import 'package:chair_inspector/data/repository/visual_note_repository.dart';
import 'package:chair_inspector/presentation/widgets/image_picker_widget.dart';
import 'package:chair_inspector/presentation/widgets/my_material_button_widget.dart';
import 'package:chair_inspector/presentation/widgets/my_text_field_widget.dart';
import 'package:chair_inspector/presentation/widgets/visual_note_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late VisualNote visualNote;
  bool bottomSheetShown = false;

  @override
  Widget build(BuildContext context) {
    Size devicesize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: MyColors.backGroundColor,
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Inspector'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showInformationPicker(context, devicesize);
        },
      ),
      body: BlocConsumer<SqfliteCubit, SqfliteState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return VisualNoteItem(
                          visualNote: SqfliteCubit.get(context)
                              .retrievedVisualNotes![index],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 8.0,
                        );
                      },
                      itemCount: SqfliteCubit.get(context)
                          .retrievedVisualNotes!
                          .length),
                ),
              ],
            ),
          );
        },
      ),
      //),
    );
  }

  Widget bottomSheetContentsWidget(BuildContext context,
      {double? height, double? width}) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              height: 40.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ImagePickerWidget(
                  height: height! * 0.4,
                  width: width! * 0.38,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //title text field
                    MyTextField(
                      label: 'Title',
                      height: height * 0.16,
                      width: width * 0.47,
                      controller: titleController,
                      hint: 'Enter title',
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),

                    //status text field
                    MyTextField(
                      label: 'Status',
                      height: height * 0.16,
                      width: width * 0.47,
                      controller: statusController,
                      hint: 'Set status',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            //description text field
            MyTextField(
              label: 'Description',
              height: height * 0.2,
              width: width * 0.9,
              controller: descriptionController,
              hint: 'Enter details',
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: MyMaterialButton(
                onPressed: () {
                  sendDataToDataBase(context);
                },
                text: 'INSERT',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showInformationPicker(BuildContext context, Size size) {
    resetData();
    if (!SqfliteCubit.get(context).bottomSheetShown!) {
      scaffoldKey.currentState
          ?.showBottomSheet(
            (context) {
              var bottomSheetHeight = size.height * 0.6;
              var bottomSheetWidth = size.width;
              return Container(
                height: bottomSheetHeight,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: bottomSheetContentsWidget(context,
                    height: bottomSheetHeight, width: bottomSheetWidth),
              );
            },
          )
          .closed
          .then((value) {
            SqfliteCubit.get(context).setBottomSheetState(
              state: false,
            );
          });
    } else {
      Navigator.pop(context);
    }

    SqfliteCubit.get(context).setBottomSheetState(
      state: true,
    );
  }

  void sendDataToDataBase(BuildContext context) {
    visualNote = VisualNote(
      date: (DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())).toString(),
      description: descriptionController.text,
      imagePath: SqfliteCubit.get(context).imagePath,
      status: statusController.text,
      title: titleController.text,
    );
    Navigator.pop(context);
    SqfliteCubit.get(context).insertToDataBase(visualNote: visualNote);
  }

  void resetData() {
    titleController.clear();
    statusController.clear();
    descriptionController.clear();
    SqfliteCubit.get(context).imagePath = '';
  }
}
