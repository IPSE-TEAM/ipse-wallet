import 'package:connectivity/connectivity.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:ipsewallet/config/config.dart';
import 'package:ipsewallet/utils/my_utils.dart';
import 'package:ipsewallet/utils/result_data.dart';

class HttpManager {
  static Future<ResultData> request(
    String url, {
    params,
    queryParams,
    String method = 'GET',
    bool useBaseUrl = true,
    String lang = 'zh',
    bool isShowError = true,
  }) async {
  
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
    } else {
      showErrorMsg(lang == "zh" ? '网络连接失败' : 'Network connection failed');
      return ResultData('Network_connection_failed', 111);
    }

    BaseOptions options;
    if (options == null) {
      options = new BaseOptions(method: method);
      options.headers = {"Content-Type": "application/json"};
      if (useBaseUrl == true) {
        options.baseUrl = Config.baseUrl;

        // if (globalAppStore.ipse.authrizationToken == null) {
        //   globalAppStore.ipse.getAuthrizationToken();
        // }
        // options.headers["Authorization"] =
        //     globalAppStore.ipse.authrizationToken;
      }
      options.connectTimeout = 60000; //30s
      options.receiveTimeout = 60000;
    } else {
      options.method = method;
    }

    Dio dio = new Dio(options);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, String host, int port) {
        return true;
      };
    };
    try {
      Response response =
          await dio.request(url, data: params, queryParameters: queryParams);
 
      if (useBaseUrl && response.data["code"] == 0) {
        if (response.data["message"] != null &&
            response.data["message"] != "" 
            ) {
          showErrorMsg(lang == "zh"
              ? response.data["message"]
              : response.data["message_en"]);
        }
        print(response.data);
        return ResultData(response.data, 111);
      }
      return ResultData(response.data, response.statusCode);
    } on DioError catch (e) {
      String msg = "";
      if (e.type == DioErrorType.connectTimeout) {
        // It occurs when url is opened timeout.
        msg = "connectTimeout";
      } else if (e.type == DioErrorType.sendTimeout) {
        // It occurs when url is sent timeout.
        msg = "sendTimeout";
      } else if (e.type == DioErrorType.receiveTimeout) {
        //It occurs when receiving timeout
        msg = "receiveTimeout";
      } else if (e.type == DioErrorType.response) {
        // When the server response, but with a incorrect status, such as 404, 503...
        msg = "Error: ${e.response.statusMessage}";
      } else if (e.type == DioErrorType.cancel) {
        // When the request is cancelled, dio will throw a error with this type.
        msg = "cancel";
      } else {
        //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
        // msg = "Unknow error";
      }
      if (msg != null && msg.isNotEmpty && isShowError) showErrorMsg(msg);
      return ResultData(msg, 111);
    }
  }
}
