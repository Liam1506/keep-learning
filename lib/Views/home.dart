import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keep_learning/Data/Porviders/sessionProvider.dart';
import 'package:keep_learning/Data/Porviders/themeProvider.dart';
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
    final sessionsProvider = Provider.of<SessionsProvider>(
      context,
      listen: false,
    );
    sessionsProvider.loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final sessionsProvider = Provider.of<SessionsProvider>(context);
    // themeProvider.toggleTheme();
    return Scaffold(
      body: Column(
        children: [
          /*SizedBox(height: 60),
          // Your widget placed above the ListView
          CalendarWidget(),*/

          // ListView.builder placed below the above widget
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
                        return SessionWidget(
                          session: session,
                          onTap: () {},
                          onEdit: () {},
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
