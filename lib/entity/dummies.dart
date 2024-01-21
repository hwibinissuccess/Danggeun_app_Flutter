import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/entity/post/vo_simple_product_post.dart';
import 'package:fast_app_base/entity/product/rpduct_status.dart';
import 'package:fast_app_base/entity/product/vo_product.dart';
import 'package:fast_app_base/entity/user/vo_address.dart';
import 'package:fast_app_base/entity/user/vo_user.dart';

String picSum(int id) {
  return 'https://picsum.photos/id/$id/200/200';
}

final user1 = User(
  id: 1,
  nickname: "홍길동",
  temperature: 36.5,
  profileUrl: picSum(1010),
);

final user2 = User(
  id: 2,
  nickname: "김민수",
  temperature: 36.3,
  profileUrl: picSum(900),
);

final user3 = User(
  id: 3,
  nickname: "이연수",
  temperature: 33.3,
  profileUrl: picSum(700),
);

final product1 = Product(
    user1,
    '아이폰15',
    900000,
    ProductStatus.normal,
    [picSum(100), picSum(133), picSum(199)]);

final product2 = Product(
    user1,
    '아이폰15 PRO',
    150000,
    ProductStatus.normal,
    [picSum(200), picSum(233), picSum(299)]);

final product3 = Product(
    user1,
    '갤럭시 24',
    800000,
    ProductStatus.normal,
    [picSum(300), picSum(333), picSum(399)]);

final post1 = SimpleProductPost(
  1,
  product1.user,
  product1,
  '글의 내용~!~!~!',
  Address(
    ' 서울시 강북구 도봉로',
    '도봉로',
  ),
  3,
  9,
  DateTime.now().subtract(30.minutes),
);

final post2 = SimpleProductPost(
  2,
  product1.user,
  product1,
  '글의 내용~!~!~!222222',
  Address(
    ' 서울특별시 나만의 아지트',
    '서울특별시',
  ),
  27,
  31,
  DateTime.now().subtract(36.minutes),
);

final post3 = SimpleProductPost(
  3,
  product1.user,
  product1,
  '글의 내용~!~!~!33333333333',
  Address(
    ' 서울시 광진구 구의동',
    '구의동',
  ),
  39,
  91,
  DateTime.now().subtract(39.minutes),
);

final postList = [
  post1,
  post2,
  post3,
  post1,
  post2,
  post3,
];
