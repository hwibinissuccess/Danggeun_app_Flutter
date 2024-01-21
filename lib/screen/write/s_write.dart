import 'dart:io';
import 'dart:math';

import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/util/app_keyboard_util.dart';
import 'package:fast_app_base/common/widget/round_button_theme.dart';
import 'package:fast_app_base/common/widget/w_round_button.dart';
import 'package:fast_app_base/entity/post/vo_simple_product_post.dart';
import 'package:fast_app_base/entity/product/rpduct_status.dart';
import 'package:fast_app_base/entity/product/vo_product.dart';
import 'package:fast_app_base/entity/user/vo_address.dart';
import 'package:fast_app_base/screen/main/post_detail/s_post_detail.dart';
import 'package:fast_app_base/screen/main/tab/home/provider/post_provider.dart';
import 'package:fast_app_base/screen/write/d_select_image_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../entity/dummies.dart';

class WriteScreen extends ConsumerStatefulWidget {
  const WriteScreen({super.key});

  @override
  ConsumerState<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends ConsumerState<WriteScreen>
    with KeyboardDetector {
  final List<String> imageList = [];

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    titleController.addListener(() {
      setState(() {});
    });
    priceController.addListener(() {
      setState(() {});
    });
    descriptionController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: '내 물건 팔기'.text.bold.make(),
        actions: [
          Tap(
            onTap: () {},
            child: '임시저장'.text.make().p(15),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 150),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ImageSelectWidget(
              imageList,
              onTapDeleteImage: (imagePath){

                setState(() {
                imageList.remove(imagePath);
                });

              },
              onTap: () async {
                final selectedSource = await SelectImageSourceDialog().show();

                if (selectedSource == null) {
                  return;
                }
                final file =
                    await ImagePicker().pickImage(source: selectedSource);
                if (file == null) {
                  return;
                }
                setState(() {
                  imageList.add(file.path);
                });
              },
            ),
            _TitleEditor(titleController),
            height30,
            _PriceEditor(priceController),
            height30,
            _DescEditor(descriptionController),
          ],
        ).pSymmetric(h: 15),
      ),
      bottomSheet: isKeyboardOn
          ? null
          : RoundButton(
              text: isLoading ? '저장중' : '작성 완료',
              isFullWidth: true,
              borderRadius: 6,
              isEnabled: isValid,
              rightWidget: isLoading
                  ? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(),
                    ).pOnly(right: 80)
                  : null,
              onTap: () {
                final title = titleController.text;
                final price = int.parse(priceController.text);
                final desc = descriptionController.text;
                setState(() {
                  isLoading = true;
                });
                final list = ref.read(postProvider);
                final simpleProductPost = SimpleProductPost(
                    3,
                    user3,
                    Product(
                        user3, title, price, ProductStatus.normal, imageList),
                    title,
                    Address('서울시 다트구 플러터동', '플러터동'),
                    0,
                    0,
                    DateTime.now());
                ref.read(postProvider.notifier).state = List.of(list)
                  ..add(simpleProductPost);
                Nav.pop(context);
                Nav.push(PostDetailScreen(
                  simpleProductPost.id,
                  simpleProductPost: simpleProductPost,
                ));
              },
            ),
    );
  }

  bool get isValid =>
      isNotBlank(titleController.text) &&
      isNotBlank(priceController.text) &&
      isNotBlank(descriptionController.text);
}

class _ImageSelectWidget extends StatelessWidget {
  final List<String> imageList;
  final VoidCallback onTap;
  final void Function(String path) onTapDeleteImage;

  const _ImageSelectWidget(
    this.imageList, {
    required this.onTap,
    required this.onTapDeleteImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SelectImageButton(onTap: onTap, imageList: imageList)
                .pOnly(top: 10, right: 4),
            ...imageList.map(
              (e) => Stack(
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          File(e),
                          fit: BoxFit.fill,
                        ).box.rounded.border(color: Colors.grey).make()),
                  ).pOnly(left: 4, right: 10, top: 10),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Tap(
                        onTap: () {
                          onTapDeleteImage(e);
                        },
                        child: Transform.rotate(
                          angle: pi / 4,
                          child: Icon(Icons.add_circle),
                        ).pOnly(left: 30, bottom: 30),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SelectImageButton extends StatelessWidget {
  const SelectImageButton({
    super.key,
    required this.onTap,
    required this.imageList,
  });

  final VoidCallback onTap;
  final List<String> imageList;

  @override
  Widget build(BuildContext context) {
    return Tap(
      onTap: onTap,
      child: SizedBox(
        height: 80,
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: imageList.length.toString(),
                    style: TextStyle(color: Colors.orange),
                  ),
                  TextSpan(text: '/10'),
                ],
              ),
            ),
          ],
        ).box.rounded.border(color: Colors.grey).make(),
      ),
    );
  }
}

class _TitleEditor extends StatelessWidget {
  final TextEditingController controller;

  _TitleEditor(this.controller);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        '제목'.text.bold.make(),
        height5,
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: '제목',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.orange,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PriceEditor extends StatefulWidget {
  final TextEditingController controller;

  _PriceEditor(this.controller);

  @override
  State<_PriceEditor> createState() => _PriceEditorState();
}

class _PriceEditorState extends State<_PriceEditor> {
  bool isDonateMode = false;
  final priceNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        '거래 방식'.text.bold.make(),
        Row(
          children: [
            RoundButton(
              text: '판매하기',
              theme: isDonateMode
                  ? RoundButtonTheme.whiteWithBlueBorder
                  : RoundButtonTheme.blue,
              onTap: () {
                widget.controller.clear();
                setState(
                  () {
                    isDonateMode = false;
                  },
                );
                delay(() {
                  AppKeyboardUtil.show(context, priceNode);
                });
              },
            ),
            RoundButton(
                text: '나눔하기',
                theme: !isDonateMode
                    ? RoundButtonTheme.whiteWithBlueBorder
                    : RoundButtonTheme.blue,
                onTap: () {
                  widget.controller.text = "0";
                  setState(() {
                    isDonateMode = true;
                  });
                })
          ],
        ),
        height5,
        TextField(
          focusNode: priceNode,
          controller: widget.controller,
          keyboardType: TextInputType.number,
          enabled: !isDonateMode,
          decoration: InputDecoration(
            hintText: '￦ 가격을 입력해주세요.',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.orange,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DescEditor extends StatelessWidget {
  final TextEditingController controller;

  _DescEditor(this.controller);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        '자세한 설명'.text.bold.make(),
        height5,
        TextField(
          controller: controller,
          maxLines: 7,
          decoration: InputDecoration(
            hintText: '올릴 게시글 내용을 작성해주세요.',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.orange,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
