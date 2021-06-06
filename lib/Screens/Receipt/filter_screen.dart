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
  List<MultiSelectItem<Category>> _allCategories;
  final format = DateFormat('d/M/y');
  DateTime earliest;
  DateTime latest;
  bool showIncomes = true;
  bool showExpenses = true;
  bool selected = false;


  Widget _getCategoriesChips() {
    return filteredCategories.isEmpty
        ? Text(
      "Tap to select categories",
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey,
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
      )
          .toList(),
    );
  }

  Widget _categoriesSelection() {
    return FutureBuilder<List<Category>>(
        future: _authCategory.getCategories(),
        builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
          if (snapshot.hasData) {
            List<Category> allCategories = snapshot.data;
            return GestureDetector(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        "Filter by categories:",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    _getCategoriesChips(),
                  ],
                ),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      List<Category> tempCtgs = filteredCategories;
                      return AlertDialog(
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
                        title: Text("Select categories"),
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
                                          : Colors.grey,
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
    );
  }


  Widget _datesSelection() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DateTimeField(
              format: format,
              decoration: InputDecoration(
                labelText: "Date from:",
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
                }
                return date;
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            Navigator.pop(context, {
              'isActive': false,
              'filteredCategories': <Category>[],
              'earliest': DateTime(DateTime.now().year - 2),
              'latest': DateTime.now(),
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
                  'latest': DateTime.now(),
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
                ).show(context);
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _categoriesSelection(),
          _datesSelection(),
        ],
      ),
    );
  }
}