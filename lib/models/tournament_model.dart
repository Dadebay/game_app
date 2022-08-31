// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:game_app/controllers/tournament_controller.dart';
import 'package:http/http.dart' as http;

import 'package:game_app/constants/index.dart';

import 'user_models/auth_model.dart';

class TournamentModel {
  TournamentModel({this.id, this.awards, this.description_ru, this.description_tm, this.finish_date, this.image, this.map, this.mode, this.participated_users, this.price, this.start_date, this.title, this.winners});

  factory TournamentModel.fromJson(Map<dynamic, dynamic> json) {
    return TournamentModel(
      id: json["id"],
      title: json["title"],
      mode: json["mode"],
      map: json["map"],
      start_date: json["start_date"],
      finish_date: json["finish_date"],
      description_tm: json["description_tm"],
      description_ru: json["description_ru"],
      image: json["image"],
      price: json["price"].toString(),
      awards: ((json['awards'] ?? []) as List).map((json) => Awards.fromJson(json)).toList(),
      winners: json["winners"],
      participated_users: ((json['participated_users'] ?? []) as List).map((json) => ParticipatedUsers.fromJson(json)).toList(),
    );
  }

  final List<Awards>? awards;
  final String? description_ru;
  final String? description_tm;
  final String? finish_date;
  final int? id;
  final String? image;
  final String? map;
  final String? mode;
  final List<ParticipatedUsers>? participated_users;
  final String? price;
  final String? start_date;
  final String? title;
  final List? winners;

  Future<List<TournamentModel>> getTournaments() async {
    TournamentController controller = Get.put(TournamentController());
    List<TournamentModel> abc = [];
    controller.tournamentLoading.value = 0;
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/turnirs/",
        ),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        });
    print(response.body);
    if (response.statusCode == 200) {
      controller.tournamentLoading.value = 2;
      var decoded = utf8.decode(response.bodyBytes);
      final responseJson = json.decode(decoded);
      for (final Map product in responseJson["results"]) {
        abc.add(TournamentModel.fromJson(product));
      }
      controller.addToList(list: abc);

      return abc;
    } else {
      controller.tournamentLoading.value = 1;
      return [];
    }
  }

  Future<TournamentModel> getTournamentID(int id) async {
    final response = await http.get(
        Uri.parse(
          "$serverURL/api/turnirs/turnir/$id/",
        ),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
          'Charset': 'utf-8',
        });

    if (response.statusCode == 200) {
      var decoded = utf8.decode(response.bodyBytes);
      final responseJson = json.decode(decoded);
      return TournamentModel.fromJson(responseJson);
    } else {
      return TournamentModel();
    }
  }

  Future checkStatus({required int tournamentID, required bool value}) async {
    final token = await Auth().getToken();
    final response = await http.get(
      Uri.parse("$serverURL/api/turnirs/get-code/$tournamentID"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var decoded = utf8.decode(response.bodyBytes);
      final responseJson = json.decode(decoded);
      value == true ? showSnackBar("tournamentInfo15", "${responseJson["code"]}", kPrimaryColor) : null;
      return response.statusCode;
    } else {
      value == true ? showSnackBar("tournamentInfo15", "tournamentInfo16", kPrimaryColorBlack) : null;
      return response.statusCode;
    }
  }

  Future participateTournament({required int tournamentID}) async {
    final token = await Auth().getToken();
    final response = await http.post(Uri.parse("$serverURL/api/turnirs/participate/"),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "turnir_id": tournamentID,
        }));
    print(response.body);
    if (response.statusCode == 200) {
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }
}

class Awards {
  Awards({this.id, this.award, this.place, this.turnir});

  factory Awards.fromJson(Map<String, dynamic> json) {
    return Awards(
      id: json["id"],
      award: json["award"],
      place: json["place"],
      turnir: json["turnir"],
    );
  }

  final String? award;
  final int? id;
  final int? place;
  final int? turnir;
}

class ParticipatedUsers {
  ParticipatedUsers({this.id, this.account_location_ru, this.account_location_tm, this.userImage, this.userName, this.created_date, this.user, this.turnir});

  factory ParticipatedUsers.fromJson(Map<String, dynamic> json) {
    return ParticipatedUsers(id: json["id"], created_date: json["created_date"], user: json["user"], turnir: json["turnir"], userImage: json["account_image"], userName: json["account_nickname"], account_location_tm: json["account_location_tm"], account_location_ru: json["account_location_ru"]);
  }

  final String? account_location_ru;
  final String? account_location_tm;
  final String? created_date;
  final int? id;
  final int? turnir;
  final int? user;
  final String? userImage;
  final String? userName;
}
