import 'package:flutter/material.dart';
import 'package:jklist/utils/utilitarios.dart';
import 'package:jklist/view/startup/startup_view_model.dart';
import 'package:jklist/widget/walk_through.dart';
import 'package:stacked/stacked.dart';

class IntroView extends StatefulWidget {
  @override
  _IntroViewState createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  final PageController controller = new PageController();
  int currentPage = 0;
  bool lastPage = false;

  void _onPageChanged(int page) {
    setState(() {
      currentPage = page;
      if (currentPage == 3) {
        lastPage = true;
      } else {
        lastPage = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return ViewModelBuilder<StartUpViewModel>.reactive(
      viewModelBuilder: () => StartUpViewModel(),
      builder: (context, model, child) => Container(
        color: Color(0xFFEEEEEE),
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 3,
              child: PageView(
                children: <Widget>[
                  Walkthrough(
                    title: DSStringLocal.wt1,
                    content: DSStringLocal.wc1,
                    imageIcon: Icons.calendar_today,
                  ),
                  Walkthrough(
                    title: DSStringLocal.wt2,
                    content: DSStringLocal.wc2,
                    imageIcon: Icons.chrome_reader_mode,
                  ),
                  Walkthrough(
                    title: DSStringLocal.wt3,
                    content: DSStringLocal.wc3,
                    imageIcon: Icons.check_box,
                  ),
                  Walkthrough(
                    title: DSStringLocal.wt4,
                    content: DSStringLocal.wc4,
                    imageIcon: Icons.perm_identity,
                  ),
                  Walkthrough(
                    title: DSStringLocal.wt5,
                    content: DSStringLocal.wc5,
                    imageIcon: Icons.attach_money,
                  ),
                ],
                controller: controller,
                onPageChanged: _onPageChanged,
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text(lastPage ? "" : DSStringLocal.skip,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0)),
                    onPressed: () =>
                    lastPage ? null : model.goToHome(),
                  ),
                  FlatButton(
                    child: Text(lastPage ? DSStringLocal.gotIt : DSStringLocal.next,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0)),
                    onPressed: () => lastPage
                        ? model.goToHome()
                        : controller.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn),
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

