import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_app/services/question_service.dart';
import 'package:quiz_app/utils/constants.dart';
import 'package:quiz_app/widgets/abstract_card.dart';
import 'package:quiz_app/widgets/category_card.dart';
import 'package:quiz_app/widgets/my_custom_back_icon.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void _onTap(int id) {
      GoRouter.of(context).goNamed('mode', pathParameters: {
        'id': id.toString(),
      });
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: lightPurple,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const MyCustomBackIcon(),
              const AbstractCard(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    color: white,
                  ),
                  child: Column(
                    children: [
                      mySpacer,
                      Text(
                        'Choose a Category',
                        style: TextStyle(
                          color: purple,
                          fontSize: fontSize * 2,
                          fontWeight: bold,
                        ),
                      ),
                      FutureBuilder(
                        future: QuestionService().getCategories(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return const Center(
                                child: Text('Something went wrong!'));
                          }
                          return Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CategoryCard(
                                  name: snapshot.data[index].name,
                                  id: snapshot.data[index].id,
                                  onTap: () {
                                    _onTap(snapshot.data[index].id);
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
