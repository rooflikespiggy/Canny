import 'package:Canny/Shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:Canny/Shared/input_formatters.dart';
import 'package:flutter/services.dart';

class AddTEScreen extends StatefulWidget {
  static final String id = 'add_te_screen';

  @override
  _AddTEScreenState createState() => _AddTEScreenState();
}

class _AddTEScreenState extends State<AddTEScreen> {

  final TextEditingController targetedExpensesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget> [
                Container(
                    decoration: BoxDecoration(
                      color: kLightBlue,
                      borderRadius:
                      BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Column(
                        children: <Widget> [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget> [
                              SizedBox(width: 20.0),
                              Text('Add A New Targeted Expenditure',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "Lato",
                                    color: kDarkBlue
                                ),
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () {
                                  targetedExpensesController.clear();
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.clear),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                              alignment: Alignment.topCenter,
                              child: Form(
                                key: _formKey,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: _showTextFormFields(targetedExpensesController,
                                    "Targeted Expenditure",
                                    Icon(Icons.track_changes_rounded),
                                    390.0,
                                  ),
                                ),
                              )
                          ),
                          SizedBox(height: 10,),
                          TextButton(
                            onPressed: () async {
                              print(targetedExpensesController.text);
                            },
                            child: Text('Submit',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: kDarkBlue,
                              minimumSize: Size(350, 40),
                            ),
                          ),
                          SizedBox(height: 20,),
                        ]
                    )
                )
              ]
          )
      ),
    );

    /*
      Scaffold(
      appBar: AppBar(
        title: Text("Add Targeted Expenditure"),
        titleTextStyle: TextStyle(fontFamily: 'Lato'),
      ),
      backgroundColor: Colors.brown[50],
      body: Center(
        child: Text('Add Targeted Expenditure'),
      ),
    );
     */
  }

  Widget _showTextFormFields(TextEditingController text, String label, Icon icon, double size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: size,
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: text,
          inputFormatters: [
            DecimalTextInputFormatter(decimalRange: 2),
            //DecimalPointTextInputFormatter(),
            LengthLimitingTextInputFormatter(8),
          ],
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: icon,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          // The validator receives the text that the user has entered.
          validator: (value) {
            if (value.isEmpty) {
              return label;
            }
            return null;
          },
        ),
      ),
    );
  }
}