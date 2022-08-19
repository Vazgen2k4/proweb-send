import 'package:flutter/material.dart';
import 'package:proweb_send/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';
import 'package:proweb_send/ui/widgets/choos_image/choose_image.dart';
import 'package:proweb_send/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  // Widget titleWidget(ProUser user) {
  //   return SingleChildScrollView(
  //     physics: const NeverScrollableScrollPhysics(),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         const ChoseImageWidget(),
  //         const SizedBox(height: 16),
  //         Text(
  //           user.name ?? '',
  //           style: const TextStyle(
  //             color: AppColors.text,
  //             fontSize: 17,
  //             letterSpacing: -.41,
  //             height: 22 / 17,
  //           ),
  //         ),
  //         const SizedBox(height: 3),
  //         Text(
  //           '@' + (user.nikNameId ?? ''),
  //           style: const TextStyle(
  //             color: AppColors.text,
  //             fontSize: 17,
  //             letterSpacing: -.41,
  //             height: 22 / 17,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final authBlocState = context.watch<AuthBloc>().state as AuthLoaded;
    final user = authBlocState.user;
    final imgUrl = user.imagePath;
    final img = imgUrl != null ? NetworkImage(imgUrl) : null;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: <Widget>[
        SliverAppBar(
          leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
          automaticallyImplyLeading: false,
          centerTitle: true,
          floating: true,
          pinned: true,
          expandedHeight: 170,
          // forceElevated: true,
          snap: true,
          flexibleSpace: FlexibleSpaceBar(
            background: bg(),
            stretchModes: const [
              StretchMode.fadeTitle,
              StretchMode.blurBackground
            ],
            centerTitle: true,
            expandedTitleScale: 1,
            collapseMode: CollapseMode.pin,
            title: Center(
              child: ChoseImageWidget(
                radius: 40,
                image: img,
              ),
            ),
          ),

          forceElevated: true,
          backgroundColor: Colors.transparent,

          bottom: CustomAppBar(
            height: kToolbarHeight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  Text(
                    user.name ?? '',
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 17,
                      letterSpacing: -.41,
                      height: 22 / 17,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '@' + (user.nikNameId ?? ''),
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 17,
                      letterSpacing: -.41,
                      height: 22 / 17,
                    ),
                  ),
                ],
              ),
            ),
          ),
          onStretchTrigger: () async {
            print(3213123123);
          },
        ),
        SliverAnimatedList(
          initialItemCount: 200,
          itemBuilder: (context, index, animation) => Container(
            width: double.infinity,
            height: 200,
            color: const Color.fromARGB(255, 217, 51, 51),
            margin: const EdgeInsets.only(bottom: 25),
          ),
        ),
      ],
    );
  }

  DecoratedBox bg({Widget? child}) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(109, 246, 255, 0.8),
            Color.fromRGBO(113, 255, 221, 0.8),
          ],
          begin: Alignment.topLeft,
          // end: ,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}

class SettingsPageHaderDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Widget extendChild;
  final Widget child;
  final Color? color;
  const SettingsPageHaderDelegate({
    required this.expandedHeight,
    required this.child,
    required this.extendChild,
    this.color,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color),
      child: Stack(
        fit: StackFit.expand,
        children: [
          buildOnLoose(shrinkOffset),
          buildOnExtend(shrinkOffset),
        ],
      ),
    );
  }

  Widget buildOnExtend(double shrinkOffset) {
    return SafeArea(
      child: Opacity(
        opacity: disApear(shrinkOffset),
        child: extendChild,
      ),
    );
  }

  Widget buildOnLoose(double shrinkOffset) {
    return SafeArea(
      child: Opacity(
        opacity: apear(shrinkOffset),
        child: child,
      ),
    );
  }

  double apear(double shrinkOffset) => shrinkOffset / expandedHeight;
  double disApear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
