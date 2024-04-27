// ignore_for_file: camel_case_types, constant_identifier_names, library_private_types_in_public_api

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
// ignore_for_file: avoid_print, use_build_context_synchronously, file_names
import 'dart:convert';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

class UserModel {
  String id;
  String name;
  String email;

 

  UserModel(
      {required this.id,
      required this.name,
      required this.email,
});

  factory UserModel.fromDoc(DocumentSnapshot doc) {
    return UserModel(
      id: doc.id,
      name: doc['name'],
      email: doc['email'],

    );
  }
}
const Color ThemeMain = Colors.blue;

const Color ThemeMainBG = Colors.black;
class Login extends StatefulWidget {
    final Function()? onTap;

  const Login({super.key, required this.onTap});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
 final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isHiddenPass = true;

  void _togglePasswordView() {
    setState(() {
      isHiddenPass = !isHiddenPass;
    });
  }

  Icon buildKey() {
    return Icon(
      isHiddenPass ? Icons.visibility : Icons.visibility_off,
      color: ThemeMain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  'assets/images/logo.png', // Replace with your logo asset path
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 10),
                Text(
                  'Welcome back, you\'ve been missed',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child:  TextFormField(
              controller: emailController,
              cursorColor: ThemeMain,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: ThemeMain),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(color: ThemeMain),
                ),
                filled: true,
                fillColor: Colors.grey[800],
                hintText: 'Email',
                hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
              ),
             
            ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: isHiddenPass,
                      cursorColor: ThemeMain,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIcon: InkWell(onTap: _togglePasswordView, child: buildKey()),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: ThemeMain),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(color: ThemeMain),
                        ),
                        filled: true,
                        fillColor: Colors.grey[800],
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                     
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () async {
                bool isValid = await AuthService.login(emailController.text, passwordController.text);
                if (isValid) {
 Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => UserList(currentUserId: FirebaseAuth.instance.currentUser!.uid,),
        // GeminiChat(
        //   currentUserId: widget.currentUserId,
        // ),,
  ),
);
            } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login failed'),
        ),
      );                }
              },
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: ThemeMain,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: ThemeMainBG,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Forgot your login details? ',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                      TextButton(
                        onPressed: () {
                          AuthService.resetPassword(emailController.text,context);
                        },
                        child: const Text(
                          'Get help logging in.',
                          style: TextStyle(
                            color: ThemeMain,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Colors.grey[600],
                //         ),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.only(left: 8, right: 8),
                //         child: Text(
                //           'OR',
                //           style: TextStyle(color: Colors.grey[600]),
                //         ),
                //       ),
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Colors.grey[600],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 10),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     GestureDetector(
                //       onTap: () async {
                //         // // Handle Google sign-in
                //         // User? user = await authService.signInWithGoogle();

                //         // if (user != null) {
                //         //   // Successfully signed in
                //         //   print('User signed in with Google: ${user.displayName}');
                //         //   // Navigate to the next screen or perform other actions
                //         //   Navigator.pushReplacement(
                //         //     context,
                //         //     MaterialPageRoute(
                //         //       builder: (context) => const HomeScreen(),
                //         //     ),
                //         //   );
                //         // } else {
                //         //   // Sign-in failed
                //         //   print('Sign-in with Google failed.');
                //         // }
                //       },
                //       child: Container(
                //         padding: const EdgeInsets.all(10),
                //         decoration: BoxDecoration(
                //           border: Border.all(color: ThemeMain),
                //           borderRadius: BorderRadius.circular(20),
                //           color: Colors.grey[100],
                //         ),
                //         child: SvgPicture.asset(
                //           'assets/google.svg', // Replace with your Google icon asset path
                //           height: 50,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member? ',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: ThemeMain,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class RegisterP extends StatefulWidget {
final Function()? onTap;
  const RegisterP({super.key, required this.onTap}) ;
  @override
  _RegisterPState createState() => _RegisterPState();
}

class _RegisterPState extends State<RegisterP> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isHiddenPass = true;

  void _tooglePasswordView() {
    setState(() {
      isHiddenPass = !isHiddenPass;
    });
  }

  Icon buildKey() {
    if (isHiddenPass == true) {
      return const Icon(Icons.visibility, color: ThemeMain);
    } else {
      return const Icon(Icons.visibility_off, color: ThemeMain);
    }
  }  
  bool isHiddenPass2 = true;

  void _tooglePasswordView2() {
    setState(() {
      isHiddenPass2 = !isHiddenPass2;
    });
  }

  Icon buildKey2() {
    if (isHiddenPass2 == true) {
      return const Icon(Icons.visibility, color: ThemeMain);
    } else {
      return const Icon(Icons.visibility_off, color: ThemeMain);
    }
  }

  bool isValidEmail(String email) {
    // Use a regular expression to validate email format
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  'assets/images/logo.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 25),
                SizedBox(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: nameController,
                      obscureText: false,
                      cursorColor: ThemeMain,
                     
                      decoration: InputDecoration(
                        
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: ThemeMain),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(color: ThemeMain),
                        ),
                        filled: true,
                        fillColor: Colors.grey[800],
                        hintText: 'Name',
                        hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      
                    ),
                  ),
                ),                const SizedBox(height: 15),

                SizedBox(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: emailController,
                      obscureText: false,
                      cursorColor: ThemeMain,
                      validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  } else if (!isValidEmail(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                      decoration: InputDecoration(
                        
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: ThemeMain),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(color: ThemeMain),
                        ),
                        filled: true,
                        fillColor: Colors.grey[800],
                        hintText: 'Email',
                        hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                     
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      
                      controller: passwordController,
obscureText: isHiddenPass,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },                      cursorColor: ThemeMain,
                      decoration: InputDecoration(
                                          suffixIcon: InkWell(onTap: _tooglePasswordView, child: buildKey()),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: ThemeMain),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(color: ThemeMain),
                        ),
                        filled: true,
                        fillColor: Colors.grey[800],
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: confirmPasswordController,
 obscureText: isHiddenPass2, // Always hide confirm password
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm your password';
                  } else if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },                      cursorColor: ThemeMain,
                      decoration: InputDecoration(
                                                            suffixIcon: InkWell(onTap: _tooglePasswordView2, child: buildKey2()),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: ThemeMain),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(color: ThemeMain),
                        ),
                        filled: true,
                        fillColor: Colors.grey[800],
                        hintText: 'Confirm Password',
                        hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap:  () async {
                bool isValid =
                    await AuthService.signUp(nameController.text, emailController.text, passwordController.text);
                if (isValid) {
  Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => UserList(currentUserId: FirebaseAuth.instance.currentUser!.uid,),
        // GeminiChat(
        //   currentUserId: widget.currentUserId,
        // ),,
  ),
);                         } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration failed'),
        ),
      );                }
              },
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: ThemeMain,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: ThemeMainBG,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Colors.grey.shade400,
                //         ),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.only(left: 8, right: 8),
                //         child: Text(
                //           'OR',
                //           style: TextStyle(color: Colors.grey.shade600),
                //         ),
                //       ),
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Colors.grey.shade400,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     GestureDetector(
                //       onTap: () {
                //         // Handle Google sign-in (replace with actual logic)
                //       },
                //       child: Container(
                //         padding: const EdgeInsets.all(10),
                //         decoration: BoxDecoration(
                //           border: Border.all(color: ThemeMain),
                //           borderRadius: BorderRadius.circular(20),
                //           color: Colors.grey[100],
                //         ),
                //         child: SvgPicture.asset(
                //           'assets/google.svg',
                //           height: 50,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                            color: ThemeMain,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class GeminiChat extends StatefulWidget {
  final String currentUserId;

  const GeminiChat({super.key, required this.currentUserId});

  @override
  _GeminiChatState createState() => _GeminiChatState();
}

