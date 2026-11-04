import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(const InternetGate());

// ===== INTERNET GATE =====
class InternetGate extends StatefulWidget {
  const InternetGate({super.key});
  @override
  State<InternetGate> createState() => _InternetGateState();
}
class _InternetGateState extends State<InternetGate> {
  bool hasInternet = true;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    _check();
    Connectivity().onConnectivityChanged.listen((_) => _check());
  }
  Future<void> _check() async {
    var r = await Connectivity().checkConnectivity();
    setState(() {
      hasInternet = r != ConnectivityResult.none;
      loading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (loading) return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
    if (!hasInternet) {
      return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.wifi_off, size: 90, color: Colors.red),
              const SizedBox(height: 20),
              const Text('Check your internet connection', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Internet on karo tab app open hogi'),
              const SizedBox(height: 20),
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0B6B3A)), onPressed: _check, child: const Text('Retry', style: TextStyle(color: Colors.white))),
            ]),
          ),
        ),
      );
    }
    return const EsaaleApp();
  }
}
// ===== LANGUAGE SERVICE - 12 LANGUAGES =====
class LangService {
  static String current = 'Urdu';
  static const List<String> all = ['Urdu','English','Indonesia','Arabic','Turkish','Malay','Bengali','French','Hindi','Pashto','Persian','German'];
  static final Map<String, Map<String,String>> dict = {
    'Urdu': {'choose':'Apni Zuban Chuno','todayRem':'Aaj ka Reminder','for':'Aaj','pending':'1 Fatiha pending','reciteNow':'Recite Now','addMarhoom':'Add Marhoom','marhoomName':'Marhoom ka Naam','rishta':'Rishta','wafat':'Wafat ka Saal','save':'Save Karo','familyTree':'Family Tree','sawabCounter':'Sawab Counter','youRecite':'You recite, app counts','notifSet':'Notification Settings','dailyTime':'Daily Reminder Time','chooseMembers':'Choose members','lang':'Language','sound':'Sound','fatiha':'Surah Fatiha','ikhlas':'Surah Ikhlas','durood':'Durood Sharif','mayAccept':'May Allah accept our good deeds (Ameen)','mayForgive':'May Allah forgive them and grant them Jannah','everyRecite':'Every recitation reaches them InshaAllah','home':'Home','tree':'Tree','settings':'Settings','esaale':'Esaale Sawab','you':'You'},
    'English': {'choose':'Choose Your Language','todayRem':"Today's Reminder",'for':'Today for','pending':'1 Fatiha pending','reciteNow':'Recite Now','addMarhoom':'Add Marhoom','marhoomName':'Marhoom ka Naam','rishta':'Rishta','wafat':'Wafat ka Saal','save':'Save Karo','familyTree':'Family Tree','sawabCounter':'Sawab Counter','youRecite':'You recite, app counts','notifSet':'Notification Settings','dailyTime':'Daily Reminder Time','chooseMembers':'Choose members','lang':'Language','sound':'Sound','fatiha':'Surah Fatiha','ikhlas':'Surah Ikhlas','durood':'Durood Sharif','mayAccept':'May Allah accept our good deeds (Ameen)','mayForgive':'May Allah forgive them and grant them Jannah','everyRecite':"Every recitation reaches them Insha'Allah",'home':'Home','tree':'Tree','settings':'Settings','esaale':'Esaale Sawab','you':'You'},
    'Indonesia': {'choose':'Pilih Bahasa Anda','todayRem':'Pengingat Hari Ini','for':'Hari ini untuk','pending':'1 Fatiha tertunda','reciteNow':'Baca Sekarang','addMarhoom':'Tambah Marhoom','marhoomName':'Nama Marhoom','rishta':'Hubungan','wafat':'Tahun Wafat','save':'Simpan','familyTree':'Pohon Keluarga','sawabCounter':'Penghitung Sawab','youRecite':'Anda membaca, aplikasi menghitung','notifSet':'Pengaturan Notifikasi','dailyTime':'Waktu Pengingat Harian','chooseMembers':'Pilih anggota','lang':'Bahasa','sound':'Suara','fatiha':'Surah Fatiha','ikhlas':'Surah Ikhlas','durood':'Durood Sharif','mayAccept':'Semoga Allah menerima amal baik kita','mayForgive':'Semoga Allah mengampuni mereka','everyRecite':'Setiap bacaan sampai kepada mereka','home':'Beranda','tree':'Pohon','settings':'Pengaturan','esaale':'Esaale Sawab','you':'Anda'},
  };
  static String tr(String k){
    var map = dict[current] ?? dict['English']!;
    return map[k] ?? dict['English']![k] ?? k;
  }
  static Future<void> load() async {
    var sp = await SharedPreferences.getInstance();
    current = sp.getString('lang') ?? 'Urdu';
  }
  static Future<void> save(String l) async {
    current = l;
    var sp = await SharedPreferences.getInstance();
    await sp.setString('lang', l);
  }
}

