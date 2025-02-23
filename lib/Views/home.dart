import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keep_learning/Data/Classes/notificationService.dart';
import 'package:keep_learning/Data/Porviders/sessionProvider.dart';
import 'package:keep_learning/Data/Porviders/themeProvider.dart';
import 'package:keep_learning/Data/Storage/SessionStore.dart';
import 'package:keep_learning/Data/models/session_store_data.dart';
import 'package:keep_learning/Widgets/home/sessionWidget.dart';
import 'package:keep_learning/Widgets/home/smallCalandarWidget.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    // Load sessions when the screen is initialized
    load();
    finished();
  }

  load() async {
    final sessionsProvider = Provider.of<SessionsProvider>(
      context,
      listen: false,
    );
    sessionsProvider.loadSessions();
  }

  finished() async {
    final sessionsProvider = Provider.of<SessionsProvider>(
      context,
      listen: false,
    );
    await sessionsProvider.loadSessions();
    Status checkSessionsFinished =
        await sessionsProvider.checkSessionsFinished();

    var sessionStoreManager = SessionStore();
    //sessionStoreManager.initToday();
    List<SessionStoreData> sessions =
        await sessionStoreManager.getAllSessions();
    for (SessionStoreData sessionStore in sessions) {
      print(sessionStore.sessionId);
    }

    print("Finished ${checkSessionsFinished.toJson()}");
  }

  showPaywall() {}

  @override
  Widget build(BuildContext context) {
    final sessionsProvider = Provider.of<SessionsProvider>(context);

    final themeProvider = Provider.of<ThemeProvider>(context);
    // themeProvider.toggleTheme();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("IronHabit"),
            TweenAnimationBuilder<int>(
              duration: Duration(milliseconds: 400), // Dauer der Animation
              tween: IntTween(begin: 0, end: sessionsProvider.streak),
              builder: (context, value, child) {
                return Text("$value 🔥");
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          FilledButton(
            onPressed: () {
              print("Pressed");
              NotificationService().showNotification(
                title: "Hello!",
                body: "This is a local push notification.",
              );
            },
            child: Text("Notif"),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 5, 15, 15),
            child: SmallCalendar(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sessionsProvider.sessions.length,
              itemBuilder: (context, index) {
                final session = sessionsProvider.sessions[index];
                session.checkAndResetTimeLeft();
                return SessionWidget(
                  session: session,
                  onTap: () {
                    context.go('/timer?sessionKey=${session.sessionKey}');
                  },
                  onEdit: () {
                    print(sessionsProvider.sessions.length);
                  },
                  onDelete: () {
                    sessionsProvider.removeSession(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/addSession'),
        tooltip: 'Add Session',
        child: const Icon(Icons.add),
      ),
    );
  }
}
