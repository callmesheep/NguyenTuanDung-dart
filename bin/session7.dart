import 'package:session7/session7.dart' as session7;
import 'dart:convert';
import 'dart:io';


Future<Map<String, dynamic>> readJson(String filePath) async {
  final file = File(filePath);
  final jsonString = await file.readAsString();
  return json.decode(jsonString);
}

Future<void> writeJson(String filePath, Map<String, dynamic> data) async {
  final file = File(filePath);
  final jsonString = json.encode(data, toEncodable: (e) => e.toString());
  await file.writeAsString(jsonString);
}
void displayStudents(Map<String, dynamic> data) {
  List students = data['students'];
  for (var student in students) {
    print('ID: ${student['id']}');
    print('Tên: ${student['name']}');
    List subjects = student['subjects'];
    for (var subject in subjects) {
      print('Môn học: ${subject['name']}');
      print('Điểm số: ${subject['scores'].join(", ")}');
    }
    print('-' * 20);
  }
}
void addStudent(Map<String, dynamic> data, Map<String, dynamic> newStudent) {
  List students = data['students'];
  students.add(newStudent);
}
void editStudent(Map<String, dynamic> data, int studentId, Map<String, dynamic> updatedInfo) {
  List students = data['students'];
  for (var student in students) {
    if (student['id'] == studentId) {
      student['name'] = updatedInfo['name'];
      student['subjects'] = updatedInfo['subjects'];
      break;
    }
  }
}
Map<String, dynamic>? searchStudent(Map<String, dynamic> data, dynamic searchTerm) {
  List students = data['students'];
  for (var student in students) {
    if (student['name'].toLowerCase() == searchTerm.toString().toLowerCase() ||
        student['id'] == searchTerm) {
      return student;
    }
  }
  return null;
}
Future<void> main(List<String> arguments) async {
 final filePath = 'data/Student.json';
  var data = await readJson(filePath);

  while (true) {
    print("1. Hiển thị toàn bộ sinh viên");
    print("2. Thêm sinh viên");
    print("3. Sửa thông tin sinh viên");
    print("4. Tìm kiếm sinh viên");
    print("5. Thoát");
    stdout.write("Chọn chức năng: ");
    var choice = stdin.readLineSync();

    if (choice == '1') {
      displayStudents(data);
    } else if (choice == '2') {
      stdout.write("Nhập ID sinh viên: ");
      var id = int.parse(stdin.readLineSync()!);
      stdout.write("Nhập tên sinh viên: ");
      var name = stdin.readLineSync();
      stdout.write("Nhập số lượng môn học: ");
      var subjectCount = int.parse(stdin.readLineSync()!);

      List<Map<String, dynamic>> subjects = [];

      for (var i = 0; i < subjectCount; i++) {
        stdout.write("Nhập tên môn học: ");
        var subjectName = stdin.readLineSync();
        stdout.write("Nhập số lượng điểm: ");
        var scoreCount = int.parse(stdin.readLineSync()!);

        List<int> scores = [];
        for (var j = 0; j < scoreCount; j++) {
          stdout.write("Nhập điểm: ");
          var score = int.parse(stdin.readLineSync()!);
          scores.add(score);
        }

        subjects.add({"name": subjectName, "scores": scores});
      }

      addStudent(data, {
        "id": id,
        "name": name,
        "subjects": subjects
      });

      await writeJson(filePath, data);
    } else if (choice == '3') {
      stdout.write("Nhập ID sinh viên cần sửa: ");
      var id = int.parse(stdin.readLineSync()!);
      stdout.write("Nhập tên mới: ");
      var name = stdin.readLineSync();
      stdout.write("Nhập số lượng môn học mới: ");
      var subjectCount = int.parse(stdin.readLineSync()!);

      List<Map<String, dynamic>> subjects = [];

      for (var i = 0; i < subjectCount; i++) {
        stdout.write("Nhập tên môn học: ");
        var subjectName = stdin.readLineSync();
        stdout.write("Nhập số lượng điểm: ");
        var scoreCount = int.parse(stdin.readLineSync()!);

        List<int> scores = [];
        for (var j = 0; j < scoreCount; j++) {
          stdout.write("Nhập điểm: ");
          var score = int.parse(stdin.readLineSync()!);
          scores.add(score);
        }

        subjects.add({"name": subjectName, "scores": scores});
      }

      editStudent(data, id, {
        "name": name,
        "subjects": subjects
      });

      await writeJson(filePath, data);
    } else if (choice == '4') {
      stdout.write("Nhập tên hoặc ID: ");
      var searchTerm = stdin.readLineSync();
      var student = searchStudent(data, searchTerm);
      if (student != null) {
        print(student);
      } else {
        print("Không tìm thấy sinh viên.");
      }
    } else if (choice == '5') {
      break;
    } else {
      print("Lựa chọn không hợp lệ. Vui lòng chọn lại.");
    }
  }
}
