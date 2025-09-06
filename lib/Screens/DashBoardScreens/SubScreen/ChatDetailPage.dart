import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:async';

class Message {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final String status; // 'sent', 'delivered', 'read'
  final String avatarUrl;
  final List<String> attachments;
  final String? reaction; // Only one reaction per user

  Message({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
    required this.status,
    required this.avatarUrl,
    this.attachments = const [],
    this.reaction,
  });
}

class ChatDetailPage extends StatefulWidget {
  final String userName;
  const ChatDetailPage({Key? key, required this.userName}) : super(key: key);

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  List<Message> messages = [
    Message(
      id: '1',
      text: 'Hello ${'userName'}!',
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
      status: 'read',
      avatarUrl: '',
      attachments: [],
      reaction: '👍',
    ),
    Message(
      id: '2',
      text: 'Hi! How are you?',
      isMe: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 4)),
      status: 'read',
      avatarUrl: '',
      attachments: [],
      reaction: null,
    ),
    Message(
      id: '3',
      text: 'I am good, thanks!',
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 3)),
      status: 'delivered',
      avatarUrl: '',
      attachments: [],
      reaction: null,
    ),
    Message(
      id: '4',
      text: 'What about you?',
      isMe: false,
      timestamp: DateTime.now().subtract(Duration(minutes: 2)),
      status: 'delivered',
      avatarUrl: '',
      attachments: [],
      reaction: '❤️',
    ),
    Message(
      id: '5',
      text: 'Doing well!',
      isMe: true,
      timestamp: DateTime.now().subtract(Duration(minutes: 1)),
      status: 'sent',
      avatarUrl: '',
      attachments: [],
      reaction: null,
    ),
  ];
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  List<String> pendingAttachments = [];
  OverlayEntry? _reactionOverlay;
  Map<String, GlobalKey> _bubbleKeys = {};

  @override
  Widget build(BuildContext context) {
    List<Message> filteredMessages = searchQuery.isEmpty
        ? messages
        : messages.where((m) => m.text.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(63, 81, 181, 0.2), // Colors.indigo.withOpacity(0.2)
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                SizedBox(width: 8),
                Text(
                  widget.userName,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            color: Colors.white,
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(fontFamily: 'Inter'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              ),
              style: TextStyle(fontFamily: 'Inter'),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: filteredMessages.map((message) {
                return _buildMessageBubble(message);
              }).toList(),
            ),
          ),
          Divider(height: 1),
          if (pendingAttachments.isNotEmpty)
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: pendingAttachments.map((url) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: url.endsWith('.jpg') || url.endsWith('.png')
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(url, height: 40, width: 40, fit: BoxFit.cover),
                        )
                      : Row(
                          children: [
                            Icon(Icons.attach_file, size: 18, color: Colors.grey[700]),
                            SizedBox(width: 2),
                            Text(
                              url.split('/').last,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12
                              )
                            ),
                          ],
                        ),
                )).toList(),
              ),
            ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.indigo),
                  onPressed: _pickAttachment,
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: Colors.grey[100],
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(33, 150, 243, 0.2), // Colors.blueAccent.withOpacity(0.2)
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAttachment() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.any);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        pendingAttachments.addAll(result.files.map((f) => f.path ?? ''));
      });
    }
  }

  void _sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty && pendingAttachments.isEmpty) return;
    setState(() {
      messages.add(
        Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          isMe: true,
          timestamp: DateTime.now(),
          status: 'sent',
          avatarUrl: '',
          attachments: List<String>.from(pendingAttachments),
          reaction: null,
        ),
      );
      messageController.clear();
      pendingAttachments.clear();
    });
  }

  // void _showReactionAndMenuOverlay(BuildContext context, GlobalKey key, Message message) {
  //   final reactions = ['👍', '❤️', '😂', '😮', '😢', '👏'];
  //   final menuItems = [
  //     {'text': 'Reply', 'icon': Icons.reply},
  //     {'text': 'Forward', 'icon': Icons.forward},
  //     {'text': 'Copy', 'icon': Icons.copy},
  //     {'text': 'Info', 'icon': Icons.info_outline},
  //     {'text': 'Star', 'icon': Icons.star_border},
  //     {'text': 'Pin', 'icon': Icons.push_pin_outlined},
  //     {'text': 'Delete', 'icon': Icons.delete, 'color': Colors.red},
  //   ];
  //   final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
  //   final overlay = Overlay.of(context);
  //   if (renderBox == null || overlay == null) return;
  //   final position = renderBox.localToGlobal(Offset.zero);
  //
  //   _reactionOverlay?.remove();
  //   _reactionOverlay = OverlayEntry(
  //     builder: (context) => Stack(
  //       children: [
  //         Positioned.fill(
  //           child: GestureDetector(onTap: _hideReactionOverlay, behavior: HitTestBehavior.translucent, child: Container()),
  //         ),
  //         // Emoji reactions bar
  //         Positioned(
  //           left: position.dx,
  //           top: position.dy - 56,
  //           child: Material(
  //             color: Colors.transparent,
  //             child: Container(
  //               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(24),
  //                 boxShadow: [BoxShadow(color: Color.fromRGBO(0,0,0,0.08), blurRadius: 8, offset: Offset(0,2))]
  //               ),
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: reactions.map((r) => GestureDetector(
  //                   onTap: () {
  //                     setState(() {
  //                       final idx = messages.indexWhere((m) => m.id == message.id);
  //                       if (idx != -1) {
  //                         messages[idx] = Message(
  //                           id: message.id,
  //                           text: message.text,
  //                           isMe: message.isMe,
  //                           timestamp: message.timestamp,
  //                           status: message.status,
  //                           avatarUrl: message.avatarUrl,
  //                           attachments: message.attachments,
  //                           reaction: r,
  //                         );
  //                       }
  //                     });
  //                     _hideReactionOverlay();
  //                   },
  //                   child: Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 6.0),
  //                     child: Text(r, style: TextStyle(fontSize: 28)),
  //                   ),
  //                 )).toList(),
  //               ),
  //             ),
  //           ),
  //         ),
  //         // Contextual menu below bubble
  //         Positioned(
  //           left: position.dx,
  //           top: position.dy + renderBox.size.height + 8,
  //           child: Material(
  //             color: Colors.transparent,
  //             child: Container(
  //               width: 180,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(12),
  //                 boxShadow: [BoxShadow(color: Color.fromRGBO(0,0,0,0.08), blurRadius: 8, offset: Offset(0,2))]
  //               ),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: menuItems.map((item) => InkWell(
  //                   onTap: () {
  //                     _hideReactionOverlay();
  //                     // Handle each menu item here
  //                     // Example: if (item['text'] == 'Delete') {...}
  //                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item['text']} selected')));
  //                   },
  //                   child: Container(
  //                     padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  //                     child: Row(
  //                       children: [
  //                         Icon(item['icon'] as IconData, size: 20, color: item['color'] as Color? ?? Colors.black),
  //                         SizedBox(width: 12),
  //                         Text(
  //                           item['text'] as String,
  //                           style: TextStyle(
  //                             color: item['color'] as Color? ?? Colors.black,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 )).toList(),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  //   overlay.insert(_reactionOverlay!);
  // }

  // void _showReactionAndMenuOverlay(BuildContext context, GlobalKey key, Message message) {
  //   final reactions = ['👍', '❤️', '😂', '😮', '😢', '👏'];
  //   final menuItems = [
  //     {'text': 'Reply', 'icon': Icons.reply},
  //     {'text': 'Forward', 'icon': Icons.forward},
  //     {'text': 'Copy', 'icon': Icons.copy},
  //     {'text': 'Info', 'icon': Icons.info_outline},
  //     {'text': 'Star', 'icon': Icons.star_border},
  //     {'text': 'Pin', 'icon': Icons.push_pin_outlined},
  //     {'text': 'Delete', 'icon': Icons.delete, 'color': Colors.red},
  //   ];
  //
  //   final overlay = Overlay.of(context);
  //   _reactionOverlay?.remove();
  //   _reactionOverlay = OverlayEntry(
  //       builder: (context) {
  //         return GestureDetector(
  //           onTap: _hideReactionOverlay,
  //           child: Material(
  //             color: Colors.transparent,
  //             child: Stack(
  //               children: [
  //                 // Blur the background
  //                 Positioned.fill(
  //                   child: BackdropFilter(
  //                     filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
  //                     child: Container(
  //                       color: Colors.black.withOpacity(0.12),
  //                     ),
  //                   ),
  //                 ),
  //                 // Center reaction bar and menu
  //                 Center(
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       // Reaction Bar
  //                       Container(
  //                         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  //                         decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.circular(24),
  //                           boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
  //                         ),
  //                         child: Row(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: reactions.map((r) => GestureDetector(
  //                             onTap: () {
  //                               setState(() {
  //                                 final idx = messages.indexWhere((m) => m.id == message.id);
  //                                 if (idx != -1) {
  //                                   messages[idx] = Message(
  //                                     id: message.id,
  //                                     text: message.text,
  //                                     isMe: message.isMe,
  //                                     timestamp: message.timestamp,
  //                                     status: message.status,
  //                                     avatarUrl: message.avatarUrl,
  //                                     attachments: message.attachments,
  //                                     reaction: r,
  //                                   );
  //                                 }
  //                               });
  //                               _hideReactionOverlay();
  //                             },
  //                             child: Padding(
  //                               padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //                               child: Text(r, style: TextStyle(fontSize: 24)),
  //                             ),
  //                           )).toList(),
  //                         ),
  //                       ),
  //                       SizedBox(height: 22),
  //                       // Context Menu
  //                       Container(
  //                         width: 220,
  //                         decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.circular(16),
  //                           boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
  //                         ),
  //                         child: Column(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: menuItems.map((item) => InkWell(
  //                             onTap: () {
  //                               _hideReactionOverlay();
  //                               ScaffoldMessenger.of(context).showSnackBar(
  //                                   SnackBar(content: Text('${item['text']} selected'))
  //                               );
  //                             },
  //                             child: Container(
  //                               padding: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
  //                               child: Row(
  //                                 children: [
  //                                   Icon(item['icon'] as IconData, size: 22,
  //                                       color: item['color'] as Color? ?? Colors.black),
  //                                   SizedBox(width: 16),
  //                                   Text(
  //                                     item['text'] as String,
  //                                     style: TextStyle(
  //                                       color: item['color'] as Color? ?? Colors.black,
  //                                       fontWeight: FontWeight.w500,
  //                                       fontSize: 16,
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           )).toList(),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       }
  //   );
  //   overlay.insert(_reactionOverlay!);
  // }

  void _showReactionAndMenuOverlay(BuildContext context, GlobalKey key, Message message) {
    final reactions = ['👍', '❤️', '😂', '😮', '😢', '🙏', '✋', '➕'];
    final menuItems = [
      {'text': 'Reply',   'icon': Icons.reply,             'color': Colors.black},
      {'text': 'Forward', 'icon': Icons.forward,           'color': Colors.black},
      {'text': 'Copy',    'icon': Icons.copy,              'color': Colors.black},
      {'text': 'Info',    'icon': Icons.info_outline,      'color': Colors.black},
      {'text': 'Star',    'icon': Icons.star_border,       'color': Colors.black},
      {'text': 'Pin',     'icon': Icons.push_pin_outlined, 'color': Colors.black},
      {'text': 'Delete',  'icon': Icons.delete,            'color': Colors.red},
    ];

    final overlay = Overlay.of(context);
    _reactionOverlay?.remove();
    _reactionOverlay = OverlayEntry(
        builder: (context) {
          return GestureDetector(
            onTap: _hideReactionOverlay,
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        color: Colors.black.withOpacity(0.13), // Slightly increased for iOS match
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // REACTION BAR
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 14)],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: reactions.map((emoji) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  final idx = messages.indexWhere((m) => m.id == message.id);
                                  if (idx != -1) {
                                    messages[idx] = Message(
                                      id: message.id,
                                      text: message.text,
                                      isMe: message.isMe,
                                      timestamp: message.timestamp,
                                      status: message.status,
                                      avatarUrl: message.avatarUrl,
                                      attachments: message.attachments,
                                      reaction: emoji,
                                    );
                                  }
                                });
                                _hideReactionOverlay();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(emoji, style: TextStyle(fontFamily: 'Inter', fontSize: 28)),
                              ),
                            )).toList(),
                          ),
                        ),
                        SizedBox(height: 20),
                        // CONTEXT MENU
                        Container(
                          width: 240,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 14)],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (final item in menuItems)
                                InkWell(
                                  borderRadius: BorderRadius.zero,
                                  onTap: () {
                                    _hideReactionOverlay();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('${item['text']} selected'))
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                    child: Row(
                                      children: [
                                        Icon(
                                          item['icon'] as IconData,
                                          size: 22,
                                          color: item['color'] as Color,
                                        ),
                                        SizedBox(width: 22),
                                        Expanded(
                                          child: Text(
                                            item['text'] as String,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              color: item['color'] as Color,
                                              fontWeight: item['text'] == 'Delete'
                                                  ? FontWeight.w500
                                                  : FontWeight.normal,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
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
    );
    overlay.insert(_reactionOverlay!);
  }




  void _hideReactionOverlay() {
    _reactionOverlay?.remove();
    _reactionOverlay = null;
  }

  Widget _buildMessageBubble(Message message) {
    final timeString = "${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}",
     bubbleKey = _bubbleKeys[message.id] ?? GlobalKey();
    _bubbleKeys[message.id] = bubbleKey;
    return Row(
      mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onLongPress: () => _showReactionAndMenuOverlay(context, bubbleKey, message),
              onTap: _hideReactionOverlay,
              child: Container(
                key: bubbleKey,
                margin: EdgeInsets.symmetric(vertical: 6),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                constraints: BoxConstraints(maxWidth: 260),
                decoration: BoxDecoration(
                  color: message.isMe ? Colors.blueAccent : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(message.isMe ? 16 : 4),
                    bottomRight: Radius.circular(message.isMe ? 4 : 16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.04),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    if (message.attachments.isNotEmpty)
                      ...message.attachments.map((url) => Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: url.endsWith('.jpg') || url.endsWith('.png')
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(url, height: 120, width: 120, fit: BoxFit.cover),
                                  )
                                : Row(
                                    children: [
                                      Icon(Icons.attach_file, size: 18, color: Colors.grey[700]),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          url.split('/').last,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          )),
                    Text(
                      message.text,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: message.isMe ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (message.reaction != null && message.reaction!.isNotEmpty)
              Positioned(
                left: message.isMe ? null : 20,
                right: message.isMe ? 20 : null,
                top: null,
                bottom: -18,
                child: GestureDetector(
                  onTap: () => _showRemoveReactionSheet(message),
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.08),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(message.reaction!, style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _showRemoveReactionSheet(Message message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Remove Reaction', style: TextStyle(color: Colors.red)),
              onTap: () {
                setState(() {
                  final idx = messages.indexWhere((m) => m.id == message.id);
                  if (idx != -1) {
                    messages[idx] = Message(
                      id: message.id,
                      text: message.text,
                      isMe: message.isMe,
                      timestamp: message.timestamp,
                      status: message.status,
                      avatarUrl: message.avatarUrl,
                      attachments: message.attachments,
                      reaction: null,
                    );
                  }
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
