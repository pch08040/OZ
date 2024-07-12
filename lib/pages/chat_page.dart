import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:oz/provider/ozCard_provider.dart';
import 'package:oz/utils/assets.dart';
import 'package:oz/utils/consts.dart';
import 'package:oz/widgets/chat_app_bar.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String imageURL = '';
  final _openAI = OpenAI.instance.build(
    token: OPENAI_API_KEY,
    baseOption: HttpSetup(
        receiveTimeout: const Duration(
      seconds: 10,
    )),
    // 요청이 완료되면 로그를 볼 수 있게 설정
    enableLog: true,
  );

  final ChatUser _currentUser =
      ChatUser(id: '1', firstName: 'Park', lastName: 'CheolHan');

  late ChatUser _gptchatUser;    
      

  // final ChatUser _gptchatUser =
  //     ChatUser(id: '2', profileImage: 'assets/images/ozProfile_1.png');

  @override
  void initState() {
    super.initState();
    // initState에서 imageURL을 Provider를 통해 가져옵니다.
    final _ozCardProvider = Provider.of<OzcardProvider>(context, listen: false);
    imageURL = _ozCardProvider.profileURL;
    // _gptchatUser를 초기화할 때 imageURL을 사용합니다.
    _gptchatUser = ChatUser(id: '2', profileImage: imageURL);
  }

  List<ChatMessage> _messages = <ChatMessage>[];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          // resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,

          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: ChatAppBar(clearMessages: _clearMessages),
          ),

          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: DashChat(
                currentUser: _currentUser,
                messageOptions: const MessageOptions(
                  // 사용자 색상
                  currentUserContainerColor: Colors.grey,
                  // 지피티 색상
                  containerColor: Colors.black,
                  textColor: Colors.white,
                ),
                onSend: (ChatMessage m) {
                  getChatRespose(m);
                },
                inputOptions: InputOptions(
                  sendButtonBuilder: (Function() send) {
                    return IconButton(
                      icon: Icon(Icons.send),
                      color: Colors.black, // 버튼 색상 변경
                      onPressed: send,
                    );
                  },
                ),
                messages: _messages),
          ),

          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(35.0)),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black26,
          //           blurRadius: 4,
          //           offset: Offset(0, 1),
          //         ),
          //       ],
          //     ),
          //     child: TextField(
          //       controller: _controller,
          //       // onSubmitted: (value) {

          //       // },
          //       decoration: const InputDecoration(
          //         border: InputBorder.none,
          //         filled: true,
          //         fillColor: Colors.white,
          //         prefixIcon: Icon(Icons.search),
          //         enabledBorder: OutlineInputBorder(
          //           borderRadius: BorderRadius.all(Radius.circular(35.0)),
          //           borderSide: BorderSide(color: Colors.white),
          //         ),
          //         focusedBorder: OutlineInputBorder(
          //           borderRadius: BorderRadius.all(Radius.circular(35.0)),
          //           borderSide: BorderSide(color: Colors.white),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }

  void _clearMessages() {
    setState(() {
      _messages.clear();
    });
  }

  Future<void> getChatRespose(ChatMessage m) async {
    setState(() {
      // 나의 새메세지를 받을때 마다 0번째 목록에 추가
      _messages.insert(0, m);
    });

    // 현재까지의 메시지 기록을 저장하는 리스트 // open ai api를 설치해야 사용가능함 Messages등
    List<Map<String, dynamic>> _messagesHistory =
        // 메세지 리스트의 순서를 챗봇이 올바르게 이해할 수 있도록 최신부터 오래된 메시지 순으로 전달하기 위해 reversed 사용
        // 1. 대화의 맥락 유지: 대화형 모델은 대화의 흐름과 맥락을 유지하는 데 의존합니다.
        //    최신 메시지를 먼저 제공하면 모델이 가장 최근의 대화 내용을 기반으로 응답을 생성할 수 있습니다.
        // 2.	효율성: 최근 메시지가 먼저 처리되므로 모델이 최신 정보를 바탕으로 빠르게 응답을 생성할 수 있습니다.
        // 3.	사용자 경험: 대화형 응용 프로그램에서 사용자가 입력한 최신 메시지에 대한 응답이 정확하게 제공될 때 사용자 경험이 향상됩니다.
        _messages.reversed.toList().map((m) {
      if (m.user == _currentUser) {
        return Messages(role: Role.user, content: m.text).toJson();
      } else {
        return Messages(role: Role.assistant, content: m.text).toJson();
      }
    }).toList();

    final request = ChatCompleteText(
      model: GptTurboChatModel(),
      messages: _messagesHistory,
      maxToken: 200,
    );

    // 위 설정한 모델로 request를 보내고 응답을 받아옴
    final response = await _openAI.onChatCompletion(request: request);
    for (var element in response!.choices) {
      setState(() {
        // gpt의 새메세지를 받을때 마다 0번째 목록에 추가
        _messages.insert(
          0,
          ChatMessage(
              user: _gptchatUser,
              createdAt: DateTime.now(),
              text: element.message!.content),
        );
      });
    }
  }
}
