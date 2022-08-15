import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proweb_send/domain/bloc/auth_bloc/auth_bloc.dart';
import 'package:proweb_send/generated/l10n.dart';
import 'package:proweb_send/ui/router/app_routes.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';
import 'package:proweb_send/ui/widgets/auth/auth_button.dart';
import 'package:proweb_send/ui/widgets/custom_app_bar/custom_app_bar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar.auth(
        child: Center(
          child: SizedBox(
            width: 319,
            child: Text(
              'Поздравляем с созданием аккаунта в PROCHAT!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                height: 24 / 20,
                color: AppColors.text,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          physics: BouncingScrollPhysics(),
          child: Center(
            child: RegisterForm(),
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final newState = state as AuthLoaded;
        final errors = newState.erros;

        return Column(
          children: <Widget>[
            const ChoseImageWidget(),
            const SizedBox(height: 50),
            RefisterInputsWidget(
              hasError: errors.nameEmpty,
              placeholder: 'Имя',
              controller: AuthLoaded.userController.nameController,
            ),
            const SizedBox(height: 30),
            RefisterInputsWidget(
              hasError: errors.userNameBusy || errors.userNameEmpty,
              controller: AuthLoaded.userController.userNikNameController,
              placeholder: 'Никнейм',
              maxLength: 19,
            ),
            const SizedBox(height: 30),
            RefisterInputsWidget(
              controller: AuthLoaded.userController.descrController,
              placeholder: 'О себе',
              maxLength: 300,
            ),
            const SizedBox(height: 56),
            AuthButton(
              title: S.of(context).safe_btn,
              action: () async {
                final authBloc = context.read<AuthBloc>();

                authBloc.add(AuthCreateCheckErrorsAndRegister(
                  onSuccess: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.auth,
                      (route) => false,
                    );
                  },
                ));
              },
            ),
          ],
        );
      },
    );
  }
}

class ChoseImageWidget extends StatefulWidget {
  final double radius;
  const ChoseImageWidget({Key? key, this.radius = 50}) : super(key: key);

  @override
  State<ChoseImageWidget> createState() => _ChoseImageWidgetState();
}

class _ChoseImageWidgetState extends State<ChoseImageWidget> {
  String? imgPath;

  @override
  Widget build(BuildContext context) {
    final userController = AuthLoaded.userController;

    return GestureDetector(
      onTap: () async {
        final file = await userController.selectImage();
        if (file == null) return;
        imgPath = file.path;
        setState(() {});
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius),
        child: CircleAvatar(
          backgroundColor: const Color(0xffd9d9d9),
          backgroundImage: imgPath == null ? null : FileImage(File(imgPath!)),
          radius: widget.radius,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: widget.radius,
              alignment: Alignment.center,
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(3, 3, 3, .5)),
              child: const Icon(
                Icons.photo_camera_rounded,
                color: AppColors.text,
                size: 31,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RefisterInputsWidget extends StatefulWidget {
  final TextEditingController controller;
  final int? maxLength;
  final String? placeholder;
  final bool hasError;
  const RefisterInputsWidget({
    Key? key,
    required this.controller,
    this.maxLength,
    this.placeholder,
    this.hasError = false,
  }) : super(key: key);

  @override
  State<RefisterInputsWidget> createState() => _RefisterInputsWidgetState();
}

class _RefisterInputsWidgetState extends State<RefisterInputsWidget> {
  Color? color;

  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {});
    });
    color = widget.hasError ? AppColors.error : AppColors.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 290,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.maxLength != null)
            Text(
              '${widget.controller.value.text.length}/${widget.maxLength}',
              style: TextStyle(
                color: color,
                fontSize: 14,
                height: 1,
              ),
            ),
          TextField(
            textCapitalization: TextCapitalization.sentences,
            maxLength: widget.maxLength,
            style: const TextStyle(
              color: Color(0xff646464),
              fontSize: 16,
              height: 1.5,
            ),
            controller: widget.controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 13,
                horizontal: 16,
              ),
              errorText: widget.hasError ? ' ' : null,
              counterText: '',
              filled: true,
              fillColor: AppColors.text,
              hintText: widget.placeholder,
              hintStyle: const TextStyle(
                color: Color(0xff646464),
                fontSize: 16,
                height: 1.5,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.akcent,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
