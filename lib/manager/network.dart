library flutter_app_manager;

import 'dart:convert';

import 'package:flutter_helper/flutter_helper.dart';
import 'package:flutter_helper/models/error.dart';
import 'package:http/http.dart';

class NetworkManager {
  static NetworkManager? _instance;
  static NetworkManager get instance {
    _instance ??= NetworkManager._init();
    return _instance!;
  }

  NetworkManager._init();

  void setBaseUrl(String url) => this.baseUrl = url;
  late String baseUrl;

  Map<String, String> _postOptionsWithToken(String token) {
    return <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $token",
    };
  }

  Map<String, String> _postOptions() {
    return <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
  }

  Future<T?> httpGet<T, R extends BaseModel>(String path, {required R model, String? token}) async {
    final response = await get(
      Uri.parse(baseUrl + path),
      headers: token == null ? this._postOptions() : this._postOptionsWithToken(token),
    );
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody is List) {
        return responseBody.map((e) => model.fromJson(e) as R).toList() as T;
      } else if (responseBody is Map) {
        return model.fromJson(responseBody) as T;
      }
      throw "Body is not Map or List use httpGetString method";
    } else {
      this.throwError(response);
    }
  }

  Future<String?> httpGetString(String path, {String? token}) async {
    final response = await get(
      Uri.parse(baseUrl + path),
      headers: token == null ? this._postOptions() : this._postOptionsWithToken(token),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      this.throwError(response);
    }
  }

  Future<T?> httpPost<T,R extends BaseModel>(String path, {required R model, Map? data, String? token}) async {
   
    final response = await post(Uri.parse((path.contains("http") ? path : baseUrl + path)),
        headers: token == null ? this._postOptions() : this._postOptionsWithToken(token),
        body: data != null ? jsonEncode(data) : "");
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      if (responseBody is List) {
        return responseBody.map((e) => model.fromJson(e) as R).toList() as T;
      } else if (responseBody is Map) {
        return model.fromJson(responseBody) as T;
      }
       throw "Body is not Map or List use httpGetString method";
    } else {
      this.throwError(response);
    }
  }

  void throwError(Response response) {
    ErrorModel error;
    try {
      error = ErrorModel.fromJson(jsonDecode(response.body));
    } catch (ex) {
      error = ErrorModel(code: response.statusCode, message: response.reasonPhrase);
    }
    // if ((error.message?.isEmpty ?? true)) {
    //   error.message = "Bilinmeyen bir hata oluştu. Daha sonra tekrar deneyiniz";
    // }
    error.code = response.statusCode;
    if (response.statusCode == 400) {
      throw BadRequestError(error: error);
    } else if (response.statusCode == 401) {
      throw AuthorizeError.to();
    } else if (response.statusCode == 404) {
      throw NotFoundError(error: error);
    } else {
      throw InternalServerError(error: error);
    }
  }

  Future<String?> httpPostString(String path, {Map? data, String? token}) async {
    final response = await post(Uri.parse((path.contains("http") ? path : baseUrl + path)),
        headers: token == null ? this._postOptions() : this._postOptionsWithToken(token),
        body: data != null ? jsonEncode(data) : "");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      this.throwError(response);
    }
  }

  Future<Response> httpPostRes({required String path, data, String? token}) async {
    final response = await post(Uri.parse(path.contains("http") ? path : baseUrl + path),
        headers: token == null ? this._postOptions() : this._postOptionsWithToken(token),
        body: data != null ? jsonEncode(data) : "");
    return response;
  }

  Future<Response> httpGetRes({required String path, data, String? token}) async {
    final response = await get(
      Uri.parse(path.contains("http") ? path : baseUrl + path),
      headers: token == null ? this._postOptions() : this._postOptionsWithToken(token),
    );
    return response;
  }

  /// {'dosyaNo': '2021092', 'belgeID': '1', 'verilmeTarihi': '24.09.2021', 'sonTarihi': '25.09.2021'}
  Future<String?> uploadFile(String path, String filePath,
      {Map<String, String>? fields, String? token}) async {
    var request = MultipartRequest('POST', Uri.parse(path.contains("http") ? path : baseUrl + path));
    if (fields != null) {
      request.fields.addAll(fields);
    }

    request.files.add(await MultipartFile.fromPath('file', filePath));
    request.headers.addAll(token == null ? this._postOptions() : this._postOptionsWithToken(token));

    StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return (await response.stream.bytesToString());
    } else {
      await throwErrorWithStreamedResponse(response);
    }
  }

  Future<void> throwErrorWithStreamedResponse(StreamedResponse response) async {
    // ignore: prefer_typing_uninitialized_variables
    var error;
    try {
      error = ErrorModel.fromJson(jsonDecode(await response.stream.bytesToString()));
    } catch (ex) {
      error =  ErrorModel();
    }
    if ((error.message?.isEmpty ?? true)) {
      error.message = "Bilinmeyen bir hata oluştu. Daha sonra tekrar deneyiniz";
    }

    error.code = response.statusCode;

    if (response.statusCode == 400) {
      throw BadRequestError(error: error);
    } else if (response.statusCode == 401) {
      throw AuthorizeError.to();
    } else if (response.statusCode == 404) {
      throw NotFoundError(error: error);
    } else {
      throw InternalServerError(error: error);
    }
  }
}
