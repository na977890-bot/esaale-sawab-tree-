import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() => runApp(EsaaleSawabApp());

class EsaaleSawabApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}

const green = Color(0xFF0B6E4F);
const lightGreen = Color(0xFFE8F5E9);

Future<bool> checkInternet() async {
  try {
    final result = await InternetAddress.lookup('google.com').timeout(Duration(seconds: 5));
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (_) {
    return false;
  }
}

Widget noInternetWidget(VoidCallback onRetry) => Container(color: Colors.white, child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
  Icon(Icons.wifi_off, size: 80, color: Colors.red),
  SizedBox(height: 15),
  Text('No Internet Connection', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red)),
  SizedBox(height: 8),
  Text('Please check your internet connection', style: TextStyle(color: Colors.black54)),
  Text('Net ke bagair app nahi chalegi', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
  SizedBox(height: 20),
  ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: green), onPressed: onRetry, child: Text('Retry - Dobara Check Karo', style: TextStyle(color: Colors.white)))
])));

String selectedLang = 'Urdu - اردو';
Map<String, Map<String,String>> tr = {
  'Urdu - اردو': {'add':'Marhoom ka Naam - Bada Box','rishta':'Rishta - Walid Walida Bhai Behen Beta Beti','year':'Wafat ka Saal','save':'Save Karo','home':"Today's Reminder",'recite':'Recite Now  >','gallery':'Gallery se pic upload hogi (tap karo)'},
  'English': {'add':'Deceased Name - Big Box','rishta':'Relation - Father Mother Brother Sister','year':'Year of Death','save':'Save','home':"Today's Reminder",'recite':'Recite Now  >','gallery':'Upload pic from gallery (tap)'},
  'العربية - Arabic': {'add':'اسم المتوفى','rishta':'القرابة','year':'سنة الوفاة','save':'حفظ','home':'تذكير اليوم','recite':'اقرأ الآن','gallery':'تحميل الصورة'},
  'Türkçe - Turkish': {'add':'Merhumun Adı','rishta':'Akrabalık','year':'Vefat Yılı','save':'Kaydet','home':'Bugünkü Hatırlatma','recite':'Şimdi Oku','gallery':'Galeriden yükle'},
  'Indonesia - Indonesian': {'add':'Nama Almarhum','rishta':'Hubungan','year':'Tahun Wafat','save':'Simpan','home':'Pengingat Hari Ini','recite':'Baca Sekarang','gallery':'Upload dari galeri'},
  'Melayu - Malay': {'add':'Nama Arwah','rishta':'Hubungan','year':'Tahun Meninggal','save':'Simpan','home':'Peringatan Hari Ini','recite':'Baca Sekarang','gallery':'Muat naik dari galeri'},
  'বাংলা - Bengali': {'add':'মৃতের নাম','rishta':'সম্পর্ক','year':'মৃত্যুর সাল','save':'সংরক্ষণ','home':'আজকের রিমাইন্ডার','recite':'এখন পড়ুন','gallery':'গ্যালারি থেকে আপলোড'},
  'Français - French': {'add':'Nom du défunt','rishta':'Relation','year':'Année de décès','save':'Sauvegarder','home':"Rappel d'aujourd'hui",'recite':'Réciter Maintenant','gallery':'Télécharger depuis la galerie'},
  'فارسی - Persian': {'add':'نام متوفی','rishta':'نسبت','year':'سال وفات','save':'ذخیره','home':'یادآوری امروز','recite':'اکنون تلاوت کنید','gallery':'آپلود از گالری'},
  'हिंदी - Hindi': {'add':'मरहूम का नाम','rishta':'रिश्ता','year':'वफात का साल','save':'सेव करें','home':'आज की याद','recite':'अभी पढ़ें','gallery':'गैलरी से अपलोड करें'},
};

Widget adBanner() => Container(height: 50, margin: EdgeInsets.all(8), decoration: BoxDecoration(color: lightGreen, border: Border.all(color: green), borderRadius: BorderRadius.circular(8)), child: Center(child: Text('320x50 Banner Ad - ADMOB ONLINE ONLY', style: TextStyle(fontSize: 11, color: green, fontWeight: FontWeight.bold))));

