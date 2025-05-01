import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:medzo/util/api_key_enum.dart';
import 'package:medzo/util/strings.dart';
import 'package:medzo/util/token_store.dart';

class ApiService {
  // final String _baseUrl = ApiKeyEnum.baseUrl.key;
  // String accessToken =
  //     "eyJraWQiOiJ5K1wvSzMyRDRwTG10K1QwVkpOZWZZOWt3alBPUVFmUWhXMXNhZ1hjSmhoYz0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI0ZTE3YXIyYWs3NGprOGprZHZhZ3Q3c250biIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoibWVkem9Sc1wvbm9ybWFsIiwiYXV0aF90aW1lIjoxNzQxMDg2MDY5LCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAuYXAtc291dGgtMS5hbWF6b25hd3MuY29tXC9hcC1zb3V0aC0xXzNOUVBTT2dkSSIsImV4cCI6MTc0MTA4OTY2OSwiaWF0IjoxNzQxMDg2MDY5LCJ2ZXJzaW9uIjoyLCJqdGkiOiI3YjNkOTZjZC0wMDQ3LTQ1MDktODc5NC0yN2RiNjE2ODUwZDciLCJjbGllbnRfaWQiOiI0ZTE3YXIyYWs3NGprOGprZHZhZ3Q3c250biJ9.JRK55D1pGxlhmNFkqyqXYSLo0bn7yqEKD9kfz2R7EBUQoNpAh0VpLJTLfhr4WJJme3DrkbSu0qDyrIMNLrX1A7DVkLBpPn-42yM9S5f7uYWyobAhu-zlAS51G2rpPArmhxvHwGrnw_Ae3bvkst8kIbNDrkA-sq3sho_G3I2zy7rRUTxpvgfajYqSUWwLQ7xeC9o1vw8KO8luss6C__4pP-C3vC9zEv6zgllVDWUNCmQUeVKVnHz_iCKbAdCpQuBt8xtzdguRNbpXbahyPQDEDKKjTpmSRUqd04v_qCd3sga_wMC2jl6irfFcIP76qpcnGSyeS-PMAkOaPPunfv";

  String handleError(dynamic error) {
    if (error is SocketException) {
      if (error.osError != null && error.osError!.errorCode == 101) {
        return Strings.noInterntError;
      } else {
        return Strings.serverError;
      }
    } else if (error is TimeoutException) {
      return Strings.requestTimeoutError;
    } else if (error is ClientException) {
      return Strings.clientError;
    } else {
      String errorMessage = error.toString();
      String message = errorMessage.replaceFirst(
        "Exception: ",
        Strings.emptySpace,
      );
      var errormsg = jsonDecode(message);
      return errormsg[Strings.errorLowerCaseText];
    }
  }

  // GET request
  Future<dynamic> getRequest(String endpoint) async {
    String? accessToken = await tokenStore.read(
      key: ApiKeyEnum.accesstoken.key,
    );
    try {
      final response = await http
          .get(
            Uri.parse('${ApiKeyEnum.baseUrl.key}/$endpoint'),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 60));

      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> getPredefinedURL(String endpoint) async {
    String? accessToken = await tokenStore.read(
      key: ApiKeyEnum.accesstoken.key,
    );
    try {
      final response = await http
          .get(
            Uri.parse('${ApiKeyEnum.baseUrl.key}/$endpoint'),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'text/plain',
            },
          )
          .timeout(const Duration(seconds: 10));

      return response;
    } catch (e) {
      rethrow;
    }
  }

  //GET FILE BY URL
  Future<dynamic> getFileByURL(String endpoint) async {
    try {
      final response = await http
          .get(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 60));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  Future<dynamic> postRequest(String endpoint, dynamic payload) async {
    String? accessToken = await tokenStore.read(
      key: ApiKeyEnum.accesstoken.key,
    );
    try {
      final response = await http
          .post(
            Uri.parse('${ApiKeyEnum.baseUrl.key}/$endpoint'),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 60)); // Optional timeout
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // PUT request
  Future<dynamic> putRequest(String endpoint, Uint8List payload) async {
    try {
      final response = await http
          .put(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
            body: payload,
          )
          .timeout(const Duration(seconds: 60));
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // UPDATE request
  Future<dynamic> updateRequest(
    String endpoint,
    Map<String, dynamic> payload,
  ) async {
    String? accessToken = await tokenStore.read(
      key: ApiKeyEnum.accesstoken.key,
    );
    try {
      final response = await http
          .put(
            Uri.parse('${ApiKeyEnum.baseUrl.key}/$endpoint'),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 60)); // Optional timeout
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> multiDeleteRequest(String endpoint, List<int> payLoad) async {
    String? accessToken = await tokenStore.read(
      key: ApiKeyEnum.accesstoken.key,
    );
    try {
      final response = await http
          .delete(
            Uri.parse('${ApiKeyEnum.baseUrl.key}/$endpoint'),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(payLoad),
          )
          .timeout(const Duration(seconds: 60));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> individualDeleteRequest(String endpoint, int payLoad) async {
    String? accessToken = await tokenStore.read(
      key: ApiKeyEnum.accesstoken.key,
    );
    try {
      final response = await http
          .delete(
            Uri.parse('${ApiKeyEnum.baseUrl.key}/$endpoint/$payLoad'),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 60));
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //refresh access token
  Future<bool> refreshAccessToken() async {
    try {
      String username = "4e17ar2ak74jk8jkdvagt7sntn";
      String password = "1ghkq1st6492vobg0i1eb4au7qpv5o76sb79n31p8s1qs6376aku";

      // Encode username:password in Base64
      String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$password'))}';

      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': basicAuth,
      };

      var response = await http.post(
        Uri.parse(
          'https://ap-south-13nqpsogdi.auth.ap-south-1.amazoncognito.com/oauth2/token',
        ),
        headers: headers,
        body: "grant_type=client_credentials",
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await tokenStore.write(
          key: ApiKeyEnum.accesstoken.key,
          value: data[ApiKeyEnum.accesstoken.key],
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }
}

ApiService apiService = ApiService();
