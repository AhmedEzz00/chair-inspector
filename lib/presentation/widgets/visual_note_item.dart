import 'dart:io';

import 'package:chair_inspector/business%20logic/cubit/sqflite_cubit.dart';
import 'package:chair_inspector/data/moedls/visual_note.dart';
import 'package:chair_inspector/presentation/widgets/image_picker_widget.dart';
import 'package:chair_inspector/presentation/widgets/my_material_button_widget.dart';
import 'package:chair_inspector/presentation/widgets/my_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../colors.dart';

class VisualNoteItem extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  final VisualNote? visualNote;
  VisualNoteItem({
    Key? key,
    this.visualNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Dismissible(
      key: GlobalKey<ScaffoldState>(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        deleteItem(context, visualNote!.id!.toInt());
      },
      background: showDismissibleBackGround(),
      child: Container(
        decoration: const BoxDecoration(
            color: MyColors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50))),
        width: double.infinity,
        height: deviceSize.height * 0.3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 2.0,
            ),
            imageHolderWidget(deviceSize),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //showDescriptionWidget(deviceSize),
                showDetailsWidget(context, deviceSize),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void deleteItem(BuildContext context, int id) {
    SqfliteCubit.get(context).deleteItemFromDataBase(id);
  }

  Widget imageHolderWidget(Size size) {
    return Container(
      height: size.height * 0.28,
      width: size.width * 0.4,
      color: Colors.white,
      child: GridTile(
        child: Container(
          color: MyColors.grey,
          child: Image.file(
            File(visualNote!.imagePath.toString()),
          ),
        ),
        footer: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          color: Colors.black54,
          alignment: Alignment.bottomCenter,
          child: Text(
            'Chair Id: ${visualNote!.id}',
            style: const TextStyle(
              height: 1.3,
              fontSize: 16,
              color: MyColors.white,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        header: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          color: Colors.black54,
          alignment: Alignment.bottomCenter,
          child: Text(
            '${visualNote!.title}',
            style: const TextStyle(
              height: 1.3,
              fontSize: 16,
              color: MyColors.white,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget showDetailsWidget(BuildContext context, Size size) {
    return Container(
      height: size.height * 0.27,
      width: size.width * 0.55,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          showDescriptionWidget(size),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status: ${visualNote!.status}'),
                  const SizedBox(
                    height: 6.0,
                  ),
                  Text('${visualNote!.date}'),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blue[50]),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    child: const Icon(
                      Icons.edit,
                    ),
                    onTap: () {
                      openEditField(context, size);
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 1.0,
              )
            ],
          ),
        ],
      ),
    );
  }

  void openEditField(BuildContext context, size) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Stack(
              clipBehavior: Clip.none,
              children: [
                exitButtonWidget(context),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ImagePickerWidget(
                        height: size.height * 0.3,
                        width: double.infinity,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      editTitleWidget(),
                      SizedBox(
                        height: 7,
                      ),
                      editStatusWidget(),
                      SizedBox(
                        height: 7,
                      ),
                      editDescriptionWidget(),
                      SizedBox(
                        height: 10.0,
                      ),
                      MyMaterialButton(
                        onPressed: () {
                          updateDataInDataBase(context);
                        },
                        text: 'SAVE',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void updateDataInDataBase(BuildContext context) {
    VisualNote newVisualNote = VisualNote(
      date: (DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())).toString(),
      description: descriptionController.text,
      imagePath: SqfliteCubit.get(context).imagePath,
      status: statusController.text,
      title: titleController.text,
    );
    Navigator.pop(context);
    SqfliteCubit.get(context).updateItemInDataBase(visualNote: newVisualNote,id: visualNote!.id);
    
  }

  Widget editDescriptionWidget() {
    return MyTextField(
        controller: descriptionController,
        hint: 'Enter new description',
        label: 'Description');
  }

  Widget editStatusWidget() {
    return MyTextField(
      controller: statusController,
      hint: 'Enter new status',
      label: 'Status',
    );
  }

  Widget editTitleWidget() {
    return MyTextField(
      controller: titleController,
      hint: 'Enter new title',
      label: 'Title',
    );
  }

  Widget exitButtonWidget(BuildContext context) {
    return Positioned(
      right: -40.0,
      top: -40.0,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: CircleAvatar(
          child: Icon(Icons.close),
          backgroundColor: Colors.red,
        ),
      ),
    );
  }

  Widget showDescriptionWidget(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
        ),
        SizedBox(
          height: 5.0,
        ),
        Row(
          children: [
            SizedBox(
              width: 20.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                    topRight: Radius.circular(50)),
              ),
              height: size.height * 0.16,
              width: size.width * 0.42,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  '${visualNote!.description}',
                  style: TextStyle(color: MyColors.white),
                  textAlign: TextAlign.center,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
            ),
          ],
        ),
      ],
    );
  }

  Widget showDismissibleBackGround() {
    return Container(
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.delete,
                size: 80.0,
              ),
              Text(
                'Delete',
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ],
      ),
    );
  }
}
