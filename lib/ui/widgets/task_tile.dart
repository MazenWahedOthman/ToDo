import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/theme.dart';

class TaskTile extends StatelessWidget {
  TaskTile(this.task);

  Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(
         SizeConfig.orientation == Orientation.landscape ? 4 : 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: _getColor(task.color),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(task.title!,style: GoogleFonts.lato(
                   textStyle: TextStyle(
                     fontSize: 16,
                     fontWeight: FontWeight.bold,
                     color: Colors.white,
                   )
               ),),
               SizedBox(height: 12,),
               Row(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   Icon(Icons.access_time_rounded,color: Colors.grey[200],size: 18,),
                   SizedBox(width: 12,),
                   Text('${task.startTime} - ${task.endTime}',style: GoogleFonts.lato(
                       textStyle: TextStyle(
                         fontSize: 13,
                         fontWeight: FontWeight.bold,
                         color: Colors.grey[100],
                       )
                   ),),
                 ],
               ),
               SizedBox(height: 12,),
               Text('${task.note}',style: GoogleFonts.lato(
                   textStyle: TextStyle(
                     fontSize: 15,
                     fontWeight: FontWeight.bold,
                     color: Colors.grey[100],
                   )
               ),),


             ],
           ),
         ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: 60,
                width: 0.5,
                color: Colors.grey[200]!.withOpacity(0.7),
              ),
              RotatedBox(
                quarterTurns: 3,
                child: Text(
                  task.isCompleted == 0 ? 'TODO' : 'Completed',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _getColor(int? color) {
    switch (color) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return orangeClr;
      default:
        return bluishClr;
    }
  }
}
