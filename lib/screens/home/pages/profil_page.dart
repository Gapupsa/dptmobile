import 'package:flutter/material.dart';

class DetailProfil extends StatelessWidget {

  double width,height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    final topLeft = Column(
      children: <Widget>[
        Container(
          height: height * 0.3,
          width: width * 0.3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Hero(
              tag: "1",
              child: new Material(
                borderRadius: BorderRadius.circular(10.0),
                elevation: 15.0,
                shadowColor: Colors.red.shade900,
                child: new Image(
                  image: AssetImage("assets/login_background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );

    final topRight = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        text("ALKAUSAR KALAM, SE. M.SI",
            size: 20.0,
            isBool: true,
            padding: EdgeInsets.only(top: 16.0),
            color: Colors.white),
        Divider(
          color: Colors.white,
          height: 10.0,
        ),
        text("TEMPAT/TANGGAL LAHIR : ",
            size: 16.0,
            isBool: true,
            padding: EdgeInsets.only(top: 8.0),
            color: Colors.white),
        text(" - Ujung Pandang, 27 Maret 1986", color: Colors.white),
        text("AKTIFITAS : ",
            size: 16.0,
            isBool: true,
            padding: EdgeInsets.only(top: 8.0),
            color: Colors.white),
        text(" - Mengajar, Meneliti & Menulis", color: Colors.white),
        text("HOBI : ",
            size: 16.0,
            isBool: true,
            padding: EdgeInsets.only(top: 8.0),
            color: Colors.white),
        text(" - Futsal, Memancing, Traveling", color: Colors.white),
        text("ALAMAT : ",
            size: 16.0,
            isBool: true,
            padding: EdgeInsets.only(top: 8.0),
            color: Colors.white),
        text(" - Jl. Laccukang No. 25 A Makassar 90152", color: Colors.white),
        text("CONTACT : ",
            size: 16.0,
            isBool: true,
            padding: EdgeInsets.only(top: 8.0),
            color: Colors.white),
        text(" - HP : +6285299319419", color: Colors.white),
        text(" - EMAIL : alkauzar.kalam@ymail.com", color: Colors.white),
        text(" - Website : alkauzar.kalam@blogspot.com", color: Colors.white),
      ],
    );

    final topContent = Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.only(bottom: 16.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 2,
            child: topLeft,
          ),
          Flexible(
            flex: 2,
            child: topRight,
          ),
        ],
      ),
    );

    final bottomContent = Expanded(
      child: Container(
          height: 600.0,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: new Text(
              "Pendidikan Formal \n \n" +
                  "1991 s/d 1997 : SD NEGERI KIP BARAYA MAKASSAR \n" +
                  "1997 s/d 2000 : SMPN 10 MAKASSAR \n" +
                  "2000 s/d 2003 : SMUN 16 MAKASSAR \n" +
                  "2004 s/d 2008 : ILMU EKONOMI & STUDI PEMBANGUNAN FAKULTAS EKONOMI UNHAS \n" +
                  "2009 s/d 2011 : EKONOMI PERENCANAAN & PEMBANGUNAN PASCA SARJANA UNHAS \n \n \n" +
                  "Pendidikan Informal \n \n" +
                  "2003 : PelatihanKomputer Microsoft Office (Word, Excel & Power Point) \n" +
                  "2004 s/d 2005 : English Languange Course PIA \n" +
                  "2008 : English Languange Course Briton \n" +
                  "2009 : TOEFL TheLanguange Center Hasanuddin University \n" +
                  "2011 : PelatihanPerangkatPenelitian : SPSS, AMOS, STATA & Eviews Universitas Gajah Mada \n" +
                  "2012 : Participated “Basic Statistics” Postgraduate course (PE&RC) Royal Netherlands Academy \n \n \n" +
                  "Organisasi \n \n " +
                  "2004 s/d 2005 : AnggotaKlub Bahasa Inggris	Philipines Indonesia America \n" +
                  "2004 s/d 2005 : Himpunan Mahasiswa Islam	Cabang Makassar Timur \n" +
                  "2007 s/d 2008 : Koordinator Kesma & Humas HIMAJIE Universitas Hasanuddin \n " +
                  "2009 s/d 2012 : Ketua Peneliti LP3M  Makassar \n" +
                  "2013 s/d 2016 : KetuaHarian YPK Islam Al Kalam \n \n \n" +
                  "Pengalaman Kerja \n \n" +
                  "2007 : Praktek Kerja Lapangan di PT. TASPEN PERSERO \n" +
                  "2008 : Magang Kerja di Bank Indonesia \n" +
                  "2008 s/d 2011 : Tenaga Pengajar di GAMA COLLEGE \n" +
                  "2009 : Pekerjaan Penyusunan PERA (Public Expenditure and Revenue Analysis di Sulsel, Sulbardan Papua (PSKMP UNHAS) \n" +
                  "2010 : Studi Kelayakan Pemetaan Potensi Ekonomi Provinsi Sulawesi Barat(LP2P UNHAS) \n" +
                  "2012 :	Evaluasi Kinerja Pelaksanaan Rencana Pembangunan Jangka MenengahDaerah (RPJMD) Kabupaten Gowa tahun berjalan \n" +
                  "2011 s/d 2014 : Peneliti ESDM di DINAS ESDM & PERTAMINA \n" +
                  "2011 s/d 2014 : Tenaga Pengajar di Universitas Islam Makassar \n" +
                  "2012 s/d 2013 : TenagaPengajar di Universitas Islam Negeri Makassar \n" +
                  "2013 s/d 2016 : Tenaga Pengajar di Universitas Fajar",
              style: TextStyle(fontSize: 13.0),
            ),
          )),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("DATA PROFILE"),
      ),
      body: Column(
        children: <Widget>[
          topContent,
          bottomContent,
        ],
      ),
    );
  }

  text(String data,
          {Color color = Colors.black87,
          num size = 14.0,
          EdgeInsetsGeometry padding = EdgeInsets.zero,
          bool isBool = false}) =>
      Padding(
        padding: padding,
        child: SizedBox(
          height: height * 0.016,
          child: FittedBox(
            child: Text(
              data,
              style: TextStyle(
                color: color,
                fontSize: size.toDouble(),
                fontWeight: isBool ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
}