// ===== DATA MODELS =====
class Marhoom {
  String name, rishta, wafat, imagePath;
  Marhoom({required this.name, required this.rishta, required this.wafat, required this.imagePath});
  Map toJson() => {'name':name,'rishta':rishta,'wafat':wafat,'imagePath':imagePath};
  static Marhoom fromJson(Map m) => Marhoom(name: m['name'], rishta: m['rishta'], wafat: m['wafat'], imagePath: m['imagePath']);
}
class Storage {
  static List<Marhoom> family = [];
  static Map<String,int> counts = {'fatiha':12,'ikhlas':20,'durood':0};
  static String reminderTime = '9:00 AM';
  static List<String> selectedMembers = [];
  static bool soundOn = true;
    static Future<void> loadAll() async {
    var sp = await SharedPreferences.getInstance();
    var famStr = sp.getString('family');
    if(famStr!=null){ var list=jsonDecode(famStr) as List; family=list.map((e)=>Marhoom.fromJson(e)).toList(); }
    if(family.isEmpty){ family=[Marhoom(name:'Abu Jaan',rishta:'Walid',wafat:'2020',imagePath:''),Marhoom(name:'Ammi Jaan',rishta:'Walida',wafat:'2022',imagePath:'')]; }
    counts['fatiha']=sp.getInt('c_fatiha')??12;
    counts['ikhlas']=sp.getInt('c_ikhlas')??20;
    counts['durood']=sp.getInt('c_durood')??0;
    reminderTime=sp.getString('remTime')??'9:00 AM';
    selectedMembers=sp.getStringList('selMembers')??['Abu Jaan','Ammi Jaan','You'];
    soundOn=sp.getBool('sound')??true;
  }
  static Future<void> saveFamily() async { var sp=await SharedPreferences.getInstance(); await sp.setString('family', jsonEncode(family.map((e)=>e.toJson()).toList())); await sp.setStringList('selMembers', selectedMembers); }
  static Future<void> saveCounts() async { var sp=await SharedPreferences.getInstance(); await sp.setInt('c_fatiha', counts['fatiha']!); await sp.setInt('c_ikhlas', counts['ikhlas']!); await sp.setInt('c_durood', counts['durood']!); }
  static Future<void> saveSettings() async { var sp=await SharedPreferences.getInstance(); await sp.setString('remTime', reminderTime); await sp.setBool('sound', soundOn); await sp.setStringList('selMembers', selectedMembers); }
}

// ===== MAIN APP =====
class EsaaleApp extends StatefulWidget {
  const EsaaleApp({super.key});
  @override
  State<EsaaleApp> createState() => _EsaaleAppState();
}
class _EsaaleAppState extends State<EsaaleApp> {
  bool ready=false;
  @override
  void initState(){ super.initState(); _init(); }
  Future<void> _init() async { await LangService.load(); await Storage.loadAll(); setState(()=>ready=true); }
  @override
  Widget build(BuildContext context){
    if(!ready) return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));
    return MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData(primaryColor: Color(0xFF0B6B3A), scaffoldBackgroundColor: Color(0xFFF6FFFA)), home: const SplashPage());
  }
}

