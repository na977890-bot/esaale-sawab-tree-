import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

// ========== STORAGE ==========
class FamilyMember {
  String name; String relation;
  FamilyMember(this.name, this.relation);
  Map toJson() => {'name': name, 'relation': relation};
  static FamilyMember fromJson(Map j) => FamilyMember(j['name'], j['relation']);
}

class Storage {
  static List<FamilyMember> family = [FamilyMember('Abu Jaan', 'Father'), FamilyMember('Ami Jaan', 'Mother')];
  static Map<String, int> counts = {'fatiha': 0, 'ikhlas': 0, 'durood': 0};
  static String reminderTime = "After Maghrib";
  static bool soundOn = true;
  static List<String> selectedMembers = ['Abu Jaan', 'Ami Jaan'];
  static Future<void> saveCounts() async {
    var p = await SharedPreferences.getInstance();
    p.setInt('fatiha', counts['fatiha']!);
    p.setInt('ikhlas', counts['ikhlas']!);
    p.setInt('durood', counts['durood']!);
  }
  static Future<void> loadCounts() async {
    var p = await SharedPreferences.getInstance();
    counts['fatiha'] = p.getInt('fatiha') ?? 0;
    counts['ikhlas'] = p.getInt('ikhlas') ?? 0;
    counts['durood'] = p.getInt('durood') ?? 0;
  }
  static Future<void> saveSettings() async {
    var p = await SharedPreferences.getInstance();
    p.setString('reminderTime', reminderTime);
    p.setBool('soundOn', soundOn);
    p.setStringList('selectedMembers', selectedMembers);
  }
}

// ========== LANGUAGE SERVICE ==========
class LangService {
  static String current = "Urdu";
  static Map<String, Map<String,String>> _t = {
    'Urdu': {'you':'Aap','mayForgive':'Allah aapki maghfirat farmaye aur esaal-e-sawab qubool farmaye','sawabCounter':'Sawab Counter','youRecite':'Aap ne aaj parha','fatiha':'Surah Fatiha','ikhlas':'Surah Ikhlas','durood':'Durood Sharif','everyRecite':'Har zikr ka sawab marhoomeen ko pohunchta hai','settings':'Settings','notifSet':'Notification Setting','dailyTime':'Daily Time','chooseMembers':'Family Members','lang':'Zaban / Language','sound':'Sound','appTitle':'Esaal-e-Sawab'},
    'English': {'you':'You','mayForgive':'May Allah forgive and accept your Esaale Sawab','sawabCounter':'Sawab Counter','youRecite':'You recited today','fatiha':'Surah Fatiha','ikhlas':'Surah Ikhlas','durood':'Durood Sharif','everyRecite':'Every recitation reward goes to deceased','settings':'Settings','notifSet':'Notification Setting','dailyTime':'Daily Time','chooseMembers':'Family Members','lang':'Language','sound':'Sound','appTitle':'Esaal-e-Sawab'},
  };
  static String tr(String key) => _t[current]?[key] ?? key;
}

// ========== MAIN ==========
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Storage.loadCounts();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Esaal-e-Sawab', debugShowCheckedModeBanner: false, theme: ThemeData(primaryColor: Color(0xFF0B6B3A)), home: HomePage());
  }
}

class HomePage extends StatefulWidget { @override State<HomePage> createState() => _HomePageState(); }

class _HomePageState extends State<HomePage> {
  int _index = 0;
  final _pages = [FamilyTreePage(), SawabCounterPage(), SettingsPage()];
  @override Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(currentIndex: _index, selectedItemColor: Color(0xFF0B6B3A), onTap: (i)=>setState(()=>_index=i), items: [BottomNavigationBarItem(icon: Icon(Icons.family_restroom), label: 'Shajra'), BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Sawab'), BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')]),
    );
  }
}

class FamilyTreePage extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LangService.tr('appTitle')), backgroundColor: Color(0xFF0B6B3A), foregroundColor: Colors.white),
      body: Column(children: [
        Expanded(child: CustomPaint(painter: TreePainter(), child: ListView(padding: EdgeInsets.all(20), children: [
          SizedBox(height: 60),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: Storage.family.map((m)=>Column(children: [CircleAvatar(radius: 30, backgroundColor: Color(0xFF0B6B3A), child: Text(m.name[0], style: TextStyle(color: Colors.white))), SizedBox(height: 4), Text(m.name, style: TextStyle(fontSize: 12))])).toList()),
          SizedBox(height: 40),
          Center(child: CustomPaint(size: Size(200, 40), painter: TreePainter())),
          SizedBox(height: 20),
          Column(children: [CircleAvatar(radius: 30, child: Icon(Icons.person)), SizedBox(height: 4), Text(LangService.tr('you'), style: TextStyle(fontWeight: FontWeight.bold))]),
          SizedBox(height: 20),
          Padding(padding: EdgeInsets.all(16), child: Text(LangService.tr('mayForgive'), textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF0B6B3A), fontStyle: FontStyle.italic))),
        ]))),
        AdBanner(),
      ]),
    );
  }
}

