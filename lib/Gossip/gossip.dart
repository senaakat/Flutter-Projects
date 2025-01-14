import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';

import 'animasyon.dart';
import 'filewr.dart';
import 'incontainer.dart';
import 'listler.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: SplashPage()));
}

class Gossip extends StatefulWidget {
  @override
  _GossipState createState() => _GossipState();
}

class _GossipState extends State<Gossip> {
  int i = 0;
  bool first = true;

  TextEditingController textController = TextEditingController(); //büyük metin için controller
  TextEditingController titletextController = TextEditingController(); //başlık için controller

  List<Containerin> containerwl = [];

  void readfromfile(yol) {
    Dosyawr.rf(yol).then((value) {
      setState(() {
        containerwl = value;

        i = containerwl.length;
        if (i != 0) {
          i = 0;
          for (Containerin item in containerwl) {
            item.text = item.text.replaceAll("é", ",");
            containerList.add(containermaking(i));
            i = containerList.length;
          }
        }
      });
    });
  }

  String pickedimage = '';
  File? _selectedImage;

  void writetofile() {
    setState(() {
      var title = titletextController.text;
      var imagefromaddresim = pickedimage;
      var text = textController.text.replaceAll(",", "é");
      var imagefromgalleriypath = _selectedImage?.path;
      if (_selectedImage != null && imagefromaddresim == '') {
        var newc = Containerin(title: title, imagefromgalleriypath: imagefromgalleriypath, text: text);
        containerwl.add(newc);
      } else if (imagefromgalleriypath == null && imagefromaddresim != '') {
        var newc = Containerin(title: title, imagefromaddresim: imagefromaddresim, text: text);
        containerwl.add(newc);
      } else {
        var newc = Containerin(title: title, text: text);
        containerwl.add(newc);
      }
      Dosyawr.dosyayaYaz(r'C:\Users\Senaa\Desktop\Flutter-project\GitProject\flutter_project\lib\Gossip\filekeeping\file.txt', containerwl); //yolu değistirin
    });
  }