class AdBanner extends StatelessWidget {
  const AdBanner({super.key});
  @override
  Widget build(BuildContext context){
    return Container(height: 50, width: double.infinity, color: Color(0xFFE0E0E0), child: Center(child: Text('320x50 Ad Banner', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold))));
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0B6B3A), Color(0xFF0E8A4A)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Stack(
          children: [
            Positioned(top: 50, left: 20, child: Icon(Icons.light, size: 40, color: Colors.white24)),
            Positioned(top: 50, right: 20, child: Icon(Icons.light, size: 40, color: Colors.white24)),
            Positioned(bottom: 100, left: 0, right: 0, child: Icon(Icons.mosque, size: 120, color: Colors.white12)),
            Column(children: [
              SizedBox(height: 70),
              Stack(alignment: Alignment.center, children: [
                Container(width: 200, height: 200, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 6))),
                Icon(Icons.park, size: 140, color: Colors.white),
              ]),
              SizedBox(height: 20),
              Text('Esaale Sawab\nFamily Tree', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold, height: 1.1)),
              SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [Container(width: 30, height: 2, color: Colors.white54), Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Icon(Icons.mosque, color: Colors.white70, size: 20)), Container(width: 30, height: 2, color: Colors.white54)]),
              SizedBox(height: 10),
              Text('- Remember Them With Dua -', style: TextStyle(color: Colors.white70, fontSize: 16, fontStyle: FontStyle.italic)),
              Spacer(),
              Padding(padding: EdgeInsets.all(20), child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Color(0xFF0B6B3A), minimumSize: Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const LanguagePage())), child: Text('Start / Shuru Karein', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
              SizedBox(height: 30),
            ])
          ],
        ),
      ),
    );
  }
}

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});
  @override
  State<LanguagePage> createState() => _LanguagePageState();
}
class _LanguagePageState extends State<LanguagePage> {
  @override
  Widget
        AdBanner(),
        Padding(padding: EdgeInsets.all(16), child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0B6B3A), minimumSize: Size(double.infinity, 50)), onPressed: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const MainNav())), child: Text('Continue', style: TextStyle(color: Colors.white, fontSize: 18)))),
      ]),
    );
  }
}

class MainNav extends StatefulWidget {
  const MainNav({super.key});
  @override
  State<MainNav> createState() => _MainNavState();
}
class _MainNavState extends State<MainNav> {
  int idx=0;
  final pages=[HomePage(), FamilyTreePage(), SettingsPage()];
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: pages[idx],
      bottomNavigationBar: BottomNavigationBar(currentIndex: idx, selectedItemColor: Color(0xFF0B6B3A), unselectedItemColor: Colors.grey, onTap: (i)=>setState(()=>idx=i), type: BottomNavigationBarType.fixed, items: [BottomNavigationBarItem(icon: Icon(Icons.home), label: LangService.tr('home')), BottomNavigationBarItem(icon: Icon(Icons.park), label: LangService.tr('tree')), BottomNavigationBarItem(icon: Icon(Icons.settings), label: LangService.tr('settings'))]),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Row(children: [Text(LangService.tr('esaale')), SizedBox(width: 8), Icon(Icons.mosque, size: 20)]), backgroundColor: Color(0xFF0B6B3A), foregroundColor: Colors.white),
      body: ListView(padding: EdgeInsets.all(16), children: [
        Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(16), border: Border.all(color: Color(0xFF0B6B3A))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Icon(Icons.notifications_active, color: Color(0xFF0B6B3A)), SizedBox(width: 8), Text(LangService.tr('todayRem'), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
          SizedBox(height: 8),
          Text('${LangService.tr('for')} ${Storage.family.isNotEmpty?Storage.family[0].name:'Abu Jaan'} - ${LangService.tr('pending')}'),
          SizedBox(height: 12),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0B6B3A)), onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>SawabCounterPage())), child: Row(mainAxisSize: MainAxisSize.min, children: [Text(LangService.tr('reciteNow'), style: TextStyle(color: Colors.white)), Icon(Icons.arrow_forward, color: Colors.white)])),
        ])),
        SizedBox(height: 20),
        Center(child: Icon(Icons.park, size: 160, color: Color(0xFF0B6B3A))),
        SizedBox(height: 10),
        Center(child: Text(LangService.tr('mayAccept'), textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF0B6B3A)))),
        SizedBox(height: 20),
        ElevatedButton.icon(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>AddMarhoomPage())), icon: Icon(Icons.add), label: Text(LangService.tr('addMarhoom')), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0B6B3A), foregroundColor: Colors.white, minimumSize: Size(double.infinity, 52))),
        SizedBox(height: 10),
        AdBanner(),
      ]),
    );
  }
}

