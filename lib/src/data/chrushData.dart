import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;

class Student {
  final String seatNo;
  final String name;
  final String motherName;
  final String prn;

  Student({
    required this.seatNo,
    required this.name,
    required this.motherName,
    required this.prn,
  });

  factory Student.fromList(List<dynamic> data) {
    return Student(
      seatNo: data[0].toString(),
      name: data[1].toString(),
      motherName: data[2].toString(),
      prn: data[3].toString(),
    );
  }
}

class StudentDataService {
  static final StudentDataService _instance = StudentDataService._internal();

  factory StudentDataService() {
    return _instance;
  }

  StudentDataService._internal();

  Future<List<Student>> loadStudents() async {
    const String sheetId = "1ka-wv90iV_kD9_5yM68MPz73ZJ7yowOHEGnfQks3lWo";
    const String apiKey = "AIzaSyDBvMx0rJp0VXvcSQhaKc-RTzaoMD--c74";

    try {
      // Fetch data from Google Sheets API
      final response = await http.get(
        Uri.parse(
          "https://sheets.googleapis.com/v4/spreadsheets/$sheetId/values/Info?key=$apiKey",
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> rows = jsonResponse['values'];

        // Skip header row and map data to Student objects
        return rows
            .skip(1) // Skip the header row
            .map((row) => Student.fromList(row))
            .toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data from Google Sheets: $e');
      return [];
    }
  }
}