  //başlık için text sonradan tutabilimek için
  List<ClipRRect> containerList = ContainerListClass.containerList;
  Future _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? pickediimage = await picker.pickImage(source: ImageSource.gallery);
    //if (pickediimage==Null)return ;
    setState(() {
      if (pickediimage?.path == null)
        return Navigator.of(context).pop();
      else
        _selectedImage = File(pickediimage!.path);
    });
  }

  ClipRRect containermaking(int index) {
    if (containerwl[index].imagefromgalleriypath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Container(
          padding: const EdgeInsets.all(4),
          color: Colors.black.withOpacity(0.5),
          child: Column(
            children: [
              Text("${containerwl[index].title.toUpperCase()}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  )),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Container(padding: const EdgeInsets.all(4.0), child: Image.file(File("${containerwl[index].imagefromgalleriypath}"))),
              ),
              Text("${containerwl[index].text.replaceAll("é", ",")}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ))
            ],
          ),
        ),
      );
    } else if (containerwl[index].imagefromaddresim != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Container(
          padding: const EdgeInsets.all(4),
          color: Colors.black.withOpacity(0.5),
          child: Column(
            children: [
              Text("${containerwl[index].title.toUpperCase()}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  )),
              ClipRRect(borderRadius: BorderRadius.circular(4.0), child: Container(padding: const EdgeInsets.all(4.0), child: Image.network("${containerwl[index].imagefromaddresim}", fit: BoxFit.cover))),
              Text("${containerwl[index].text.replaceAll("é", ",")}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ))
            ],
          ),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: Container(
        padding: const EdgeInsets.all(4),
        color: Colors.black.withOpacity(0.5),
        child: Column(
          children: [
            Text("${containerwl[index].title.toUpperCase()}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                )),
            Text("${containerwl[index].text.replaceAll("é", ",")}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ))
          ],
        ),
      ),
    );
  }

  Padding addresim(String resimadres) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextButton(
          onPressed: () {
            pickedimage = resimadres;
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black.withOpacity(0.2), shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(4))),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              width: 150.0,
              height: 150.0,
              child: ClipRRect(borderRadius: BorderRadius.circular(4.0), child: Image.network(resimadres, fit: BoxFit.cover)),
            ),
          )),
    );
  }

  Row metinalani(TextEditingController textc, String hintText, String titlename) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: TextStyle(color: Colors.white.withOpacity(0.9)),
              cursorColor: Colors.white,
              controller: textc,
              decoration: InputDecoration(
                labelText: titlename,
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)), //bu metne tıklağında başlık gibi davranıtor
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(0.5))),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),

                suffixIcon: IconButton(
                  //gerisi bizim kodla aynı
                  onPressed: () {
                    textc.clear();
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //layout başlangıcı
    if (first) {
      readfromfile(r'C:\Users\Senaa\Desktop\Flutter-project\GitProject\flutter_project\lib\Gossip\filekeeping\file.txt'); //değiş
      first = false;
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color(0xffee2d88),
              Colors.black
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(children: [
              Expanded(
                child: CustomScrollView(
                  // Wrap your Column with SingleChildScrollView
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.black,
                      title: const Text("W H I S P E R G P T"),
                      expandedHeight: 200,
                      flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                        color: const Color(0xffa82060),
                      )),
                      leading: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                    SliverToBoxAdapter(
                      child: MasonryGridView.builder(
                        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: containerwl.length,
                        shrinkWrap: true,
                        itemBuilder: ((context, i) => Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: List.from(containerList.reversed)[i],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.add,
                color: Color(0xffa82060),
              ),
              onPressed: () {
                setState(() {
                  showModalBottomSheet(
                      enableDrag: true,
                      isScrollControlled: true,
                      context: context,
                      backgroundColor: Colors.transparent, //containerin rengi olduğundna bunu direct transparan yapıyoz
                      builder: (BuildContext context) => GestureDetector(
                            behavior: HitTestBehavior.opaque, //alan belirlemek için kullanıyor sanırım listview yüzünden arkaya dokununca sheet kapanmıyor bunun için arkayo seçmek gibi bir şey
                            onTap: () => Navigator.of(context).pop(), //sheeti kapamak için
                            child: DraggableScrollableSheet(
                              initialChildSize: 0.7, //ilk açıldığındaki boyutu
                              maxChildSize: 0.7, //max alabileceği boyut ilkle aynı olmalıymış
                              minChildSize: 0.3, //bu değerden küçük olunca otomatik kendini aşağı atıp kapanıyor

                              builder: (_, controller) => Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xffa82060),
                                  borderRadius: BorderRadius.vertical(
                                      //yuvarlak kenar için
                                      top: Radius.circular(20.0)),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Column(
                                    children: [
                                      metinalani(titletextController, "Metni bir kaç cümleyle özetle", "Başlık"), //textfield
                                      metinalani(textController, "Detaylarıyla anlat bakalım", "Metin"),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(width: 4.0, color: Colors.black.withOpacity(0.7)),
                                                    color: Colors.black.withOpacity(0.5),
                                                    borderRadius: const BorderRadius.all(//yuvarlak kenar için
                                                        Radius.circular(20.0)),
                                                  ),
                                                  child: TextButton(
                                                      onPressed: () {
                                                        _pickImageFromGallery();
                                                      },
                                                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                        Icon(
                                                          Icons.add_a_photo,
                                                          size: 50,
                                                          color: Colors.white.withOpacity(0.9),
                                                        ),
                                                        _selectedImage == null
                                                            ? Text(
                                                                "Lütfen galerinizden fotoğraf seçiniz",
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  color: Colors.white.withOpacity(0.9),
                                                                ),
                                                              )
                                                            : const Text(
                                                                "",
                                                                style: TextStyle(color: Color.fromARGB(255, 143, 68, 156)),
                                                              )
                                                      ]))),
                                            ),
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(width: 4.0, color: Colors.black.withOpacity(0.7)),
                                                  color: Colors.black.withOpacity(0.5),
                                                  borderRadius: const BorderRadius.all(//yuvarlak kenar için
                                                      Radius.circular(20.0)),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      IconButton(
                                                          onPressed: () {
                                                            pickedimage = '';
                                                          },
                                                          icon: Icon(
                                                            Icons.cancel,
                                                            color: Colors.white.withOpacity(0.7),
                                                          )),
                                                      Expanded(
                                                        child: SingleChildScrollView(
                                                          child: Column(children: [
                                                            addresim("https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcR7CzJI8cMA0yfEkSgsGwMeZxM12Hi5kD6_e88KwsvNbd2I1h3b"),
                                                            addresim("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH8uWqct-rgzKC-UtcVW8YEMq_NPm_BMGAvA&usqp=CAU"),
                                                            addresim("https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcSen8n2uo29WiGoKkAsz9_5CVDDsmFM0bY-fQAwu7LQ_3Xxfna9"),
                                                            addresim("https://snworksceo.imgix.net/dth/84e832cc-b853-40d1-bcf9-bd0d2aae2bec.sized-1000x1000.png?w=800&h=600"),
                                                            addresim("https://media.tenor.com/KXPcvHCgCHEAAAAM/friends-oh-my-eyes-my-eyes.gif"),
                                                            addresim("https://media3.giphy.com/media/JZgZbes8WGGBi/200w.gif?cid=6c09b952o6906p6vpya5byk74fd94rlyi7zkebusncsqxnq7&ep=v1_gifs_search&rid=200w.gif&ct=g"),
                                                            addresim("https://media.tenor.com/CqPOD1xtSX8AAAAM/thor-funny-thor-ragnarok.gif")
                                                          ]),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            if (titletextController.text == '' || textController.text == '') {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Text("Tamam"),
                                                        ),
                                                      ], title: const Text("Uyarı!"), contentPadding: const EdgeInsets.all(20.0), content: const Text("Metin veya başlık eksik girdin sanınım!")));
                                            } else if (pickedimage != '' && _selectedImage != null) {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            pickedimage = '';
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Text("Galeri"),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            _selectedImage = null;
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Text("Fotoğraf veya gif seçim"),
                                                        ),
                                                      ], title: const Text("Uyarı!"), contentPadding: const EdgeInsets.all(20.0), content: const Text("Fotoğraf galeri ve seçim özellliklerini aynı anda kullanamazsın. Hangisini kullanmak istersin?")));
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            writetofile();
                                                            containerList.add(containermaking(i));
                                                            ++i;

                                                            titletextController.clear();
                                                            textController.clear();
                                                            pickedimage = '';
                                                            _selectedImage = null;

                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Text("Evet"),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Text("Hayır"),
                                                        ),
                                                      ], title: const Text("Uyarı!"), contentPadding: const EdgeInsets.all(20.0), content: const Text("Hey,eklediğin şey sonsuza kadar kalacak farkındasın değil mi?")));
                                            }
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black.withOpacity(0.5)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "Gönder",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            Icon(
                                              Icons.send,
                                              color: Colors.white.withOpacity(0.9),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ));
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
