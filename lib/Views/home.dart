import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keep_learning/Data/Porviders/sessionProvider.dart';
import 'package:keep_learning/Data/Porviders/themeProvider.dart';
import 'package:keep_learning/Data/Storage/SessionStore.dart';
import 'package:keep_learning/Data/models/session_store_data.dart';
import 'package:keep_learning/Widgets/home/calenderWidget.dart';
import 'package:keep_learning/Widgets/home/sessionWidget.dart';
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
    finished();
  }

  finished() async {
    final sessionsProvider = Provider.of<SessionsProvider>(
      context,
      listen: false,
    );
    sessionsProvider.loadSessions();
    Status checkSessionsFinished =
        await sessionsProvider.checkSessionsFinished();

    var sessionStoreManager = SessionStore();
    List<SessionStoreData> sessions =
        await sessionStoreManager.getAllSessions();
    print(getCurrentDate());
    for (SessionStoreData sessionStore in sessions) {
      print(sessionStore.sessionId);
    }
    print("Finished ${checkSessionsFinished.toJson()}");
  }

  @override
  Widget build(BuildContext context) {
    final sessionsProvider = Provider.of<SessionsProvider>(context);

    // themeProvider.toggleTheme();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("Keep Learning"), Text("🔥 4")],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                sessionsProvider.sessions.isEmpty
                    ? Center(
                      child: CircularProgressIndicator(),
                    ) // Show loading spinner if no sessions are loaded yet
                    : ListView.builder(
                      itemCount: sessionsProvider.sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessionsProvider.sessions[index];
                        session.checkAndResetTimeLeft();
                        return SessionWidget(
                          session: session,
                          onTap: () {
                            context.go(
                              '/timer?sessionKey=${session.sessionKey}',
                            );
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