class SplashScreen extends StatefulWidget{ @override _SplashScreenState createState()=> _SplashScreenState(); }
class _SplashScreenState extends State<SplashScreen>{
  bool hasNet=true; bool checking=true;
  @override void initState(){ super.initState(); check(); }
  void check() async { bool net=await checkInternet(); setState((){ hasNet=net; checking=false; }); if(net){ Future.delayed(Duration(seconds: 2), ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> LanguageScreen()))); } }
  @override Widget build(BuildContext context){
    if(checking) return Scaffold(body: Center(child: CircularProgressIndicator(color: green)));
    if(!hasNet) return Scaffold(body: noInternetWidget(()=> { setState(()=> checking=true), check() }));
    return Scaffold(backgroundColor: Colors.white,
      body: Column(children: [
        Expanded(child: Stack(children: [
          Positioned(top: 40, left: 20, child: Icon(Icons.celebration, color: green, size: 28)),
          Positioned(top: 40, right: 20, child: Icon(Icons.celebration, color: green, size: 28)),
          Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Stack(alignment: Alignment.center, children: [
              Icon(Icons.circle_outlined, size: 140, color: green),
              Icon(Icons.park, size: 100, color: green),
              Positioned(bottom: 10, child: Icon(Icons.mosque, size: 20, color: green))
            ]),
            SizedBox(height: 10),
            Text('Esaale Sawab\nFamily Tree', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: green)),
            SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [Container(height: 1, width: 30, color: green), Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.mosque, color: green, size: 18)), Container(height: 1, width: 30, color: green)]),
            SizedBox(height: 8),
            Text('- Remember Them With Dua -', style: TextStyle(color: green, fontStyle: FontStyle.italic)),
          ]))
        ])),
        Opacity(opacity: 0.2, child: Icon(Icons.mosque, size: 100, color: green)),
        Container(height: 60, width: double.infinity, color: green)
      ]),
    );
  }
}

class LanguageScreen extends StatefulWidget{ @override _LanguageScreenState createState()=> _LanguageScreenState(); }
class _LanguageScreenState extends State<LanguageScreen>{
  final langs = ['Urdu - اردو','English','العربية - Arabic','Türkçe - Turkish','Indonesia - Indonesian','Melayu - Malay','বাংলা - Bengali','Français - French','فارسی - Persian','हिंदी - Hindi'];
  bool hasNet=true; bool checking=true;
  @override void initState(){ super.initState(); check(); }
  void check() async { bool net=await checkInternet(); setState((){ hasNet=net; checking=false; }); }
  @override Widget build(BuildContext context){
    if(checking) return Scaffold(body: Center(child: CircularProgressIndicator(color: green)));
    if(!hasNet) return Scaffold(body: noInternetWidget(()=> { setState(()=> checking=true), check() }));
    return Scaffold(backgroundColor: Colors.white,
      body: Column(children: [
        Container(height: 160, width: double.infinity, decoration: BoxDecoration(color: green, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))), child: Stack(children: [
          Positioned(top: 20, left: 0, right: 0, child: Icon(Icons.mosque, size: 120, color: Colors.white.withOpacity(0.2))),
          Center(child: Icon(Icons.nightlight_round, color: Colors.white, size: 40)),
        ])),
        SizedBox(height: 20),
        Text('Choose Your\nLanguage', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: green)),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [Container(height: 1, width: 60, color: green), Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.mosque, color: green, size: 16)), Container(height: 1, width: 60, color: green)]),
        SizedBox(height: 20),
        Expanded(child: ListView(children: langs.map((l)=> Container(margin: EdgeInsets.symmetric(horizontal: 32, vertical: 6), width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: (){ setState(()=> selectedLang=l); Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> MainTabs())); }, child: Text(l, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold))))).toList())),
        adBanner()
      ]),
    );
  }
}

class MainTabs extends StatefulWidget{ @override _MainTabsState createState()=> _MainTabsState(); }
class _MainTabsState extends State<MainTabs>{
  int tab=0; 
  List<Map<String,dynamic>> members=[{'name':'Abu Jaan','rishta':'Abu Jaan','pic': null},{'name':'Ammi Jaan','rishta':'Ammi Jaan','pic': null}]; 
  int fatiha=12, ikhlas=20, durood=0;
  bool hasNet=true; bool checking=true;
  @override void initState(){ super.initState(); check(); }
  void check() async { bool net=await checkInternet(); setState((){ hasNet=net; checking=false; }); }