class AddMarhoomPage extends StatefulWidget {
  @override
  State<AddMarhoomPage> createState() => _AddMarhoomPageState();
}
class _AddMarhoomPageState extends State<AddMarhoomPage> {
  String name='', rishta='Abu Jaan', wafat=''; String imgPath=''; final picker=ImagePicker();
  final rishtaList=['Abu Jaan','Ammi Jaan','Bhai Jaan','Behen','Beta','Beti','Wife','Chacha','Chachi','Dada','Dadi'];
  Future<void> pickImage() async {
    var x=await picker.pickImage(source: ImageSource.gallery);
    if(x!=null){
      var dir=await getApplicationDocumentsDirectory();
      var newPath='${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await File(x.path).copy(newPath);
      setState(()=>imgPath=newPath);
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(LangService.tr('addMarhoom')), backgroundColor: Color(0xFF0B6B3A), foregroundColor: Colors.white),
      body: ListView(padding: EdgeInsets.all(16), children: [
        Center(child: Stack(children: [
          CircleAvatar(radius: 60, backgroundImage: imgPath.isNotEmpty?FileImage(File(imgPath)):null, child: imgPath.isEmpty?Icon(Icons.person, size: 60):null),
          Positioned(bottom: 0, right: 0, child: InkWell(onTap: pickImage, child: CircleAvatar(backgroundColor: Color(0xFF0B6B3A), radius: 18, child: Icon(Icons.add, color: Colors.white)))),
        ])),
        SizedBox(height: 20),
        TextField(decoration: InputDecoration(labelText: LangService.tr('marhoomName'), prefixIcon: Icon(Icons.person), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), onChanged: (v)=>name=v),
        SizedBox(height: 12),
        DropdownButtonFormField(value: rishta, items: rishtaList.map((e)=>DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v)=>setState(()=>rishta=v!), decoration: InputDecoration(labelText: LangService.tr('rishta'), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), prefixIcon: Icon(Icons.people))),
        SizedBox(height: 12),
        TextField(decoration: InputDecoration(labelText: LangService.tr('wafat'), prefixIcon: Icon(Icons.calendar_today), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), onChanged: (v)=>wafat=v, keyboardType: TextInputType.number),
        SizedBox(height: 20),
        ElevatedButton(onPressed: () async { if(name.isNotEmpty){ Storage.family.add(Marhoom(name: name, rishta: rishta, wafat: wafat, imagePath: imgPath)); if(!Storage.selectedMembers.contains(name)) Storage.selectedMembers.add(name); await Storage.saveFamily(); Navigator.pop(context); } }, style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0B6B3A), minimumSize: Size(double.infinity, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(LangService.tr('save'), style: TextStyle(color: Colors.white, fontSize: 18))),
        SizedBox(height: 20),
        AdBanner(),
      ]),
    );
  }
}

class FamilyTreePage extends StatefulWidget {
  @override
  State<FamilyTreePage> createState() => _FamilyTreePageState();
}
class _FamilyTreePageState extends State<FamilyTreePage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(LangService.tr('familyTree')), backgroundColor: Color(0xFF0B6B3A), foregroundColor: Colors.white),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(child: Column(children: [
          SizedBox(height: 20),
          Wrap(spacing: 16, runSpacing: 16, alignment: WrapAlignment.center, children: Storage.family.map((p)=>Column(children: [
            CircleAvatar(radius: 35, backgroundImage: p.imagePath.isNotEmpty?FileImage(File(p.imagePath)):null, child: p.imagePath.isEmpty?Icon(Icons.person):null),
            SizedBox(height: 6),
            Text(p.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ])).toList()),
          SizedBox(height: 20),
          CustomPaint(size: Size(200, 80), painter: TreePainter()),
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
  @override
  void paint(Canvas canvas, Size size){
    var paint=Paint()..color=Color(0xFF0B6B3A)..strokeWidth=3..style=PaintingStyle.stroke;
    canvas.drawLine(Offset(size.width/2, 0), Offset(size.width/2, 40), paint);
    canvas.drawLine(Offset(size.width*0.2, 0), Offset(size.width/2, 40), paint);
    canvas.drawLine(Offset(size.width*0.8, 0), Offset(size.width/2, 40), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}

class SawabCounterPage extends StatefulWidget {
  @override
  State<SawabCounterPage> createState() => _SawabCounterPageState();
}
class _SawabCounterPageState extends State<SawabCounterPage> {
  @override
  Widget build(BuildContext context){
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

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}
class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context){
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
