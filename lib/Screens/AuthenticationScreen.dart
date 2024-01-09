import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopii2/provider/Auth.dart';
//import './product_overview_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:shopii2/Screens/AppDrawer.dart';
// import 'package:shopii2/provider/Auth.dart';

enum AuthMode {
  login,
  signup,
}

class AuthScreen extends StatelessWidget {
  static const routeName = '/AuthScreen';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Stack(children: [
      Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.deepPurple,
            Colors.pink,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1.0],
        )),
      ),
      SingleChildScrollView(
          child: Container(
        height: deviceSize.height,
        width: deviceSize.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Container(
                margin: const EdgeInsets.all(15),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 94),
                transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [
                        Colors.cyan,
                        Colors.white,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.2, 0.8],
                    )),
                child: const Text(
                  'ShopMart',
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Manrope',
                      color: Color.fromARGB(255, 229, 100, 252)),
                ),
              ),
            ),
            Flexible(
              flex: deviceSize.width > 600 ? 2 : 1,
              child: AuthCard(),
            ),
          ],
        ),
      )),
    ]);
  }
}

class AuthCard extends StatefulWidget {
  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();
  // late AnimationController _animationController;
  // late Animation<Size> _heightAnim;

  late AnimationController _controllerConfPass;
  late Animation<double> _confPassAnimation;
  late Animation<Offset> _slideAnimation;

  AuthMode _authMode = AuthMode.login;
  bool _isLoading = false;

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  @override
  void initState() {
    // _animationController = AnimationController(
    //     vsync: this, duration: const Duration(milliseconds: 300));
    // _heightAnim = Tween<Size>(
    //         begin: const Size(double.infinity, 260),
    //         end: const Size(double.infinity, 340))
    //     .animate(CurvedAnimation(
    //         parent: _animationController, curve: Curves.linearToEaseOut));

    // _heightAnim.addListener(() {
    //   setState(() {});
    // });

    _controllerConfPass = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300)); //for AnimationController
    _confPassAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controllerConfPass, curve: Curves.easeIn));
    _slideAnimation = Tween(
            begin: const Offset(0.0, -1.5), end: const Offset(0.0, 0.0))
        .animate(
            CurvedAnimation(parent: _confPassAnimation, curve: Curves.easeIn));

    // _confPassAnimation.addListener(() {
    //   setState(() {});
    // });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    //_animationController.dispose();
    _controllerConfPass.dispose();
    super.dispose();
  }

  // dynamic _showSnackBar() {
  //   return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: const Text('✅ SignUp successfully click here for login '),
  //     duration: const Duration(days: 1),
  //     action: SnackBarAction(label: 'GoTo Login ', onPressed: _switchAuthMode),
  //   ));
  // }

  Future<void> saveForm() async {
    bool _isValidate = _globalKey.currentState!.validate();
    if (!_isValidate) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _globalKey.currentState?.save();
    _authData['email'] = _emailController.text;
    _authData['password'] = _passwordController.text;

    if (_authMode == AuthMode.signup) {
      await Provider.of<Auth>(context, listen: false)
          .createUserWithEmailAndPassword(
              _emailController, _passwordController, context);
    } else {
      await Provider.of<Auth>(context, listen: false)
          .signInWithEmailAndPassword(
              _emailController, _passwordController, context);
    }

    setState(() {
      _isLoading = false;
      print('I am trigger----2');
    });
  }

  void _switchAuthMode() {
    setState(() {
      if (!(_authMode == AuthMode.login)) {
        _authMode = AuthMode.login;
        //_animationController.reverse();
        _controllerConfPass.reverse();
      } else {
        _authMode = AuthMode.signup;
        //_animationController.forward();
        _controllerConfPass.forward();
      }
    });
    print('Switch Mode triggered!!!');
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        //height: _heightAni.value.height,
        height: _authMode == AuthMode.login ? 270 : 340,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.login ? 260 : 340),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _globalKey,
          child: SingleChildScrollView(
              child: Column(children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              controller: _emailController,
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Incorrect email';
                }
                if (value.length < 10) {
                  return 'Invalid email';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
              controller: _passwordController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter password';
                }
                if (value.length < 4) {
                  return 'Password must be greater than 4 digit';
                }
                return null;
              },
            ),
            //if (_authMode == AuthMode.signup)
            AnimatedContainer(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 300),
              constraints: BoxConstraints(
                  maxHeight: _authMode == AuthMode.signup ? 120 : 0,
                  minHeight: _authMode == AuthMode.signup ? 60 : 0),
              height: _authMode == AuthMode.signup ? 60 : 0,
              child: FadeTransition(
                opacity: _confPassAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: TextFormField(
                    enabled: _authMode == AuthMode.signup,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    validator: (_authMode == AuthMode.signup)
                        ? (value) {
                            if (value!.isEmpty) {
                              return 'Password Re-enter';
                            }
                            if (!(value == _passwordController.text)) {
                              return 'Password do not match!';
                            }
                            if (value.length < 4) {
                              return 'Password too short!';
                            }
                            return null;
                          }
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ((_isLoading)
                ? const CircularProgressIndicator()
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                    child: ElevatedButton(
                      onPressed: saveForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                          _authMode == AuthMode.login ? 'Login' : 'Sign Up'),
                    ),
                  )),
            Center(
              child: ListTile(
                  leading: Text(
                      _authMode == AuthMode.signup
                          ? ' Do you have account?'
                          : ' Create new account?',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 103, 102, 102))),
                  trailing: TextButton(
                    onPressed: () => _switchAuthMode(),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      animationDuration: const Duration(seconds: 2),
                    ),
                    child: Text(
                      '${_authMode == AuthMode.login ? 'SIGNUP' : 'LOGIN'}',
                      style: const TextStyle(color: Colors.deepPurple),
                    ),
                  )),
            ),
          ])),
        ),
      ),
    );
  }
}
