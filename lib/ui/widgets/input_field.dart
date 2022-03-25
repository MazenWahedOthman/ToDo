import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/theme.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget})
      : super(key: key);
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16),
     // height: 52,
      //width: SizeConfig.screenWidth,
      //padding: EdgeInsets.,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: titleStyle,),
          const SizedBox(height: 3,),
          Container(
            height: 52,
            width: SizeConfig.screenWidth,
           // margin: EdgeInsets.only(left: 14),
             padding: EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color:Colors.grey)
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    autofocus: false,
                    cursorColor: Get.isDarkMode?Colors.grey[100]:Colors.grey[700],
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle:subTitleStyle,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).backgroundColor,
                          width: 0
                        )
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor,
                              width: 0
                          )
                      ),
                    ),

                  ),
                ),
                widget??Container(),
              ],
            ),
          )
        ],
      ),
      
       );
  }
}
