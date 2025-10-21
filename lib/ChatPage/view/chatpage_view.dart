import 'package:flutter/material.dart';
import '../../Messages/model/messages_model.dart';
import '../../constants/constants.dart';

class ChatMessage {
  final String message;
  final String date;
  final bool isSentByMe;

  ChatMessage({
    required this.message,
    required this.date,
    required this.isSentByMe,
  });
}

class ChatPage extends StatelessWidget {
  final MessageModel contact;

  const ChatPage({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    // Sample chat messages for demonstration
    final List<ChatMessage> chatMessages = [
      ChatMessage(
        message: 'Hey, how’s it going?',
        date: '10:30 AM',
        isSentByMe: false,
      ),
      ChatMessage(
        message: 'Pretty good, thanks! You?',
        date: '10:32 AM',
        isSentByMe: true,
      ),
      ChatMessage(
        message: 'Just chilling. Wanna grab coffee later?',
        date: '10:35 AM',
        isSentByMe: false,
      ),
      ChatMessage(
        message: 'Sure, sounds great! 3 PM?',
        date: '10:36 AM',
        isSentByMe: true,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgThemeColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgThemeColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.textFieldIconColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: AppColors.iconColor,
            ),
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(contact.image),
                backgroundColor: Colors.grey[200],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              contact.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// Chat Messages List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: ListView.separated(
                  itemCount: chatMessages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final message = chatMessages[index];
                    return Align(
                      alignment: message.isSentByMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: message.isSentByMe
                              ? AppColors.textFieldIconColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: message.isSentByMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.message,
                              style: TextStyle(
                                fontSize: 14,
                                color: message.isSentByMe
                                    ? AppColors.iconColor
                                    : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              message.date,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            /// Message Input Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.textFieldIconColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.send,
                      size: 20,
                      color: AppColors.iconColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}