class _GeminiChatState extends State<GeminiChat> {
  ChatUser user = ChatUser(
    id: '1',
    firstName: 'Me',
  );

  ChatUser bot = ChatUser(
    id: '2',
    firstName: 'Gemini',
  );

  List<ChatMessage> messages = <ChatMessage>[];
  List<ChatUser> typing = [];

  final url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyAe0LBPLVCeR46aTvD-ipuOhl0C3pN4Lvo";
  final header = {"Content-Type": "application/json"};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: ThemeMain,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: ThemeMainBG,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
        ),
        backgroundColor: ThemeMainBG,
      ),
      body: DashChat(
        typingUsers: typing,
        currentUser: user,
        inputOptions: const InputOptions(
          cursorStyle: CursorStyle(color: ThemeMain),
          inputTextStyle: TextStyle(color: ThemeMainBG),
        ),
        onSend: (ChatMessage m) async {
          setState(() {
            messages.insert(0, m);
          });
          typing.add(bot);
          final con = {
            "contents": [
              {
                "parts": [
                  {"text": m.text}
                ]
              }
            ]
          };

          try {
            final response = await http.post(
              Uri.parse(url),
              headers: header,
              body: jsonEncode(con),
            );

            if (response.statusCode == 200) {
              var r = jsonDecode(response.body);
              ChatMessage m1 = ChatMessage(
                text: r['candidates'][0]['content']['parts'][0]['text'],
                user: bot,
                createdAt: DateTime.now(),
              );
              messages.insert(0, m1);
            } else {
              ChatMessage m1 = ChatMessage(
                text: "Sorry, I can't help you!",
                user: bot,
                createdAt: DateTime.now(),
              );
              messages.insert(0, m1);
            }
          } catch (e) {
            // Handle error
          }

          typing.remove(bot);
          setState(() {});
        },
        messages: messages,
      ),
    );
  }}

