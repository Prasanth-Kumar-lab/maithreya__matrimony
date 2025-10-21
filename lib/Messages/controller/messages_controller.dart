import '../model/messages_model.dart';
class MessagesController {
  List<MessageModel> getMessages() {
    return [
      MessageModel(
        name: 'Alice Smith',
        message: 'Hey, how are you?',
        date: 'Oct 15',
        image: 'https://via.placeholder.com/150',
      ),
      MessageModel(
        name: 'Bob Johnson',
        message: 'Meeting at 3 PM',
        date: 'Oct 14',
        image: 'https://via.placeholder.com/150',
      ),
      MessageModel(
        name: 'Charlie Brown',
        message: 'Check this out!',
        date: 'Oct 13',
        image: 'https://via.placeholder.com/150',
      ),
    ];
  }
}
