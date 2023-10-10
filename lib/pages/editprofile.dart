import 'dart:io';
import 'package:dtpocketfm/pages/bottombar.dart';
import 'package:dtpocketfm/provider/updateprofileprovider.dart';
import 'package:dtpocketfm/utils/color.dart';
import 'package:dtpocketfm/utils/utils.dart';
import 'package:dtpocketfm/widget/myimage.dart';
import 'package:dtpocketfm/widget/mynetworkimg.dart';
import 'package:dtpocketfm/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final String userid;
  const EditProfile({super.key, required this.userid});

  @override
  State<EditProfile> createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  final ImagePicker picker = ImagePicker();
  String userid = "", name = "";
  XFile? _image;
  bool iseditimg = false;
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getApi();
  }

  getApi() async {
    final profileProvider =
        Provider.of<UpdateProfileProvider>(context, listen: false);
    await profileProvider.getProfile(widget.userid);

    nameController.text =
        profileProvider.profileModel.result?[0].fullName.toString() ?? "";
    numberController.text =
        profileProvider.profileModel.result?[0].mobileNumber.toString() ?? "";
    bioController.text =
        profileProvider.profileModel.result?[0].bio.toString() ?? "";
    emailController.text =
        profileProvider.profileModel.result?[0].email.toString() ?? "";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        child: Consumer<UpdateProfileProvider>(
            builder: (context, profileProvider, child) {
          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.40,
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorPrimaryDark.withOpacity(0.9),
                          colorPrimaryDark.withOpacity(0.1),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: const [0.1, 0.9],
                      ),
                      color: white,
                    ),
                    child: MyNetworkImage(
                      imgWidth: MediaQuery.of(context).size.width,
                      imgHeight: MediaQuery.of(context).size.height,
                      imageUrl: profileProvider.profileModel.result?[0].image
                              .toString() ??
                          "",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorPrimaryDark.withOpacity(0.6),
                          colorPrimaryDark.withOpacity(1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0, 0.5],
                      ),
                      color: red,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        space(0.07),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const Bottombar();
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                child: MyImage(
                                    width: 15,
                                    height: 15,
                                    imagePath: "ic_back.png"),
                              ),
                            ),
                            const SizedBox(width: 10),
                            MyText(
                                color: white,
                                text: "editprofile",
                                multilanguage: true,
                                textalign: TextAlign.center,
                                fontsize: 16,
                                inter: true,
                                maxline: 6,
                                fontwaight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                                fontstyle: FontStyle.normal),
                          ],
                        ),
                        space(0.04),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: white, width: 1),
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: _image == null
                                    ? MyNetworkImage(
                                        imgWidth:
                                            MediaQuery.of(context).size.width,
                                        imgHeight:
                                            MediaQuery.of(context).size.height,
                                        fit: BoxFit.cover,
                                        imageUrl: profileProvider
                                                .profileModel.result?[0].image
                                                .toString() ??
                                            "")
                                    : Image.file(
                                        File(_image!.path),
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                      ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: InkWell(
                                    onTap: () async {
                                      debugPrint("click");
                                      try {
                                        var image = await picker.pickImage(
                                            source: ImageSource.gallery,
                                            imageQuality: 100);
                                        setState(() {
                                          _image = image;
                                          iseditimg = true;
                                        });
                                      } catch (e) {
                                        debugPrint("Error ==>${e.toString()}");
                                      }
                                    },
                                    child: MyImage(
                                        width: 30,
                                        height: 30,
                                        imagePath: "ic_camera.png"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        space(0.04),
                        myTextField(nameController, TextInputAction.next,
                            TextInputType.text, "Name"),
                        space(0.03),
                        myTextField(numberController, TextInputAction.next,
                            TextInputType.number, "Mobile"),
                        space(0.03),
                        myTextField(bioController, TextInputAction.next,
                            TextInputType.text, "Bio"),
                        space(0.03),
                        myTextField(emailController, TextInputAction.done,
                            TextInputType.text, "Email"),
                        space(0.02),
                        space(0.03),
                        InkWell(
                          onTap: () async {
                            dynamic image;
                            String fullname = nameController.text.toString();
                            String number = numberController.text.toString();
                            String bio = bioController.text.toString();
                            String email = emailController.text.toString();

                            if (iseditimg) {
                              image = File(_image!.path);
                            } else {
                              image = File("");
                            }

                            final updateprofileProvider =
                                Provider.of<UpdateProfileProvider>(context,
                                    listen: false);
                            Utils().showProgress(context, "Please Wait");
                            await updateprofileProvider.getupdateProfile(
                                widget.userid,
                                fullname,
                                number,
                                bio,
                                email,
                                image);

                            if (updateprofileProvider.loading) {
                              if (!mounted) return;
                              Utils().showProgress(context, "Please Wait");
                            } else {
                              if (updateprofileProvider
                                      .updateprofileModel.status ==
                                  200) {
                                Utils().showToast(updateprofileProvider
                                    .updateprofileModel.message
                                    .toString());
                                if (!mounted) return;
                                Utils().hideProgress(context);
                                setState(() {});
                                getApi();
                              } else {
                                Utils().showToast(updateprofileProvider
                                    .updateprofileModel.message
                                    .toString());
                                if (!mounted) return;
                                Utils().hideProgress(context);
                              }
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(7)),
                              gradient: LinearGradient(
                                colors: [
                                  colorAccent.withOpacity(0.6),
                                  red.withOpacity(1),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: MyText(
                                color: white,
                                text: "submit",
                                multilanguage: true,
                                textalign: TextAlign.center,
                                fontsize: 16,
                                inter: true,
                                maxline: 6,
                                fontwaight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis,
                                fontstyle: FontStyle.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget myTextField(controller, textInputAction, keyboardType, labletext) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        textAlign: TextAlign.left,
        obscureText: false,
        keyboardType: keyboardType,
        controller: controller,
        textInputAction: textInputAction,
        cursorColor: white,
        style: GoogleFonts.montserrat(
            fontSize: 14,
            fontStyle: FontStyle.normal,
            color: white,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: labletext,
          labelStyle: GoogleFonts.montserrat(
              fontSize: 14,
              fontStyle: FontStyle.normal,
              color: red,
              fontWeight: FontWeight.w500),
          contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: white, width: 1.5),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: white, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget space(double space) {
    return SizedBox(height: MediaQuery.of(context).size.height * space);
  }
}
