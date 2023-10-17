import 'package:flutter/material.dart';

class SurveypageWidget extends StatefulWidget {
  const SurveypageWidget({Key? key}) : super(key: key);

  @override
  _SurveypageWidgetState createState() => _SurveypageWidgetState();
}

class _SurveypageWidgetState extends State<SurveypageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController textFieldController = TextEditingController();
  double sliderValue = 5;

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.blue[200],
        appBar: AppBar(
          backgroundColor: Color(0xFFCBB189),
          automaticallyImplyLeading: true,
          title: Text(
            'Check-in Survey',
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
              child: IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: Color(0xFF1A1D2E),
                  size: 30,
                ),
                onPressed: () {
                  print('IconButton pressed ...');
                },
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 100, 0, 0),
                        child: Text(
                          'How satisfied are you with your goals?',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 44, 16, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset(
                              'lib/images/sadface.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              'lib/images/happyface.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              'lib/images/happier.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                      Slider(
                        activeColor: Color(0xFFBBAE61),
                        inactiveColor: Color(0xFFD6D6D6),
                        min: 0,
                        max: 10,
                        value: sliderValue,
                        onChanged: (newValue) {
                          setState(() => sliderValue = newValue);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              TextField(
                controller: textFieldController,
                decoration: InputDecoration(
                  hintText: 'Enter your thoughts here...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 32, 0, 32),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to another page or perform any action
                      },
                      child: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFBBAE61),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
