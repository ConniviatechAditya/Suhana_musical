// import 'package:dtpocketfm/pages/bottombar.dart';
// import 'package:dtpocketfm/pages/editprofile.dart';
// import 'package:dtpocketfm/pages/login.dart';
// import 'package:dtpocketfm/pages/commonpage.dart';
// import 'package:dtpocketfm/provider/generalprovider.dart';
// import 'package:dtpocketfm/provider/sidedrawerprovider.dart';
// import 'package:dtpocketfm/utils/color.dart';
// import 'package:dtpocketfm/utils/customwidget.dart';
// import 'package:dtpocketfm/utils/sharedpre.dart';
// import 'package:dtpocketfm/utils/utils.dart';
// import 'package:dtpocketfm/widget/myimage.dart';
// import 'package:dtpocketfm/widget/mynetworkimg.dart';
// import 'package:dtpocketfm/widget/mytext.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_locales/flutter_locales.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:provider/provider.dart';
// import 'package:sidebarx/sidebarx.dart';

// class Sidedrawer extends StatefulWidget {
//   final SidebarXController controller;
//   const Sidedrawer({super.key, required this.controller});

//   @override
//   State<Sidedrawer> createState() => SidedrawerState();
// }

// class SidedrawerState extends State<Sidedrawer> {
//   final SidebarXController _controller =
//       SidebarXController(selectedIndex: 0, extended: true);

//   SharedPre sharedPre = SharedPre();
//   double? width;
//   double? height;
//   String userid = "";

//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }

//   getData() async {
//     final profileProvider =
//         Provider.of<SidedrawerProvider>(context, listen: false);

//     userid = await sharedPre.read("userid") ?? "";
//     await profileProvider.getPages();
//     await profileProvider.valueUpdate(userid);
//     await profileProvider.getProfile(userid.toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final profileProvider =
//         Provider.of<SidedrawerProvider>(context, listen: false);

