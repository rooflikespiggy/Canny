import 'package:Canny/Services/Category/category_database.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CategoryTile extends StatefulWidget {
  final String categoryName;
  final int categoryColorValue;
  final int categoryIconCodePoint;
  final String categoryId;

  CategoryTile({
    this.categoryName,
    this.categoryColorValue,
    this.categoryIconCodePoint,
    this.categoryId
  });

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {

  final _formKey = GlobalKey<FormState>();
  final CategoryDatabaseService _authCategory = CategoryDatabaseService();

  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    void _editCatPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
            padding: EdgeInsets.all(20),
            child: Form(
                key: _formKey,
                child: Column(
                    children: <Widget>[
                      Text(
                        'Update your category color',
                        style: TextStyle(
                            fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 260,
                        height: 260,
                        child: BlockPicker(
                          pickerColor: currentColor,
                          onColorChanged: changeColor,
                        ),
                      ),
                      SizedBox(
                          height: 10
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() => currentColor = pickerColor);
                          _authCategory.updateCategoryColor(
                              widget.categoryId,
                              currentColor);
                          Navigator.of(context).pop();
                        },
                        child: Text("Update",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: TextButton.styleFrom(
                            backgroundColor: kDeepOrangeLight
                        ),
                      ),
                    ]
                )
            )
        );
      });
    }
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      child: ListTile(
        contentPadding: EdgeInsets.all(10.0),
        title: Text(
          widget.categoryName,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[900],
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.deepOrange[50],
          radius: 30,
          child: IconTheme(
              data: IconThemeData(color: Color(widget.categoryColorValue).withOpacity(1), size: 25),
              child: Icon(IconData(widget.categoryIconCodePoint, fontFamily: 'MaterialIcons'))
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            _editCatPanel();
          },
        ),
      ),
    );
  }
}