  @override Widget build(BuildContext context){
    if(checking) return Scaffold(body: Center(child: CircularProgressIndicator(color: green)));
    if(!hasNet) return Scaffold(appBar: AppBar(backgroundColor: green, title: Text('No Internet')), body: noInternetWidget(()=> { setState(()=> checking=true), check() }));
    return Scaffold(
      appBar: AppBar(backgroundColor: green, title: Text([ 'Esaale Sawab', 'Family Tree', 'Sawab Counter', 'Notification Settings'][tab], style: TextStyle(color: Colors.white)), iconTheme: IconThemeData(color: Colors.white)),
      body: Column(children: [Expanded(child: [homePage(), familyTreePage(), sawabCounterPage(), notificationSettingsPage()][tab]), adBanner()]),
      bottomNavigationBar: BottomNavigationBar(currentIndex: tab>2?2:tab, selectedItemColor: green, onTap: (i){ if(i==2) setState(()=> tab=2); else setState(()=> tab=i); }, items: [BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'), BottomNavigationBarItem(icon: Icon(Icons.park), label: 'Tree'), BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')]),
      floatingActionButton: tab!=2 ? FloatingActionButton(backgroundColor: green, child: Icon(Icons.add), onPressed: ()=> addMarhoomDialog()) : null,
    );
  }

  Widget homePage()=> ListView(padding: EdgeInsets.all(16), children: [
    Card(color: lightGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), child: Padding(padding: EdgeInsets.all(16), child: Column(children: [
      Row(children: [Icon(Icons.notifications, color: green), SizedBox(width: 5), Text(tr[selectedLang]!['home']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
      SizedBox(height: 8),
      Text(members.isNotEmpty ? "Today for ${members[0]['name']}\n- 1 Fatiha pending" : "No member", textAlign: TextAlign.center),
      SizedBox(height: 10),
      SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), onPressed: ()=> setState(()=> tab=2), child: Text(tr[selectedLang]!['recite']!, style: TextStyle(color: Colors.white))))
    ]))),
    SizedBox(height: 20),
    Icon(Icons.park, size: 120, color: green),
    Center(child: Text('May Allah accept\nour good deeds (Ameen)', textAlign: TextAlign.center, style: TextStyle(color: green, fontStyle: FontStyle.italic))),
    SizedBox(height: 20),
    adBanner(),
  ]);

  Widget familyTreePage()=> ListView(padding: EdgeInsets.all(16), children: [
    Text('Family Tree - Jitni Pics Lagao Ge Tree Banta Jayega', style: TextStyle(color: green, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
    SizedBox(height: 20),
    Wrap(spacing: 15, runSpacing: 15, alignment: WrapAlignment.center, children: members.map((m)=> Column(children: [
      Container(decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: green, width: 3)), child: m['pic']!=null ? CircleAvatar(radius: 35, backgroundImage: FileImage(File(m['pic'] as String))) : CircleAvatar(radius: 35, backgroundColor: lightGreen, child: Icon(Icons.person, size: 35))),
      SizedBox(height: 5),
      Text(m['name'].toString(), style: TextStyle(fontWeight: FontWeight.bold)),
    ])).toList()),
    SizedBox(height: 20),
    Center(child: CustomPaint(size: Size(200, 80), painter: TreeBranchPainter())),
    CircleAvatar(radius: 30, backgroundColor: lightGreen, child: Icon(Icons.person, size: 30)),
    Center(child: Text('You', style: TextStyle(fontWeight: FontWeight.bold))),
    SizedBox(height: 20),
    Center(child: Text('May Allah forgive them\nand grant them Jannah', textAlign: TextAlign.center, style: TextStyle(color: green, fontStyle: FontStyle.italic))),
    adBanner(),
  ]);

  Widget sawabCounterPage()=> ListView(padding: EdgeInsets.all(16), children: [
    Center(child: Text('You recite, app counts', style: TextStyle(color: green, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
    SizedBox(height: 15),
    Card(child: ListTile(leading: Icon(Icons.menu_book, size: 40, color: green), title: Text('Surah Fatiha'), subtitle: Text('$fatiha', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), trailing: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: green), onPressed: ()=> setState(()=> fatiha++), child: Text('+1', style: TextStyle(color: Colors.white))))),
    adBanner(),
    Card(child: ListTile(leading: Icon(Icons.mosque, size: 40, color: green), title: Text('Surah Ikhlas'), subtitle: Text('$ikhlas', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), trailing: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: green), onPressed: ()=> setState(()=> ikhlas++), child: Text('+1', style: TextStyle(color: Colors.white))))),
    Card(child: ListTile(leading: Icon(Icons.circle_outlined, size: 40, color: green), title: Text('Durood Sharif'), subtitle: Text('$durood', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), trailing: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: green), onPressed: ()=> setState(()=> durood++), child: Text('+1', style: TextStyle(color: Colors.white))))),
    SizedBox(height: 10),
    Center(child: Text('Every recitation\nreaches them Insha\'Allah', textAlign: TextAlign.center, style: TextStyle(color: green))),
  ]);

  Widget notificationSettingsPage()=> ListView(padding: EdgeInsets.all(16), children: [
    ListTile(leading: Icon(Icons.access_time, color: green, size: 30), title: Text('Daily Reminder Time'), subtitle: Text('9:00 AM'), trailing: Icon(Icons.arrow_forward_ios, size: 16), onTap: (){}),
    Divider(),
    ListTile(leading: Icon(Icons.group, color: green, size: 30), title: Text('Choose members'), subtitle: Text('${members.length} selected'), trailing: Icon(Icons.arrow_forward_ios, size: 16), onTap: (){}),
    Divider(),
    ListTile(leading: Icon(Icons.language, color: green, size: 30), title: Text('Language: $selectedLang'), subtitle: Wrap(spacing: 5, children: ['Urdu','English','Arabic','Turkish','Indonesia','Malay','Bengali','French','Persian','Hindi'].map((e)=> Chip(label: Text(e, style: TextStyle(fontSize: 10)), backgroundColor: e=='Urdu'?green:lightGreen)).toList())),
    Divider(),
    SwitchListTile(activeColor: green, title: Text('Sound'), secondary: Icon(Icons.volume_up, color: green), value: true, onChanged: (v){}),
    adBanner(),
    Card(color: lightGreen, child: Padding(padding: EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(Icons.park, color: green, size: 18), SizedBox(width: 5), Text('Esaale Sawab • now', style: TextStyle(fontWeight: FontWeight.bold))]),
      SizedBox(height: 5),
      Text('Aaj ${members.isNotEmpty?members[0]['name']:'Abu Jaan'} ke liye 1 Fatiha parh lete hain? 🤲'),
      SizedBox(height: 8),
      LinearProgressIndicator(value: 1, color: green),
      SizedBox(height: 5),
      Center(child: Text('1/1 Fatiha Aaj')),
      SizedBox(height: 8),
      SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: green), onPressed: ()=> setState(()=> tab=0), child: Text('Fatiha Parh Li ✓', style: TextStyle(color: Colors.white))))
    ])))
  ]);

  void addMarhoomDialog(){
    final nameC=TextEditingController(); final yearC=TextEditingController(); String sel='Abu Jaan'; String? tempPicPath; final ImagePicker picker = ImagePicker();
    List<String> rishtas=['Abu Jaan','Ammi Jaan','Bhai Jaan','Behen','Beta','Beti','Bahu','Dada Jaan','Dadi Jaan','Nana Jaan','Nani Jaan','Chacha','Chachi','Mama','Mami','Sasur','Saas','Damad','Pota','Poti','Nawasa','Nawasi','Dost','Ustad','Other'];
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (c)=> StatefulBuilder(builder: (ctx,setM)=> Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left:16, right:16, top:16), child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      GestureDetector(onTap: () async {
        final XFile? img = await picker.pickImage(source: ImageSource.gallery);
        if(img!=null){ setM(()=> tempPicPath = img.path); }
      }, child: Stack(children: [
        tempPicPath!=null ? CircleAvatar(radius: 50, backgroundImage: FileImage(File(tempPicPath!))) : CircleAvatar(radius: 50, backgroundColor: lightGreen, child: Icon(Icons.person, size: 50)),
        Positioned(bottom: 0, right: 0, child: CircleAvatar(backgroundColor: green, radius: 15, child: Icon(Icons.camera_alt, color: Colors.white, size: 18)))
      ])),
      SizedBox(height: 5),
      Text(tr[selectedLang]!['gallery']!, style: TextStyle(fontSize: 12, color: green, fontWeight: FontWeight.bold)),
      SizedBox(height: 15),
      TextField(controller: nameC, decoration: InputDecoration(labelText: tr[selectedLang]!['add']!, border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
      SizedBox(height: 10),
      DropdownButtonFormField(value: sel, decoration: InputDecoration(labelText: tr[selectedLang]!['rishta']!, border: OutlineInputBorder(), prefixIcon: Icon(Icons.group)), items: rishtas.map((e)=> DropdownMenuItem(value:e, child: Text(e))).toList(), onChanged: (v)=> setM(()=> sel=v!)),
      SizedBox(height: 10),
      TextField(controller: yearC, decoration: InputDecoration(labelText: tr[selectedLang]!['year']!, border: OutlineInputBorder(), prefixIcon: Icon(Icons.calendar_today))),
      SizedBox(height: 15),
      SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: green), onPressed: (){ if(nameC.text.isNotEmpty){ setState(()=> members.add({'name':nameC.text,'rishta':sel,'pic': tempPicPath})); Navigator.pop(context);} }, child: Text(tr[selectedLang]!['save']!, style: TextStyle(color: Colors.white, fontSize: 16)))),
      adBanner()
    ]))))));
  }
}

class TreeBranchPainter extends CustomPainter{
  @override void paint(Canvas canvas, Size size){
    final p=Paint()..color=green..strokeWidth=2..style=PaintingStyle.stroke;
    canvas.drawLine(Offset(size.width/2, 0), Offset(size.width/2, size.height), p);
    canvas.drawLine(Offset(size.width/2, 0), Offset(0, size.height/2), p);
    canvas.drawLine(Offset(size.width/2, 0), Offset(size.width, size.height/2), p);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate)=> false;
}
