// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:getx_example/screens/home/home_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getx_example/screens/home/widgets/button_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameController controller = Get.put(GameController());
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            // Background image
            Image.asset(
              'assets/images/background.jpg',
              height: height,
              width: width,
              fit: BoxFit.cover,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display the current riddle
                  Text(
                    textAlign: TextAlign.center,
                    controller.currentQuestion,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Display the answer spaces
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: List.generate(
                      controller.currentAnswer.length,
                      (index) => Container(
                        margin: EdgeInsets.only(right: 10.w, bottom: 10.h),
                        width: 50,
                        height: 60,
                        decoration: BoxDecoration(
                          color: index < controller.inputAnswer.value.length
                              ? Colors.blue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 3,
                            color: Colors.blue,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            index < controller.inputAnswer.value.length
                                ? controller.inputAnswer.value[index]
                                : "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Display the random alphabet buttons
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: List.generate(
                      controller.shuffledLetters.length,
                      (index) => ButtonItem(
                        title: controller.shuffledLetters[index],
                        onPressed: () {
                          controller.add(controller.shuffledLetters[index]);
                          debugPrint("kirdi");
                          controller.removeAlphabet(
                              controller.shuffledLetters[index]);
                          if (controller.error.value) {
                            Get.dialog(
                              AlertDialog(
                                title: Text(
                                  "Tugadi ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                content: Text(
                                  "Topishmoqlar qolmadi",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                actions: [
                                  Center(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30.w, vertical: 11.h),
                                          backgroundColor: Colors.blueAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                          )),
                                      onPressed: () {
                                        controller.currentIndex.value = 0;
                                        controller.inputAnswer.value = "";
                                        controller.errorMessage.value = "";
                                        controller.shuffleLetters();
                                        Get.back();
                                      },
                                      child: Text(
                                        "Restart",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: controller.remove,
        shape: CircleBorder(),
        child: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 25.sp,
        ),
      ),
    );
  }
}
