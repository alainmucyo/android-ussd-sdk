import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ussd_sdk/primary_button.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

import 'input_widget.dart';
import 'utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BasePay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.green,
        accentColor: CustomColor.PRIMARY,
        hintColor: Colors.grey[400],
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: CustomColor.DARK_GREY,
              displayColor: CustomColor.DARK_GREY,
            ),
      ),
      home: const MyHomePage(title: 'Pay BasePay merchant'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _controller;
  static const _platform = MethodChannel('alainmucyo.dev/permissions');
  static const _eventChannel = EventChannel('alainmucyo.dev/events');

  var _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {"code": "", "amount": "", "pin": ""};

  Stream<dynamic> _eventsStream = const Stream.empty();

  // ..text = "123456";

  // ignore: close_sinks
  late StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  List<String> _ussdResponses = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) return;
    _ussdResponses = [];
    Navigator.pop(context);
    _formKey.currentState?.save();
    sendNormalUssdRequest();
    listenToEvents();
  }

  _confirmPayment() async {
    var _completed = _ussdResponses
        .where((element) => element.contains("Merchant : "))
        .toList();
    var _textArr = _completed[0].split(" ");
    var firstIndex = _textArr.indexOf(":");
    var name=_textArr[firstIndex+1]+" "+_textArr[firstIndex+2];

    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Confirm payment"),
            content: Text("Confirm payment to merchant $name"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await UssdAdvanced.sendUssd(
                        code: "*182*7*1*1*${_formData['pin']}#",
                        subscriptionId: 1);
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: CustomColor.PRIMARY),
                  )),
            ],
          );
        });
  }

  sendNormalUssdRequest() async {
    // final String result =
    // context.loaderOverlay.show();
    await _platform.invokeMethod('myMethod');
    print("*726*${_formData['code']}*${_formData['amount']}#");
    await UssdAdvanced.sendUssd(
        code: "*726*${_formData['code']}*${_formData['amount']}#",
        subscriptionId: 1);
  }

  /* void onEventChannelStreams() {
    _eventChannel
        .receiveBroadcastStream()
        .listen((event) {
      print("Received event ${event}");
    });
  }*/

  _paymentCompleted() {
    var _completed = _ussdResponses
        .where((element) => element.contains("Sender Response sent "));
    print("Payment completed: $_completed");
    if (_completed.toList().isNotEmpty) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text("Payment completed"),
              content: const Text("Payment completed successfully"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Okay"))
              ],
            );
          });
    }
  }

  listenToEvents() {
    print("Listening...");

    _eventChannel.receiveBroadcastStream().listen((event) {
      print("Received something: $event");
      _ussdResponses.add(event);
      _paymentCompleted();
      if (event.toString().contains("Kwemeza kubikuza kashi")) {
        print("Confirming payment");
        _confirmPayment();
      }
      print(_ussdResponses);
      // return event;
    });
    // _streamSubscription.
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: CustomColor.PRIMARY,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Container(
                    height: (MediaQuery.of(context).size.height / 10) + 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Center(
                          child: Text(
                            "BasePay",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Center(
                          child: Text(
                            "Pay BasePay Merchant!",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                letterSpacing: 1),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      width: double.infinity,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("assets/images/oltranz.png"),
                                const SizedBox(height: 20),
                                const Text(
                                  'Please, fill the form below to pay to Opay merchant!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(height: 20),
                                InputWidget(
                                  label: "Merchant Code",
                                  inputType: TextInputType.number,
                                  validator: (value) {
                                    if (value != null && value.isEmpty) {
                                      return 'Code can\'t be empty!';
                                    }
                                    return null;
                                  },
                                  onSaved: (val) {
                                    _formData["code"] = val;
                                  },
                                ),
                                SizedBox(height: 16),
                                InputWidget(
                                  label: "Amount ",
                                  inputType: TextInputType.number,
                                  validator: (value) {
                                    if (value != null && value.isEmpty) {
                                      return 'Amount can\'t be empty!';
                                    }
                                    return null;
                                  },
                                  onSaved: (val) {
                                    _formData["amount"] = val;
                                  },
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: PrimaryButton(
                                      text: "PAY NOW!",
                                      onPressed: () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(20),
                                              ),
                                            ),
                                            builder: (_) {
                                              return SingleChildScrollView(
                                                padding: EdgeInsets.only(
                                                  top: 20,
                                                  left: 20,
                                                  right: 20,
                                                  bottom: MediaQuery.of(context)
                                                          .viewInsets
                                                          .bottom +
                                                      20,
                                                ),
                                                child: Column(
                                                  children: [
                                                    const Text(
                                                      "Enter mobile money PIN!",
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    SizedBox(height: 20),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: const [
                                                        Icon(
                                                          Icons.lock_outline,
                                                          size: 18,
                                                          color: CustomColor
                                                              .DARK_GREY,
                                                        ),
                                                        Text(
                                                            " Private and secure")
                                                      ],
                                                    ),
                                                    SizedBox(height: 10),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 25),
                                                      child: Column(
                                                        children: [
                                                          PinCodeTextField(
                                                            length: 5,
                                                            obscureText: true,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            animationType:
                                                                AnimationType
                                                                    .fade,
                                                            pinTheme: PinTheme(
                                                              shape:
                                                                  PinCodeFieldShape
                                                                      .box,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                              fieldHeight: 45,
                                                              fieldWidth: 45,
                                                              selectedColor:
                                                                  Colors.blue,
                                                              activeFillColor:
                                                                  Colors.white,
                                                            ),
                                                            animationDuration:
                                                                Duration(
                                                              milliseconds: 300,
                                                            ),
                                                            onSaved: (val) {
                                                              print(
                                                                  "Saved: $val");
                                                            },
                                                            enableActiveFill:
                                                                true,
                                                            // errorAnimationController: errorController,
                                                            /*    controller:
                                                                _pinEditingController,*/
                                                            onCompleted: (v) {
                                                              _formData["pin"] =
                                                                  v;
                                                            },
                                                            onChanged: (value) {
                                                              setState(() {
                                                                currentText =
                                                                    value;
                                                              });
                                                            },
                                                            beforeTextPaste:
                                                                (text) {
                                                              print(
                                                                  "Allowing to paste $text");
                                                              return true;
                                                            },
                                                            appContext: context,
                                                          ),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              FlatButton(
                                                                onPressed: () =>
                                                                    {
                                                                  Navigator.pop(
                                                                      context)
                                                                },
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 7,
                                                                    horizontal:
                                                                        15),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child:
                                                                    const Text(
                                                                  "Cancel",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontSize:
                                                                          17,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                color: Colors
                                                                    .red[100],
                                                              ),
                                                              FlatButton(
                                                                onPressed:
                                                                    _submitForm,
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 7,
                                                                    horizontal:
                                                                        15),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child:
                                                                    const Text(
                                                                  "Pay",
                                                                  style: TextStyle(
                                                                      color: CustomColor
                                                                          .LIGHT_GREY_2,
                                                                      fontSize:
                                                                          17,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                color:
                                                                    CustomColor
                                                                        .PRIMARY,
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                        // print(_phoneNumberInput.text);
                                        // sendMoney(_phoneNumberInput.text, _amountInput.text);
                                      }),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