class UserList extends StatelessWidget {
  final String currentUserId;

  const UserList({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: ThemeMainBG,
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator( valueColor: AlwaysStoppedAnimation(ThemeMain),);
          }

          // Create a list to hold list items
          List<Widget> listItems = [];

          // Add "My AI" list item
          listItems.add(
            ListTile(
              leading: const CircleAvatar(
                radius: 20,
                backgroundColor: ThemeMainBG,
                backgroundImage: AssetImage('assets/images/logow.png'),
              ),
              title: const Text(
                'COMUNE AI',
                style: TextStyle(
                  color: ThemeMain,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GeminiChat(currentUserId: currentUserId),
                  ),
                );
              },
            ),
          );

          // Add user list items
          listItems.addAll(
            snapshot.data!.docs.map<Widget>((DocumentSnapshot document) {
              UserModel user = UserModel.fromDoc(document);
               if (user.id == '1' || user.id == currentUserId) {
      return Container(); // Exclude the AI and current user from the list
    }
                  
                
              return ListTile(
                leading: const CircleAvatar(
                  radius: 20,
                  
                ),
                title: Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  if (user.id != currentUserId){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoom(currentUserId: currentUserId, selectedUserId: user.id),
                    ),
                  );}
                },
              );
            }).toList(),
          );

          // Build the ListView with the prepared list items
          return ListView(
            children: listItems,
          );
        },
      ),
    );
  }
}

class ChatRoom extends StatefulWidget {
  final String currentUserId;
  final String selectedUserId;