class TreePainter extends CustomPainter {
  @override void paint(Canvas canvas, Size size){
    var paint=Paint()..color=Color(0xFF0B6B3A)..strokeWidth=3..style=PaintingStyle.stroke;
    canvas.drawLine(Offset(size.width/2, 0), Offset(size.width/2, 40), paint);
    canvas.drawLine(Offset(size.width*0.2, 0), Offset(size.width/2, 40), paint);
    canvas.drawLine(Offset(size.width*0.8, 0), Offset(size.width/2, 40), paint);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}

class SawabCounterPage extends StatefulWidget { @override State<SawabCounterPage> createState() => _SawabCounterPageState(); }

class _SawabCounterPageState extends State<SawabCounterPage> {
  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(LangService.tr('sawabCounter')), backgroundColor: Color(0xFF0B6B3A), foregroundColor: Colors.white),
      body: ListView(padding: EdgeInsets.all(16), children: [
        Text(LangService.tr('youRecite'), style: TextStyle(color: Color(0xFF0B6B3A), fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 12),
        _card(LangService.tr('fatiha'), Icons.menu_book, Storage.counts['fatiha']!, 'fatiha'),
        _card(LangService.tr('ikhlas'), Icons.mosque, Storage.counts['ikhlas']!, 'ikhlas'),
        _card(LangService.tr('durood'), Icons.circle, Storage.counts['durood']!, 'durood'),
        SizedBox(height: 20),
        Text(LangService.tr('everyRecite'), textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF0B6B3A))),
        SizedBox(height: 10),
        AdBanner(),
      ]),
    );
  }
  Widget _card(String title, IconData icon, int count, String key){
    return Card(margin: EdgeInsets.only(bottom: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), child: ListTile(leading: Icon(icon, color: Color(0xFF0B6B3A), size: 34), title: Text(title), subtitle: Text('$count', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), trailing: ElevatedButton(onPressed: () async { setState(()=>Storage.counts[key]=count+1); await Storage.saveCounts(); }, style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0B6B3A)), child: Text('+1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))));
  }
}

class SettingsPage extends StatefulWidget { @override State<SettingsPage> createState() => _SettingsPageState(); }

class _SettingsPageState extends State<SettingsPage> {
  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(LangService.tr('settings')), backgroundColor: Color(0xFF0B6B3A), foregroundColor: Colors.white),
      body: ListView(padding: EdgeInsets.all(16), children: [
        Card(child: ListTile(leading: Icon(Icons.notifications, color: Color(0xFF0B6B3A)), title: Text(LangService.tr('notifSet'), style: TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('${LangService.tr('dailyTime')}: ${Storage.reminderTime}'), trailing: Icon(Icons.arrow_forward_ios, size: 16), onTap: ()=>_pickTime())),
        Card(child: ListTile(leading: Icon(Icons.people, color: Color(0xFF0B6B3A)), title: Text(LangService.tr('chooseMembers')), subtitle: Text(Storage.selectedMembers.join(', ')), onTap: ()=>_pickMembers())),
        Card(child: ListTile(leading: Icon(Icons.language, color: Color(0xFF0B6B3A)), title: Text(LangService.tr('lang')), subtitle: Text(LangService.current), trailing: Icon(Icons.arrow_forward_ios, size: 16), onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const LanguagePage())))),
        Card(child: SwitchListTile(title: Text(LangService.tr('sound')), secondary: Icon(Icons.volume_up, color: Color(0xFF0B6B3A)), value: Storage.soundOn, activeColor: Color(0xFF0B6B3A), onChanged: (v) async { setState(()=>Storage.soundOn=v); await Storage.saveSettings(); })),
        SizedBox(height: 20),
        AdBanner(),
        SizedBox(height: 10),
        Center(child: Text('Esaale Sawab v1.0\nMade for Sadaqah-e-Jariya', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))),
      ]),
    );
  }
  Future<void> _pickTime() async {
    var t=await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if(t!=null){ setState(()=>Storage.reminderTime=t.format(context)); await Storage.saveSettings(); }
  }
  Future<void> _pickMembers() async {
    List<String> temp=List.from(Storage.selectedMembers);
    await showDialog(context: context, builder: (ctx)=>AlertDialog(title: Text(LangService.tr('chooseMembers')), content: SingleChildScrollView(child: Column(children: Storage.family.map((m)=>CheckboxListTile(title: Text(m.name), value: temp.contains(m.name), onChanged: (v){ setState((){ if(v!) temp.add(m.name); else temp.remove(m.name); }); Navigator.pop(ctx); _pickMembers(); })).toList())), actions: [TextButton(onPressed: () async { Storage.selectedMembers=temp; await Storage.saveSettings(); Navigator.pop(context); setState((){}); }, child: Text('OK'))]));
  }
}

class LanguagePage extends StatefulWidget { const LanguagePage({super.key}); @override State<LanguagePage> createState() => _LanguagePageState(); }
class _LanguagePageState extends State<LanguagePage>{
  @override Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("Language"), backgroundColor: Color(0xFF0B6B3A), foregroundColor: Colors.white), body: ListView(children: ["Urdu","English"].map((l)=>RadioListTile(title: Text(l), value: l, groupValue: LangService.current, activeColor: Color(0xFF0B6B3A), onChanged: (v)=>setState(()=>LangService.current=v!))).toList()));
  }
}

class AdBanner extends StatelessWidget { @override Widget build(BuildContext context){ return Container(height: 60, margin: EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)), child: Center(child: Text("Ad Banner - Sadaqah", style: TextStyle(color: Colors.grey)))); } }
