import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:get/get.dart";
import "package:hris/src/controller/auth_controller.dart";
import "package:hris/src/helper/style.dart";
import "package:hris/src/helper/validations.dart";
import "package:hris/src/widgets/custom_text_field.dart";
import "package:hris/src/widgets/gradient_button.dart";

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final AuthController _con = Get.put(AuthController());

  //TextControllers
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  FToast fToast = FToast();

  @override
  void initState() {
    fToast.init(context);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal :20.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Get.back(), 
                    alignment: Alignment.topLeft,
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      // color: Colors.red,
                    )
                  ),
                  SizedBox(height: 100.h),
                  Center(
                    child: Text(
                      "Send Password Reset Link",
                      style: TextStyle(
                        color: grey600,
                        fontSize: 16
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  //Email
                  email(),
                  SizedBox(height: 25.h),
                  resetButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Email
  email() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          //Email
          CustomTextField(
            controller: emailController, 
            hintText: "E-mail",
            hintStyle: TextStyle(
              color: grey500
            ),
            validator: (value) => Validations.email(value), 
            autoValidateMode: AutovalidateMode.onUserInteraction,
            obscureText: false,
            keyboardType: TextInputType.emailAddress,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filledColor: Colors.grey.withOpacity(0.1),
            filled: true,
          ),
        ],
      ),
    );
  }
  
  //Reset Button
  resetButton() {
    return GradientButton(
      height: 45.h,
      width: double.infinity,
      text: "Reset",
      fontSize: 18.sp,
      borderRadius: 50.r,
      onPressed: () async{
        final isValid = _formKey.currentState!.validate();
        if (!isValid) return;
        await _con.forgetPassword(emailController.text.trim(), context);
      }
    );
  }
}