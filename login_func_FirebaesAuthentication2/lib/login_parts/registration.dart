import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authentication_error.dart';
import '../home.dart';

// アカウント登録ページ
class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  // Firebase Authenticationを利用するためのインスタンス
  final auth = FirebaseAuth.instance;
  AuthResult _result;
  FirebaseUser _user;

  String _newEmail = "";  // 入力されたメールアドレス
  String _newPassword = "";  // 入力されたパスワード
  String _infoText = "";  // 登録に関する情報を表示
  bool _pswd_OK = false;  // パスワードが有効な文字数を満たしているかどうか

  // エラーメッセージを日本語化するためのクラス
  final auth_error = Authentication_error();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 30.0),
                  child:Text('新規アカウントの作成',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                ),

                // メールアドレスの入力フォーム
                Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                  child:TextFormField(
                    decoration: InputDecoration(labelText: "メールアドレス"),
                    onChanged: (String value) {
                      _newEmail = value;
                    },
                  )
                ),

                // パスワードの入力フォーム
                Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
                  child:TextFormField(
                    decoration: InputDecoration(
                      labelText: "パスワード（8～20文字）"
                    ),
                    obscureText: true,  // パスワードが見えないようRにする
                    maxLength: 20,  // 入力可能な文字数
                    maxLengthEnforced: false,  // 入力可能な文字数の制限を超える場合の挙動の制御
                    onChanged: (String value) {
                      if(value.length >= 8){
                        _newPassword= value;
                        _pswd_OK = true;
                      }else{
                        _pswd_OK = false;
                      }
                    }
                  ),
                ),

                // 登録失敗時のエラーメッセージ
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 5.0),
                  child:Text(_infoText,
                    style: TextStyle(color: Colors.red),),
                ),

                ButtonTheme(
                  minWidth: 350.0,
                  // height: 100.0,
                  child: RaisedButton(
                    child: Text('登録',
                      style: TextStyle(fontWeight: FontWeight.bold),),
                    textColor: Colors.white,
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),

                    onPressed: () async {
                      if (_pswd_OK){
                        try {
                          // メール/パスワードでユーザー登録
                          _result = await auth.createUserWithEmailAndPassword(
                            email: _newEmail,
                            password: _newPassword,
                          );

                          // 登録成功
                          // 登録したユーザー情報
                          _user = _result.user;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(user_id: _user.uid, auth: auth),
                            )
                          );

                        } catch (e) {
                          // 登録に失敗した場合
                          setState(() {
                            _infoText = auth_error.register_error_msg(e.code);
                          });
                        }

                      }else{
                        setState(() {
                          _infoText = 'パスワードは8文字以上です。';
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
        ),
    );
  }
}