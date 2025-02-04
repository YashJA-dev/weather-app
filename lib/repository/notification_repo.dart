import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:weather/app/api/api_response.dart';
import 'package:weather/configs/app_const.dart';
import 'package:weather/services/networking/endpoints.dart';
import 'package:weather/services/networking/networking.dart';

import 'base_api_repo.dart';

class NotificationRepository extends BaseApiRepo {
  Future<APIResponse> fetchNotification(String weather) async {
    return await NetworkingService()
        .postAPICall(endpoint: Endpoints.openApiCompletion, queryParameters: {
      "key": AppConst.geminaiApiKey,
    }, data: {
      "contents": [
        {
          "parts": [
            {"text": "Weather is ${weather} : ${AppConst.alertPrompt}"}
          ]
        }
      ]
    });
  }
}
