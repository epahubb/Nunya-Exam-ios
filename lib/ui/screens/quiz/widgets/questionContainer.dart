import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:flutter_tex/flutter_tex.dart';
import 'package:nunyaexam/features/quiz/models/question.dart';
import 'package:nunyaexam/ui/widgets/circularProgressContainner.dart';

class QuestionContainer extends StatelessWidget {
  final Question? question;
  final Color? questionColor;
  final int? questionNumber;
  final bool isMathQuestion;

  const QuestionContainer({
    Key? key,
    this.question,
    required this.isMathQuestion,
    this.questionColor,
    this.questionNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(isMathQuestion);
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * (0.1)),
                child: isMathQuestion
                    ? TeXView(
                        child: TeXViewDocument(
                          question!.question!,
                        ),
                        style: TeXViewStyle(
                            contentColor:
                                questionColor ?? Theme.of(context).primaryColor,
                            backgroundColor: Colors.transparent,
                            sizeUnit: TeXViewSizeUnit.pixels,
                            textAlign: TeXViewTextAlign.center,
                            fontStyle: TeXViewFontStyle(fontSize: 23)),
                      )
                    : Text(
                        questionNumber == null
                            ? "${question!.question}"
                            : "$questionNumber. " + "${question!.question}",
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                            color: questionColor ??
                                Theme.of(context).primaryColor),
                      ),
              ),
            ),
            question!.marks!.isEmpty
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      "[${question!.marks}]",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400,
                          color:
                              questionColor ?? Theme.of(context).primaryColor),
                    ),
                  ),
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
        question!.imageUrl == null
            ? Container()
            : question!.imageUrl!.isEmpty
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width * (0.8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0)),
                    height: MediaQuery.of(context).size.height * (0.225),
                    child: CachedNetworkImage(
                      errorWidget: (context, image, _) => Center(
                        child: Icon(
                          Icons.error,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        );
                      },
                      imageUrl: question!.imageUrl!,
                      placeholder: (context, url) => Center(
                          child:
                              CircularProgressContainer(useWhiteLoader: false)),
                    ),
                  ),
        question!.imageUrl == null
            ? Container()
            : SizedBox(
                height: 5.0,
              ),
      ],
    );
  }
}
