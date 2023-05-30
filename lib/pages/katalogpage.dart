import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KatalogPage extends StatefulWidget {
  @override
  _KatalogPageState createState() => _KatalogPageState();
}

class _KatalogPageState extends State<KatalogPage> {
  List<dynamic> agents = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Fetch agents data without uuid
    final agentsUrl = Uri.parse('https://valorant-api.com/v1/agents');
    final agentsResponse = await http.get(agentsUrl);

    if (agentsResponse.statusCode == 200) {
      setState(() {
        agents = jsonDecode(agentsResponse.body)['data'];
      });
    } else {
      print('Failed to fetch agents data.');
    }

    // Fetch agent data with uuid
    final uuid = 'your_uuid_here';
    final agentUrl = Uri.parse('https://valorant-api.com/v1/agents/$uuid');
    final agentResponse = await http.get(agentUrl);

    if (agentResponse.statusCode == 200) {
      final agentData = jsonDecode(agentResponse.body)['data'];
      // Do something with the agent data
      print(agentData);
    } else {
      print('Failed to fetch agent data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GridView.builder(
          padding: EdgeInsets.all(5),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: agents.length,
          itemBuilder: (BuildContext context, int index) {
            final cartoon = agents[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
                      agents: cartoon,
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(cartoon['displayIcon']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        cartoon['displayName'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final dynamic agents;

  DetailPage({required this.agents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Valorant Agents'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(40),
          child: ListView(
            children: [
              Image.network(
                agents['displayIcon'],
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  agents['displayName'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Title: ${agents['title']}'),
              ),
              ListTile(
                leading: Icon(Icons.description),
                title: Text('Description: ${agents['description']}'),
              ),
              ListTile(
                leading: Icon(Icons.developer_mode),
                title: Text('Developer Name: ${agents['developerName']}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valorant App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    KatalogPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Valorant App'),
        actions: [
          IconButton(
            onPressed: () {
              // Handle logout here
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