  const ChatRoom({super.key, required this.currentUserId, required this.selectedUserId});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}class _ChatRoomState extends State<ChatRoom> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<ChatUser> typingUsers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: ThemeMain,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: ThemeMainBG,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection("users").doc(widget.selectedUserId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator( valueColor: AlwaysStoppedAnimation(ThemeMain),);
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Container(); // Return empty container if document doesn't exist
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final String userName = userData['name'] ?? '';
            return Text(userName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
          },
        ),
        centerTitle: true,
        backgroundColor: ThemeMainBG,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('chatroom')
            .doc(getChatRoomId())
            .collection('chats')
            .orderBy("time", descending: true) // Sort messages in descending order
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final List<ChatMessage> messages = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;

              return ChatMessage(
                text: data['message'],
                user: ChatUser(id: data['sendby'],),
                createdAt: (data['time'] as Timestamp).toDate(),
              );
            }).toList();

            return  DashChat(
              currentUser:ChatUser(
  id: widget.currentUserId,
),

              onSend: _onSendMessage,
              messages: messages,
              typingUsers: typingUsers,
              inputOptions: const InputOptions(
                cursorStyle: CursorStyle(color: ThemeMain),
                inputTextStyle: TextStyle(color: ThemeMainBG),
              ),
              messageListOptions: MessageListOptions(
                showDateSeparator: true, // Show date separators
                separatorFrequency: SeparatorFrequency.days, // Show date separator for each day
                dateSeparatorBuilder: (DateTime date) {
                  // Customize the appearance of the date separator
                  return Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      DateFormat('dd MMM yyyy').format(date), // Format the date
                      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            );

          } else {
            return const Center(child: CircularProgressIndicator( valueColor: AlwaysStoppedAnimation(ThemeMain),));
          }
        },
      ),
    );
  }

  Future<void> _onSendMessage(ChatMessage message) async {
    final messageData = {
      "sendby": widget.currentUserId,
      "message": message.text,
      "type": "text",
      "time": Timestamp.now(),
    };

    await _firestore.collection('chatroom').doc(getChatRoomId()).collection('chats').add(messageData);
  }

  String getChatRoomId() {
    final List<String> userIds = [widget.currentUserId, widget.selectedUserId];
    userIds.sort();
    return userIds.join("_");
  }
}

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _fireStore = FirebaseFirestore.instance;

  static Future<bool> signUp(String name, String email, String password) async {
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? signedInUser = authResult.user;

      if (signedInUser != null) {
        _fireStore.collection('users').doc(signedInUser.uid).set({
          'name': name,
          'email': email,
          'profilePicture': '',
          'coverImage': '',
          'bio': ''
        });
        return true;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
   
  static Future<void> resetPassword(String email, BuildContext context) async {
    try {
      if (email.isEmpty) {
        showSnackBar(context, 'Enter Your Email');
      } else {
        await _auth.sendPasswordResetEmail(email: email);
        showSnackBar(context, 'Password reset email sent');
      }
    } catch (e) {
      showSnackBar(context, 'Invalid email');
    }
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
 
  static void logout() {
    try {
      _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const comune());
}

class comune extends StatelessWidget {
  const comune({super.key});

  Widget getScreenId() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            print('User is logged in: ${snapshot.data!.uid}');
            return UserList(currentUserId: snapshot.data!.uid);
          } else {
            print('User is not logged in');
            return const Check();
          }
        } else {
          return const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(ThemeMain),
                );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comune',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: ThemeMainBG,
        primaryColor: ThemeMain,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: ThemeMain),
      ),
      home: AnimatedSplashScreen(
        splashIconSize: 250,
        duration: 1000,
        splash: Image.asset(
          'assets/images/logob.png', // Replace with the correct path to your image
        ),
        nextScreen: getScreenId(),
        animationDuration: const Duration(seconds: 2),
        splashTransition: SplashTransition.rotationTransition,
        pageTransitionType: PageTransitionType.rightToLeft,
        backgroundColor: ThemeMain,
      ),
    );
  }
}

class Check extends StatefulWidget {
  const Check({super.key});

  @override
  _CheckState createState() => _CheckState();
  
}

class _CheckState extends State<Check> {
    bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    return L_R(
            showLoginPage: showLoginPage,
            togglePages: togglePages,
          );
  }
}

class L_R extends StatelessWidget {
  final bool showLoginPage;
  final Function() togglePages;

  const L_R({
    super.key,
    required this.showLoginPage,
    required this.togglePages,
  });

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return Login(
        onTap: togglePages,
      );
    } else {
      return RegisterP(
        onTap: togglePages,
      );
    }
  }
}
