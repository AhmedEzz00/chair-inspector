import 'package:chair_inspector/business%20logic/cubit/sqflite_cubit.dart';
import 'package:chair_inspector/business%20logic/cubit/sqflite_state.dart';
import 'package:chair_inspector/data/moedls/visual_note.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';

class VisualNoteRepository {
  //Database? database;

  //List<Map>? visualNotes=[];

  Future createDataBase() {
    return openDatabase('cahir_inspector.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE chairData (id INTEGER PRIMARY KEY, title TEXT, status TEXT, description TEXT, imagePath TEXT, date TEXT)');
    });
  }

  Future insertToDataBase(Database database,
      {@required VisualNote? visualNote}) async {
    if (checkValidation(visualNote!)) {
      await database.transaction((txn) async {
        txn.rawInsert(
            'INSERT INTO chairData(title, status, description, imagePath, date) VALUES(?,?,?,?,?)',
            [
              visualNote.title,
              visualNote.status,
              visualNote.description,
              visualNote.imagePath,
              visualNote.date
            ]).then((value) {
              showToastMessage(message: 'Inserted successfuly');
            });
      });
    }
    else{
      showToastMessage(message: 'Can\'t insert empty data');
    }
    
  }

  Future<List<VisualNote>> getDataFromDataBase(database) async {
    List<Map<String, dynamic>> list =
        await database.rawQuery('SELECT * FROM chairData');
    return list.map((note) => VisualNote.fromJson(note)).toList();
  }

  Future deleteItemFromDataBase(database, int id) async {
      database.rawDelete('DELETE FROM chairData WHERE id = ?', [id]);
  }

  Future updateItemInDataBase(Database database,
      {@required VisualNote? visualNote, @required int? id}) async {
    if (checkValidation(visualNote!)) {
      Map<String, dynamic> rowToBeUpdated = {
        'title': visualNote.title.toString(),
        'status': visualNote.status.toString(),
        'description': visualNote.description.toString(),
        'imagePath': visualNote.imagePath.toString(),
        'date': visualNote.date.toString(),
      };
      await database.update('chairData', rowToBeUpdated,
          where: 'id = ?', whereArgs: [id]).then((value) {
            showToastMessage(message: 'Updated successfuly');
          });
    } else {
      showToastMessage(message: 'Can\'t update with empty data');
    }
  }

  bool checkValidation(VisualNote visualNote) {
    return !(visualNote.title.toString().isEmpty ||
        visualNote.status.toString().isEmpty ||
        visualNote.description.toString().isEmpty ||
        visualNote.imagePath.toString().isEmpty ||
        visualNote.date.toString().isEmpty);
  }

  void showToastMessage({String? message}) {
    Fluttertoast.showToast(
      msg: message!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