//     return SidebarX(
//       controller: _controller,
//       theme: SidebarXTheme(
//         margin: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: colorPrimaryDark,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         hoverColor: colorPrimaryDark,
//         textStyle: TextStyle(color: white.withOpacity(0.7)),
//         selectedTextStyle: const TextStyle(color: white),
//         itemTextPadding: const EdgeInsets.only(left: 30),
//         selectedItemTextPadding: const EdgeInsets.only(left: 30),
//         itemDecoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: colorPrimaryDark),
//         ),
//         selectedItemDecoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: colorPrimaryDark.withOpacity(0.37),
//           ),
//           gradient: const LinearGradient(
//             colors: [yellow, colorAccent],
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: black.withOpacity(0.28),
//               blurRadius: 30,
//             )
//           ],
//         ),
//         iconTheme: IconThemeData(
//           color: white.withOpacity(0.7),
//           size: 20,
//         ),
//         selectedIconTheme: const IconThemeData(
//           color: white,
//           size: 20,
//         ),
//       ),
//       extendedTheme: SidebarXTheme(
//         width: MediaQuery.of(context).size.width * 0.70,
//         decoration: const BoxDecoration(
//           color: colorPrimaryDark,
//         ),
//       ),
//       headerBuilder: (context, extended) {
//         return Consumer<SidedrawerProvider>(
//             builder: (context, profileProvider, child) {
//           if (profileProvider.loading) {
//             if (userid.isEmpty || userid == "") {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(height: MediaQuery.of(context).size.height * 0.05),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(50),
//                     child: MyImage(
//                         width: 80, height: 80, imagePath: "ic_user.png"),
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     alignment: Alignment.center,
//                     width: MediaQuery.of(context).size.width,
//                     padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
//                     child: MyText(
//                         color: white,
//                         text: "guestuser",
//                         multilanguage: true,
//                         textalign: TextAlign.center,
//                         fontsize: 18,
//                         inter: true,
//                         maxline: 2,
//                         fontwaight: FontWeight.w600,
//                         overflow: TextOverflow.ellipsis,
//                         fontstyle: FontStyle.normal),
//                   ),
//                 ],
//               );
//             } else {
//               return profileShimmer();
//             }
//           } else {
//             if (profileProvider.profileModel.status == 200) {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.05,
//                   ),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(50),
//                     child: (profileProvider.profileModel.status == 200 &&
//                             ((profileProvider.profileModel.result?[0].image
//                                         ?.length ??
//                                     0) !=
//                                 0))
//                         ? MyNetworkImage(
//                             imgWidth: 80,
//                             imgHeight: 80,
//                             fit: BoxFit.cover,
//                             imageUrl: profileProvider
//                                     .profileModel.result?[0].image
//                                     .toString() ??
//                                 "",
//                           )
//                         : MyImage(
//                             width: 45, height: 45, imagePath: "ic_user.png"),
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     alignment: Alignment.center,
//                     width: MediaQuery.of(context).size.width,
//                     padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
//                     child: MyText(
//                         color: white,
//                         text: (profileProvider.profileModel.status == 200 &&
//                                 (profileProvider
//                                             .profileModel.result?[0].fullName
//                                             .toString() ??
//                                         "")
//                                     .isEmpty)
//                             ? (profileProvider.profileModel.result?[0].email
//                                     .toString() ??
//                                 "Guest User")
//                             : profileProvider.profileModel.status == 200
//                                 ? (profileProvider
//                                         .profileModel.result?[0].fullName
//                                         .toString() ??
//                                     "Guest User")
//                                 : "",
//                         textalign: TextAlign.center,
//                         fontsize: 18,
//                         inter: true,
//                         maxline: 2,
//                         fontwaight: FontWeight.w600,
//                         overflow: TextOverflow.ellipsis,
//                         fontstyle: FontStyle.normal),
//                   ),
//                   InkWell(
//                     focusColor: gray.withOpacity(0.40),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) {
//                             return EditProfile(
//                               userid: userid.toString(),
//                             );
//                           },
//                         ),
//                       );
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       child: MyText(
//                           color: red,
//                           text: "taptoedit",
//                           multilanguage: true,
//                           textalign: TextAlign.center,
//                           fontsize: 14,
//                           inter: true,
//                           maxline: 1,
//                           fontwaight: FontWeight.w500,
//                           overflow: TextOverflow.ellipsis,
//                           fontstyle: FontStyle.normal),
//                     ),
//                   ),
//                 ],
//               );
//             } else {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.05,
//                   ),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(50),
//                     child: MyImage(
//                         width: 80, height: 80, imagePath: "ic_user.png"),
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     alignment: Alignment.center,
//                     width: MediaQuery.of(context).size.width,
//                     padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
//                     child: MyText(
//                         color: white,
//                         text: "guestuser",
//                         multilanguage: true,
//                         textalign: TextAlign.center,
//                         fontsize: 18,
//                         inter: true,
//                         maxline: 2,
//                         fontwaight: FontWeight.w600,
//                         overflow: TextOverflow.ellipsis,
//                         fontstyle: FontStyle.normal),
//                   ),
//                 ],
//               );
//             }
//           }
//         });
//       },
//       items: [
//         SidebarXItem(
//           onTap: () {
//             changeLanguage(context);
//           },
//           iconWidget: Row(
//             children: [
//               MyImage(width: 20, height: 25, imagePath: "ic_applanguage.png"),
//               const SizedBox(width: 20),
//               MyText(
//                   color: white,
//                   text: "applanguage",
//                   multilanguage: true,
//                   textalign: TextAlign.center,
//                   fontsize: 15,
//                   inter: true,
//                   maxline: 2,
//                   fontwaight: FontWeight.w600,
//                   overflow: TextOverflow.ellipsis,
//                   fontstyle: FontStyle.normal),
//             ],
//           ),
//         ),
//         SidebarXItem(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) {
//                   return CommonPage(
//                     title: "refundpolicy",
//                     url:
//                         profileProvider.getpagesModel.result![3].url.toString(),
//                   );
//                 },
//               ),
//             );
//           },
//           iconWidget: Row(
//             children: [
//               MyImage(width: 20, height: 25, imagePath: "ic_refand.png"),
//               const SizedBox(width: 20),
//               MyText(
//                   color: white,
//                   text: "refundpolicy",
//                   multilanguage: true,
//                   textalign: TextAlign.center,
//                   fontsize: 15,
//                   inter: true,
//                   maxline: 2,
//                   fontwaight: FontWeight.w600,
//                   overflow: TextOverflow.ellipsis,
//                   fontstyle: FontStyle.normal),
//             ],
//           ),
//         ),
//         SidebarXItem(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) {
//                   return CommonPage(
//                     title: "termscondition",
//                     url:
//                         profileProvider.getpagesModel.result![2].url.toString(),
//                   );
//                 },
//               ),
//             );
//           },
//           iconWidget: Row(
//             children: [
//               MyImage(width: 20, height: 25, imagePath: "ic_tc.png"),
//               const SizedBox(width: 20),
//               MyText(
//                   color: white,
//                   text: "termscondition",
//                   multilanguage: true,
//                   textalign: TextAlign.center,
//                   fontsize: 15,
//                   inter: true,
//                   maxline: 2,
//                   fontwaight: FontWeight.w600,
//                   overflow: TextOverflow.ellipsis,
//                   fontstyle: FontStyle.normal),
//             ],
//           ),
//         ),
//         SidebarXItem(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) {
//                   return CommonPage(
//                     title: "privacypolicy",
//                     url:
//                         profileProvider.getpagesModel.result![1].url.toString(),
//                   );
//                 },
//               ),
//             );
//           },
//           iconWidget: Row(
//             children: [
//               MyImage(width: 20, height: 25, imagePath: "ic_privacy.png"),
//               const SizedBox(width: 20),
//               MyText(
//                   color: white,
//                   text: "privacypolicy",
//                   multilanguage: true,
//                   textalign: TextAlign.center,
//                   fontsize: 15,
//                   inter: true,
//                   maxline: 2,
//                   fontwaight: FontWeight.w600,
//                   overflow: TextOverflow.ellipsis,
//                   fontstyle: FontStyle.normal),
//             ],
//           ),
//         ),
//         SidebarXItem(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) {
//                   return CommonPage(
//                     title: "aboutus",
//                     url:
//                         profileProvider.getpagesModel.result![0].url.toString(),
//                   );
//                 },
//               ),
//             );
//           },
//           iconWidget: Row(
//             children: [
//               MyImage(width: 20, height: 25, imagePath: "ic_about.png"),
//               const SizedBox(width: 20),
//               MyText(
//                   color: white,
//                   text: "aboutus",
//                   multilanguage: true,
//                   textalign: TextAlign.center,
//                   fontsize: 15,
//                   inter: true,
//                   maxline: 2,
//                   fontwaight: FontWeight.w600,
//                   overflow: TextOverflow.ellipsis,
//                   fontstyle: FontStyle.normal),
//             ],
//           ),
//         ),
//         SidebarXItem(
//           onTap: () {
//             if (userid.isEmpty || userid == "") {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) {
//                     return const Login(
//                       ishome: true,
//                     );
//                   },
//                 ),
//               );
//             } else {
//               showModalBottomSheet(
//                 context: context,
//                 isScrollControlled: true,
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(25),
//                   ),
//                 ),
//                 builder: (context) {
//                   return Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height * 0.25,
//                     color: colorPrimary,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         MyText(
//                             color: white,
//                             text: "youwanttologout",
//                             multilanguage: true,
//                             textalign: TextAlign.center,
//                             fontsize: 16,
//                             inter: true,
//                             maxline: 6,
//                             fontwaight: FontWeight.w500,
//                             overflow: TextOverflow.ellipsis,
//                             fontstyle: FontStyle.normal),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             InkWell(
//                               onTap: () {
//                                 removeUseridFromLocal();
//                                 Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) {
//                                       return const Login(
//                                         ishome: true,
//                                       );
//                                     },
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 width: 100,
//                                 height:
//                                     MediaQuery.of(context).size.height * 0.05,
//                                 alignment: Alignment.center,
//                                 decoration: const BoxDecoration(
//                                   color: colorPrimary,
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(50)),
//                                 ),
//                                 child: MyText(
//                                     color: white,
//                                     text: "yes",
//                                     multilanguage: true,
//                                     textalign: TextAlign.center,
//                                     fontsize: 16,
//                                     inter: true,
//                                     maxline: 6,
//                                     fontwaight: FontWeight.w600,
//                                     overflow: TextOverflow.ellipsis,
//                                     fontstyle: FontStyle.normal),
//                               ),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 Navigator.pop(context);
//                               },
//                               child: Container(
//                                 width: 100,
//                                 height:
//                                     MediaQuery.of(context).size.height * 0.05,
//                                 alignment: Alignment.center,
//                                 decoration: const BoxDecoration(
//                                   color: colorAccent,
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(50)),
//                                 ),
//                                 child: MyText(
//                                     color: white,
//                                     text: "no",
//                                     multilanguage: true,
//                                     textalign: TextAlign.center,
//                                     fontsize: 16,
//                                     inter: true,
//                                     maxline: 6,
//                                     fontwaight: FontWeight.w600,
//                                     overflow: TextOverflow.ellipsis,
//                                     fontstyle: FontStyle.normal),
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//           iconWidget: Row(
//             children: [
//               MyImage(width: 20, height: 25, imagePath: "ic_logout.png"),
//               const SizedBox(width: 20),
//               Consumer<SidedrawerProvider>(
//                   builder: (context, valueupdateProvider, child) {
//                 return MyText(
//                     color: white,
//                     text: valueupdateProvider.uid.isEmpty ||
//                             valueupdateProvider.uid == ""
//                         ? "login"
//                         : "logout",
//                     multilanguage: true,
//                     textalign: TextAlign.center,
//                     fontsize: 15,
//                     inter: true,
//                     maxline: 2,
//                     fontwaight: FontWeight.w600,
//                     overflow: TextOverflow.ellipsis,
//                     fontstyle: FontStyle.normal);
//               }),
//             ],
//           ),
//         ),
//         SidebarXItem(
//           onTap: () {
//             if (userid.isNotEmpty || userid != "") {
//               showModalBottomSheet(
//                   context: context,
//                   isScrollControlled: true,
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(25),
//                     ),
//                   ),
//                   builder: (context) {
//                     return Container(
//                       width: MediaQuery.of(context).size.width,
//                       height: MediaQuery.of(context).size.height * 0.25,
//                       color: colorPrimary,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           MyText(
//                               color: white,
//                               text: "youwantdeleteaccount",
//                               multilanguage: true,
//                               textalign: TextAlign.center,
//                               fontsize: 16,
//                               inter: true,
//                               maxline: 6,
//                               fontwaight: FontWeight.w500,
//                               overflow: TextOverflow.ellipsis,
//                               fontstyle: FontStyle.normal),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               InkWell(
//                                 onTap: () async {
//                                   clearLocalData();
//                                   final generalprovider =
//                                       Provider.of<GeneralProvider>(context,
//                                           listen: false);
//                                   await generalprovider
//                                       .getDeleteAccount(userid);
//                                   if (!mounted) return;

