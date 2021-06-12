import 'package:Canny/Models/category.dart';
import 'package:Canny/Services/Category/category_database.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  CategoryDatabaseService _authCategory = CategoryDatabaseService();
  List<Category> filteredCategories = [];
  final format = DateFormat('d/M/y');
  DateTime earliest;
  DateTime latest;
  bool showIncomes = true;
  bool showExpenses = true;
  bool selected = false;


  Widget _getCategoriesChips() {
    return filteredCategories.isEmpty
        ? Text(
      "Tap to select Categories to filter by",
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
        fontStyle: FontStyle.italic,
      ),
    )
        : Wrap(
      spacing: 5,
      children: filteredCategories
          .map(
            (ctg) => InputChip(
          label: Text(ctg.categoryName),
          backgroundColor: ctg.categoryColor.withOpacity(0.6),
          onDeleted: () {
            setState(() {
              filteredCategories.remove(ctg);
            });
          },
        ),
      ).toList(),
    );
  }

  Widget _categoriesSelection() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        color: Colors.white.withOpacity(0.9),
        child: FutureBuilder<List<Category>>(
            future: _authCategory.getCategories(),
            builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
              if (snapshot.hasData) {
                List<Category> allCategories = snapshot.data;
                allCategories.sort((a, b) => a.categoryId.compareTo(b.categoryId));
                return GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            "Filter by categories:",
                            style: TextStyle(fontSize: 18,
                              color: kDarkBlue,
                              fontFamily: "Lato"
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        _getCategoriesChips(),
                        SizedBox(height: 10)
                      ],
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          List<Category> tempCtgs = filteredCategories;
                          return AlertDialog(
                            backgroundColor: kLightBlue,
                            actions: <Widget>[
                              TextButton(
                                child: Text("CANCEL"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: Text("APPLY"),
                                onPressed: () {
                                  setState(() {
                                    filteredCategories = List.of(tempCtgs);
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                            title: Text("Select Categories",
                              style: TextStyle(
                                color: kDarkBlue,
                                fontFamily: "Lato"
                            ),
                            ),
                            content: StatefulBuilder(
                              builder: (context, setState) {
                                return Wrap(
                                    spacing: 5,
                                    children: allCategories
                                        .map(
                                          (ctg) => InputChip(
                                          label: Text(ctg.categoryName),
                                          backgroundColor: tempCtgs.contains(ctg)
                                              ? ctg.categoryColor.withOpacity(0.6)
                                              : Colors.grey[300],
                                          onSelected: (value) {
                                            setState(() {
                                              if (!tempCtgs.contains(ctg)) {
                                                tempCtgs.add(ctg);
                                              } else {
                                                tempCtgs.remove(ctg);
                                              }
                                              tempCtgs.sort((a, b) => a.categoryId.compareTo(b.categoryId));
                                            });
                                          }),
                                    ).toList());
                              },
                            ),
                          );
                        });
                  },
                );
              }
              return SizedBox();
            }
        ),
      ),
    );
  }


  Widget _datesSelection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 2, 10, 10),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        color: Colors.white.withOpacity(0.9),
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text('Filter by Dates:',
              style: TextStyle(fontSize: 18,
                  color: kDarkBlue,
                  fontFamily: "Lato"
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: DateTimeField(
                    format: format,
                    decoration: InputDecoration(
                      labelText: "Date from:",
                      labelStyle: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic
                      ),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onShowPicker: (context, currentValue) async {
                      var date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(DateTime.now().year - 5),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 5),
                      );
                      if (date != null) {
                        earliest = date;
                      }
                      return date;
                    },
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: DateTimeField(
                    format: format,
                    decoration: InputDecoration(
                      labelText: "Date to:",
                      labelStyle: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic
                      ),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onShowPicker: (context, currentValue) async {
                      var date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(DateTime.now().year - 5),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 5),
                      );
                      if (date != null) {
                        latest = date;
                      } if (!date.isAfter(earliest)){
                        return latest = earliest;
                      }
                      return date;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            Navigator.pop(context, {
              'isActive': false,
              'filteredCategories': <Category>[],
              'earliest': DateTime(DateTime.now().year - 2),
            });
          },
        ),
        title: Text('Filter Screen'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (earliest != null || latest != null || filteredCategories.isNotEmpty ) {
                Navigator.pop(context, {
                  'isActive': true,
                  'filteredCategories': filteredCategories,
                  'earliest': earliest,
                  'latest': DateTime(
                    latest != null ? latest.year : DateTime.now().year,
                    latest != null ? latest.month : DateTime.now().month,
                    latest != null ? latest.day : DateTime.now().day,
                    23,
                    59,
                  ),
                });
              } else {
                Navigator.pop(context, {
                  'isActive': false,
                  'filteredCategories': <Category>[],
                  'earliest': DateTime(DateTime.now().year - 2),
                });
                Flushbar(
                  message: "No filter was set.",
                  icon: Icon(
                    Icons.info_outline,
                    size: 28.0,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  duration: Duration(seconds: 3),
                  leftBarIndicatorColor:
                  Theme.of(context).colorScheme.secondary,
                )..show(context);
              }
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("styles/images/background-2.png"),
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 10),
            _categoriesSelection(),
            _datesSelection(),
            SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }
}