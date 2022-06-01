import '../Models/Note.dart';
import '../Repositories/db_helper.dart';

class NoteService {

  DBHelper dbHelper = DBHelper();

  readData() async {
    return await dbHelper.readActivite('Note');
  }

  saveData(Note note) async {
    return await dbHelper.insertActivite('Note', note.toMap());
  }


}