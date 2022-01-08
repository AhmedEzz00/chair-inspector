import 'package:chair_inspector/business%20logic/cubit/sqflite_state.dart';
import 'package:bloc/bloc.dart';
import 'package:chair_inspector/data/moedls/visual_note.dart';
import 'package:chair_inspector/data/repository/visual_note_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteCubit extends Cubit<SqfliteState> {
  VisualNoteRepository visualNoteRepository = VisualNoteRepository();
  Database? database;
  SqfliteCubit() : super(AppInitial());
  List<VisualNote>? retrievedVisualNotes = [];
  String? imagePath;
  bool? bottomSheetShown= false;

  static SqfliteCubit get(context) => BlocProvider.of(context);

  void createDataBase() {
    visualNoteRepository.createDataBase().then((value) {
      database = value;
      emit(AppCreatedDataBaseState());
    }).then((value) {
      getDataFromDataBase(database).then((value) {
        retrievedVisualNotes = value;
        emit(AppGetDataFromDataBaseState());
      });
    });
  }

  Future insertToDataBase({
    VisualNote? visualNote,
  }) async {
    visualNoteRepository
        .insertToDataBase(database!, visualNote: visualNote)
        .then((value) {
      emit(AppInsertToDataBaseState());
      getDataFromDataBase(database).then((value) {
        retrievedVisualNotes = value;
        emit(AppGetDataFromDataBaseState());
      }).catchError((onError) {
        print(onError.toString());
      });
    });
  }

  Future<List<VisualNote>> getDataFromDataBase(database) async {
    return visualNoteRepository.getDataFromDataBase(database);
  }

  Future deleteItemFromDataBase(int id) async {
    visualNoteRepository.deleteItemFromDataBase(database!, id).then((value) {
      
      //emit(AppDeleteItemFromDataBaseState());
      getDataFromDataBase(database).then((value) {
        retrievedVisualNotes = value;
      }).then((value) {
        emit(AppUpdateDataBaseState());
      });
      
    });
  }

  Future updateItemInDataBase({VisualNote? visualNote, int? id}) async {
    visualNoteRepository
        .updateItemInDataBase(database!, visualNote: visualNote,id: id)
        .then((value) {
      getDataFromDataBase(database).then((value) {
        retrievedVisualNotes= value;
        emit(AppUpdateDataBaseState());
      });
      
    });
  }

  void setBottomSheetState({bool? state,}){
    bottomSheetShown= state;
    emit(AppBottomSheetChangedState());
  }
}
