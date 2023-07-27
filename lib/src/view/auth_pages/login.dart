import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:get/get.dart";
import "package:hris/src/controller/app_controller.dart";
import "package:hris/src/controller/auth_controller.dart";
import "package:hris/src/helper/read_write.dart";
import "package:hris/src/helper/style.dart";
import "package:hris/src/helper/validations.dart";
import "package:hris/src/services/authentication.dart";
import "package:hris/src/view/auth_pages/forgot_password.dart";
import "package:hris/src/widgets/custom_button.dart";
import "package:hris/src/widgets/custom_text_field.dart";
import "package:hris/src/widgets/gradient_button.dart";

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final AuthController _con = Get.put(AuthController());
  final AppController _appCon = Get.put(AppController());
  final Authentication _auth = Authentication();

  //TextControllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final organizationController = TextEditingController();

  //Obscure password
  bool obscurePassword = true;
  bool rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    organizationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializeData();
    _appCon.getGeoLocation();
  }

  initializeData(){
    setState(() { 
      rememberMe = read('rememberMe') != '' && read('rememberMe') != null ? read('rememberMe') : false;
      var logInCreds = read('loginInfo');
      if(rememberMe != false && logInCreds != '' && logInCreds != null) {
        emailController.text = logInCreds['official_email'];
        passwordController.text = logInCreds['password'];
        organizationController.text = logInCreds['organization_code'];
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(height: 40.0),
                  // Logo
                  logo(),
                  // Welcome Text
                  welcomeText(),
                  const SizedBox(height: 25.0),
                  // Login Form
                  loginForm(),
                  const SizedBox(height: 10.0),
                  // Remember me and Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      rememberMeWidget(),
                      forgotPassword(),
                    ],
                  ),
                  const SizedBox(height: 25.0),
                  // Login Button
                  loginButton(),
                  const SizedBox(height: 10.0),
                  // Google Sign In
                  googleSignIn(),
                  const SizedBox(height: 25.0),
                  // Bio metrics
                  bioMetrics(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Google Sign In 
  googleSignIn() {
    return CustomButton(
      width: double.infinity,
      onPressed: () async {
        final isValid = _formKey1.currentState!.validate();
        if(!isValid) return;
        var user = await _auth.googleLogin();
        if(user == null) return;
        // ignore: use_build_context_synchronously
        _con.firebaseLogIn(user.user!.email, user.user!.uid, organizationController.text.trim(), context, user.user!.providerData[0].providerId, rememberMe);
      },
      text: "Google Sign In",
      btnContent: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/google.svg',
            height: 30.h,
            width: 30.w,
          ),
          const Text("Google Sign In"),
        ],
      ),
    );
  }

  //Logo
  logo() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: SvgPicture.asset(
        Get.isDarkMode
          ?'assets/images/login-white.svg'
          :'assets/images/login.svg',
        height: 75.h,
        width: 75.w,
      ),
    );
  }

  //Welcome Text
  Text welcomeText() {
    return Text(
      "Welcome back, how have you been?",
      style: TextStyle(
        color: grey600,
        fontSize: 14.sp
      ),
    );
  }

  //LoginForm
  loginForm() {
    return Column(
      children: [
        Form(
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
                validator: (email) => Validations.email(email),
                autoValidateMode: AutovalidateMode.onUserInteraction,
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: true,
                enableSuggestions: true,
              ),
              SizedBox(height: 10.h),
              //Password
              CustomTextField(
                controller: passwordController, 
                obscureText: obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                maxLines: 1,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: (password) => Validations.password(password),
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
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: true,
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
        //Organization
        Form(
          key: _formKey1,
          child: CustomTextField(
            controller: organizationController,
            hintText: "Organization",
            hintStyle: TextStyle(
              color: grey500
            ),
            validator: (value) => Validations.isWhiteSpace(value),
            autoValidateMode: AutovalidateMode.onUserInteraction,
            obscureText: false,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: true,
            enableSuggestions: true,
          ),
        ),
      ],
    );
  }

  //Remember Me
  rememberMeWidget() {
    return Row(
      children: [
        Checkbox(
          value: rememberMe, 
          activeColor: grey600,
          checkColor: white,
          onChanged: (val) {
            setState(() {
              rememberMe = val!;
            });
          }
        ),
        Text(
          'Remember Me',
          style: TextStyle(
            color: grey600,
            fontSize: 14.sp
          ),
        )
      ],
    );
  }

  //Forgot Password
  forgotPassword() {
    return InkWell(
      onTap: (){
        Get.to(() => const ForgotPassword());
      },
      child: Text(
        "Forgot Password?",
        style: TextStyle(
          color: grey600,
          fontSize: 13.sp
        ),
      ),
    );
  }

  //Login Button
  loginButton() {
    return GradientButton(
      height: 45.h,
      width: double.infinity,
      text: "Login",
      fontSize: 18.sp,
      borderRadius: 50.r,
      onPressed: () {
        final isValid = _formKey.currentState!.validate() && _formKey1.currentState!.validate();
        if (!isValid) return;
        _con.logIn(emailController.text.trim(), passwordController.text.trim(), organizationController.text.trim(), context, rememberMe);
      }
    );
  }

  bioMetrics() {
    return Visibility(
      visible: _appCon.canUseBiometic && (read('logInProvider') == null || read('logInProvider') == ''),
      child: Column(
        children: [
          GestureDetector(
            child: Container(
              height: 100.0,
              width: 80.0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: grey600!,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20))
              ),
              child: const Icon(
                Icons.fingerprint,
                size: 80.0,
              ),
            ),
            onTap: () async => await _appCon.authenticate(context),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Use Biometrics to log in',
            style: TextStyle(
              color: grey600
            ),
          )
        ],
      ),
    );
  }
  
}