//                                   if (generalprovider.loading) {
//                                     Utils().showProgress(
//                                         context, "Deleted Account");
//                                   } else {
//                                     if (generalprovider
//                                             .deleteaccountModel.status ==
//                                         200) {
//                                       Utils().showSnackbar(
//                                           context, "accountdelete");
//                                       Utils().hideProgress(context);
//                                     } else {
//                                       Utils().showSnackbar(
//                                           context, "somethingWentWronge");
//                                       Utils().hideProgress(context);
//                                     }
//                                   }

//                                   Navigator.of(context).pushReplacement(
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               const Bottombar()));
//                                 },
//                                 child: Container(
//                                   width: 100,
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.05,
//                                   alignment: Alignment.center,
//                                   decoration: const BoxDecoration(
//                                     color: colorPrimary,
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(50)),
//                                   ),
//                                   child: MyText(
//                                       color: white,
//                                       text: "yes",
//                                       multilanguage: true,
//                                       textalign: TextAlign.center,
//                                       fontsize: 16,
//                                       inter: true,
//                                       maxline: 6,
//                                       fontwaight: FontWeight.w600,
//                                       overflow: TextOverflow.ellipsis,
//                                       fontstyle: FontStyle.normal),
//                                 ),
//                               ),
//                               InkWell(
//                                 onTap: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Container(
//                                   width: 100,
//                                   height:
//                                       MediaQuery.of(context).size.height * 0.05,
//                                   alignment: Alignment.center,
//                                   decoration: const BoxDecoration(
//                                     color: colorAccent,
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(50)),
//                                   ),
//                                   child: MyText(
//                                       color: white,
//                                       text: "no",
//                                       multilanguage: true,
//                                       textalign: TextAlign.center,
//                                       fontsize: 16,
//                                       inter: true,
//                                       maxline: 6,
//                                       fontwaight: FontWeight.w600,
//                                       overflow: TextOverflow.ellipsis,
//                                       fontstyle: FontStyle.normal),
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     );
//                   });
//             }
//           },
//           iconWidget: Consumer<SidedrawerProvider>(
//               builder: (context, valueupdateProvider, child) {
//             return valueupdateProvider.uid.isNotEmpty ||
//                     valueupdateProvider.uid != ""
//                 ? Row(
//                     children: [
//                       MyImage(
//                           width: 20,
//                           height: 25,
//                           imagePath: "ic_deleteaccount.png"),
//                       const SizedBox(width: 20),
//                       MyText(
//                           color: white,
//                           text: "deleteaccount",
//                           multilanguage: true,
//                           textalign: TextAlign.center,
//                           fontsize: 15,
//                           inter: true,
//                           maxline: 2,
//                           fontwaight: FontWeight.w600,
//                           overflow: TextOverflow.ellipsis,
//                           fontstyle: FontStyle.normal),
//                     ],
//                   )
//                 : const SizedBox.shrink();
//           }),
//         ),
//         SidebarXItem(
//           iconWidget: ValueListenableBuilder(
//             valueListenable: currentlyPlaying,
//             builder: (BuildContext context, AudioPlayer? audioObject,
//                 Widget? child) {
//               if (audioObject?.audioSource != null) {
//                 return const SizedBox(height: 15);
//               } else {
//                 return const SizedBox.shrink();
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   void changeLanguage(context) {
//     showModalBottomSheet(
//         context: context,
//         elevation: 0,
//         barrierColor: white.withAlpha(1),
//         backgroundColor: transperent,
//         builder: (BuildContext bc) {
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 alignment: Alignment.centerLeft,
//                 margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
//                 padding: const EdgeInsets.all(15),
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height * 0.30,
//                 decoration: BoxDecoration(
//                   color: colorPrimary,
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     MyText(
//                         color: colorAccent,
//                         text: "chooselanguage",
//                         multilanguage: true,
//                         textalign: TextAlign.center,
//                         fontsize: 16,
//                         inter: true,
//                         maxline: 6,
//                         fontwaight: FontWeight.w600,
//                         overflow: TextOverflow.ellipsis,
//                         fontstyle: FontStyle.normal),
//                     const SizedBox(height: 10),
//                     InkWell(
//                       onTap: () {
//                         LocaleNotifier.of(context)?.change('en');
//                         Navigator.of(context).pop();
//                       },
//                       child: Container(
//                         alignment: Alignment.centerLeft,
//                         width: MediaQuery.of(context).size.width * 0.30,
//                         height: MediaQuery.of(context).size.height * 0.06,
//                         child: MyText(
//                             color: white,
//                             text: "english",
//                             textalign: TextAlign.center,
//                             fontsize: 16,
//                             multilanguage: true,
//                             inter: true,
//                             maxline: 6,
//                             fontwaight: FontWeight.w500,
//                             overflow: TextOverflow.ellipsis,
//                             fontstyle: FontStyle.normal),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         LocaleNotifier.of(context)?.change('ar');
//                         Navigator.of(context).pop();
//                       },
//                       child: Container(
//                         alignment: Alignment.centerLeft,
//                         width: MediaQuery.of(context).size.width * 0.30,
//                         height: MediaQuery.of(context).size.height * 0.06,
//                         child: MyText(
//                             color: white,
//                             text: "arabic",
//                             textalign: TextAlign.center,
//                             fontsize: 16,
//                             inter: true,
//                             maxline: 6,
//                             multilanguage: true,
//                             fontwaight: FontWeight.w500,
//                             overflow: TextOverflow.ellipsis,
//                             fontstyle: FontStyle.normal),
//                       ),
//                     ),
//                     InkWell(
//                       focusColor: gray.withOpacity(0.40),
//                       onTap: () {
//                         LocaleNotifier.of(context)?.change('hi');
//                         Navigator.of(context).pop();
//                       },
//                       child: Container(
//                         alignment: Alignment.centerLeft,
//                         width: MediaQuery.of(context).size.width * 0.30,
//                         height: MediaQuery.of(context).size.height * 0.06,
//                         child: MyText(
//                             color: white,
//                             text: "hindi",
//                             textalign: TextAlign.center,
//                             fontsize: 16,
//                             multilanguage: true,
//                             inter: true,
//                             maxline: 6,
//                             fontwaight: FontWeight.w500,
//                             overflow: TextOverflow.ellipsis,
//                             fontstyle: FontStyle.normal),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 60),
//             ],
//           );
//         });
//   }

//   Widget profileShimmer() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         SizedBox(
//           height: MediaQuery.of(context).size.height * 0.05,
//         ),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(50),
//           child: const CustomWidget.circular(
//             height: 80,
//             width: 80,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           alignment: Alignment.center,
//           width: MediaQuery.of(context).size.width,
//           padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
//           child: const CustomWidget.roundrectborder(
//             height: 15,
//             width: 130,
//           ),
//         ),
//         const CustomWidget.roundrectborder(
//           height: 12,
//           width: 100,
//         ),
//       ],
//     );
//   }

  
// }
