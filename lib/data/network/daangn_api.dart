import 'package:fast_app_base/common/cli_common.dart';
import 'package:fast_app_base/data/network/result/api_error.dart';
import 'package:fast_app_base/screen/notification/vo/notification_dummies.dart';
import 'package:fast_app_base/screen/notification/vo/vo_notification.dart';

import '../../entity/dummies.dart';
import '../../entity/post/vo_product_post.dart';
import '../simple_result.dart';

class DaangnApi{

  static Future<SimpleResult<List<DaangnNotification>, ApiError>> getNotification() async{
    await sleepAsync(3000.ms);
    return SimpleResult.success(notificationList);
  }

  static Future<ProductPost> getPost(int id) async{
    await sleepAsync(500.ms);
    return ProductPost(
      simpleProductPost: post1,
      content: '깨긋하게 잘 쓴 물건이에요!'
        '잘 쓰시면 좋겠습니다!'
    );
  }

}