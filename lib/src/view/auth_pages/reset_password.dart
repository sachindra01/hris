import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:hris/src/controller/auth_controller.dart";
import "package:hris/src/helper/style.dart";
import "package:hris/src/helper/validations.dart";
import "package:hris/src/widgets/custom_text_field.dart";
import "package:hris/src/widgets/gradient_button.dart";

class ResetPassword extends StatefulWidget {
  final String email;
  const ResetPassword({super.key, required this.email});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  //TextControllers
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //Obscure password
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  //Controllers
  final AuthController _con = Get.put(AuthController());

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                      "Enter the OTP that we sent to you E-mail",
                      style: TextStyle(
                        color: grey600,
                        fontSize: 16
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  //Email
                  resetPasswordForm(),
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

  //Reset Password
  resetPasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          //Confirm Password
          CustomTextField(
            controller: otpController, 
            keyboardType: TextInputType.number,
            maxLines: 1,
            hintText: "Verify OTP",
            hintStyle: TextStyle(
              color: grey500
            ),
            validator: (otp) => Validations.checkOtp(otp),
            autoValidateMode: AutovalidateMode.onUserInteraction,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filledColor: Colors.grey.withOpacity(0.1),
            filled: true,
          ),
          SizedBox(height: 10.h),
          //New Password
          CustomTextField(
            controller: passwordController, 
            obscureText: obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            maxLines: 1,
            hintText: "Password",
            hintStyle: TextStyle(
              color: grey500
            ),
            suffixIcon: GestureDetector(
              onTap: (){
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
              child: Icon(
                obscurePassword ? Icons.visibility : Icons.visibility_off,
                size: 20,
                color: Colors.grey,
              ),
            ),
            validator: (password)  => Validations.password(password),
            autoValidateMode: AutovalidateMode.onUserInteraction,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filledColor: Colors.grey.withOpacity(0.1),
            filled: true,
          ),
          SizedBox(height: 10.h),
          //Confirm Password
          CustomTextField(
            controller: confirmPasswordController, 
            obscureText: obscureConfirmPassword,
            keyboardType: TextInputType.visiblePassword,
            maxLines: 1,
            hintText: "Confirm Password",
            hintStyle: TextStyle(
              color: grey500
            ),
            suffixIcon: GestureDetector(
              onTap: (){
                setState(() {
                  obscureConfirmPassword = !obscureConfirmPassword;
                });
              },
              child: Icon(
                obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                size: 20,
                color: Colors.grey,
              ),
            ),
            validator: (password) {
              if(passwordController.text != password){
                return "Password does not match";
              }
              return null;
            },
            autoValidateMode: AutovalidateMode.onUserInteraction,
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
        await _con.resetPassword(
          widget.email.trim(),
          otpController.text.trim(),
          confirmPasswordController.text.trim(), 
          context,
        );
      }
    );
  }
}