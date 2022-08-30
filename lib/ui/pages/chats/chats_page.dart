import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:proweb_send/domain/bloc/chats/chats_bloc.dart';
import 'package:proweb_send/ui/pages/chats/singl_chat_page.dart';
import 'package:proweb_send/ui/theme/app_colors.dart';
import 'package:proweb_send/ui/widgets/bg_container.dart';
import 'package:skeleton_text/skeleton_text.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            'Чаты',
            style: TextStyle(
              fontSize: 22,
              height: 28 / 22,
              color: AppColors.text,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                size: 24,
                color: AppColors.text,
              ),
            ),
          ],
        ),
        Expanded(
          child: BlocBuilder<ChatsBloc, ChatsState>(
            builder: (context, state) {
              if (state is! ChatsLoaded) {
                return const ChatsSceletonLoader();
              }

              final chats = state.chats;
              if (chats.isEmpty) {
                return const Text(
                  'У вас нет чатов',
                  style: TextStyle(color: AppColors.text),
                );
              }

              return ListView.separated(
                separatorBuilder: (_, __) => const SizedBox(height: 15),
                padding: const EdgeInsets.all(16),
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  return ChatTile(
                    data: chats[index],
                    chatId: state.chatsData[index].id,
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}

class ChatTile extends StatelessWidget {
  final ChatTileData data;
  final String chatId;

  const ChatTile({
    Key? key,
    required this.data,
    required this.chatId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imgPath = data.user?.imagePath;
    final _mes = data.message;

    final date = DateTime.fromMillisecondsSinceEpoch(_mes?.time ?? 0);
    final time = DateFormat('HH:mm').format(date);
    return BgContainer(
      action: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) {
              return SinglChatPage(
                chatId: chatId,
                imgPath: imgPath,
                contactName: data.user?.name,
              );
            },
          ),
        );
      },
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Hero(
          tag: chatId,
          child: CircleAvatar(
            backgroundColor: AppColors.akcentLight,
            radius: 28,
            backgroundImage: imgPath != null
                ? CachedNetworkImageProvider(
                    imgPath,
                  )
                : null,
          ),
        ),
        title: Text(
          '${data.user?.name}',
          style: const TextStyle(
            color: AppColors.text,
          ),
        ),
        subtitle: Text(
          '${_mes?.content}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textInfoSecondary,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: const TextStyle(
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 12),
            const Icon(
              Icons.done_all,
              size: 16,
              color: AppColors.akcentSecondaryLight,
            ),
          ],
        ),
      ),
    );
  }
}

class ChatsSceletonLoader extends StatelessWidget {
  const ChatsSceletonLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, __) => const SizedBox(height: 15),
      padding: const EdgeInsets.all(16),
      itemCount: 7,
      itemBuilder: (context, index) {
        return BgContainer(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: _anim(
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.akcent,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            title: _anim(
              child: Container(
                width: 100,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.akcent,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            subtitle: _anim(
              child: Container(
                width: double.infinity,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.akcent,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _anim(
                  child: Container(
                    width: 25,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.akcent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _anim(
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: AppColors.akcent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  SkeletonAnimation _anim({required Widget child}) {
    const _color = AppColors.message;
    const _duration = 1900;
    return SkeletonAnimation(
      gradientColor: Colors.white,
      curve: Curves.easeIn,
      shimmerColor: _color,
      borderRadius: BorderRadius.circular(20),
      shimmerDuration: _duration,
      child: child,
    );
  }
}







/* 
  // Future<ChatTileData?> _getUser() async {
  //   final chat = await FirebaseFirestore.instance
  //       .collection(FirebaseCollections.chatPath)
  //       .doc(chatId)
  //       .get();
  //   final users = chat.get('users') as List? ?? [];
  //   final curetUserId = FirebaseAuth.instance.currentUser?.uid;
  //   if (curetUserId == null) return null;

  //   final userId = users.firstWhere((el) => el != curetUserId);
  //   final otherUser = ProUser.fromJson(
  //     (await FirebaseFirestore.instance
  //             .collection(FirebaseCollections.usersPath)
  //             .doc(userId)
  //             .get())
  //         .data(),
  //   );

  //   final chatDoc = await FirebaseFirestore.instance
  //       .collection(FirebaseCollections.chatPath)
  //       .doc(chatId)
  //       .get();

  //   final lastMessage = ChatModel.fromJson(chatDoc.data() ?? {}).messages?.last;

  //   return ChatTileData(
  //     user: otherUser,
  //     message: lastMessage,
  //   );
  // } */