import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:proweb_send/generated/l10n.dart';
import 'package:proweb_send/resources/resources.dart';
import 'package:proweb_send/ui/router/app_routes.dart';
import 'package:proweb_send/ui/widgets/custom_app_bar/custom_app_bar.dart';

class AuthPageContent extends StatelessWidget {
  final Animation<double> trsAnimation;
  const AuthPageContent({
    Key? key,
    required this.trsAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 190,
        child: Center(
          child: Text(
            S.of(context).hello_title,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedBuilder(
                animation: trsAnimation,
                builder: (context, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-10, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: trsAnimation,
                      curve: Curves.linear,
                    )),
                    child: child,
                  );
                },
                child: SvgPicture.asset(AppIcons.logo),
              ),
              const SizedBox(height: 35),
              AnimatedBuilder(
                animation: trsAnimation,
                builder: (context, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(10, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: trsAnimation,
                      curve: Curves.linear,
                    )),
                    child: child,
                  );
                },
                child: SvgPicture.asset(AppIcons.appTitle),
              ),
              const SizedBox(height: 80),
              AnimatedBuilder(
                animation: trsAnimation,
                builder: (context, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-10, 0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: trsAnimation,
                      curve: Curves.linear,
                    )),
                    child: child,
                  );
                },
                child: SizedBox(
                  height: 60,
                  width: 293,
                  child: FloatingActionButton.extended(
                    label: Center(child: Text(S.of(context).start_btn_txt)),
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.home);
                    },
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
