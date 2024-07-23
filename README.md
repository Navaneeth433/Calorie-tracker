import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const CalorieTrackerApp());
}

class CalorieTrackerApp extends StatelessWidget {
  const CalorieTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calorie Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DatabaseHelper _databaseHelper;
  List<Meal> _meals = [];
  double _totalCalories = 0;
  double _totalProtein = 0;
  double _totalCarbohydrates = 0;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper.instance;
    _loadSavedItems();
  }

  _loadSavedItems() async {
    List<Map<String, dynamic>> rows = await _databaseHelper.getAllMeals();
    setState(() {
      _meals = rows.map((row) => Meal.fromMap(row)).toList();
      _updateTotalValues();
    });
  }

  _updateTotalValues() {
    setState(() {
      _totalCalories = _meals.fold(
          0, (total, meal) => total + meal.foodItems.fold(0, (total, item) => total + item.calories));
      _totalProtein = _meals.fold(
          0, (total, meal) => total + meal.foodItems.fold(0, (total, item) => total + item.protein));
      _totalCarbohydrates = _meals.fold(
          0, (total, meal) => total + meal.foodItems.fold(0, (total, item) => total + item.carbohydrates));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calorie Tracker'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 16),
            Text(
              'Total Calories: $_totalCalories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Total Protein: $_totalProtein grams',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Total Carbohydrates: $_totalCarbohydrates grams',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PieChartScreen(
                    totalCalories: _totalCalories,
                    totalProtein: _totalProtein,
                    totalCarbohydrates: _totalCarbohydrates,
                  )),
                );
              },
              child: Text('Show Pie Chart'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _meals.length,
                itemBuilder: (context, index) {
                  final meal = _meals[index];
                  return MealItem(
                    meal: meal,
                    onDelete: () {
                      setState(() {
                        _deleteMeal(meal.id!);
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMealScreen()),
          );
          if (result != null && result is Meal) {
            setState(() {
              _addMeal(result);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _addMeal(Meal meal) async {
    int id = await _databaseHelper.insertMeal(meal.toMap());
    meal.id = id;
    setState(() {
      _meals.add(meal);
      _updateTotalValues();
    });
  }

  _deleteMeal(int id) async {
    await _databaseHelper.deleteMeal(id);
    setState(() {
      _meals.removeWhere((meal) => meal.id == id);
      _updateTotalValues();
    });
  }
}

class MealItem extends StatelessWidget {
  final Meal meal;
  final VoidCallback onDelete;

  MealItem({required this.meal, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              meal.name,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: meal.foodItems.length,
            itemBuilder: (context, index) {
              final foodItem = meal.foodItems[index];
              return ListTile(
                title: Text(foodItem.name),
                subtitle: Text('${foodItem.calories} calories'),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total Calories: ${meal.getTotalCalories()}',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(width: 16.0),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddMealScreen extends StatefulWidget {
  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  String? _selectedMealType;
  List<FoodItem> _selectedFoodItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Meal'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedMealType,
              onChanged: (newValue) {
                setState(() {
                  _selectedMealType = newValue;
                });
              },
              items: <String>['DINNER', 'LUNCH', 'SNACKS', 'BREAKFAST'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Select Meal Type'),
            ),
            SizedBox(height: 16.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _selectedFoodItems.length,
              itemBuilder: (context, index) {
                final foodItem = _selectedFoodItems[index];
                return ListTile(
                  title: Text(foodItem.name),
                  subtitle: Text('${foodItem.calories} calories'),
                );
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddFoodScreen()),
                );
                if (result != null && result is FoodItem) {
                  setState(() {
                    _selectedFoodItems.add(result);
                  });
                }
              },
              child: Text('Add Food'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveMeal(context);
              },
              child: Text('Save Meal'),
            ),
          ],
        ),
      ),
    );
  }

  _saveMeal(BuildContext context) {
    if (_selectedMealType != null && _selectedFoodItems.isNotEmpty) {
      Meal meal = Meal(name: _selectedMealType!, foodItems: _selectedFoodItems);
      Navigator.pop(context, meal);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select meal type and add food items.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

class AddFoodScreen extends StatefulWidget {
  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbohydratesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Food'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Food Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _caloriesController,
              decoration: InputDecoration(labelText: 'Calories'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _proteinController,
              decoration: InputDecoration(labelText: 'Protein (g)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _carbohydratesController,
              decoration: InputDecoration(labelText: 'Carbohydrates (g)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveFoodItem(context);
              },
              child: Text('Save Food'),
            ),
          ],
        ),
      ),
    );
  }

  _saveFoodItem(BuildContext context) {
    if (_nameController.text.isNotEmpty &&
        _caloriesController.text.isNotEmpty &&
        _proteinController.text.isNotEmpty &&
        _carbohydratesController.text.isNotEmpty) {
      FoodItem foodItem = FoodItem(
        name: _nameController.text,
        calories: double.parse(_caloriesController.text),
        protein: double.parse(_proteinController.text),
        carbohydrates: double.parse(_carbohydratesController.text),
      );
      Navigator.pop(context, foodItem);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

class PieChartScreen extends StatelessWidget {
  final double totalCalories;
  final double totalProtein;
  final double totalCarbohydrates;

  PieChartScreen({
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbohydrates,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pie Chart'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.blue,
                      value: totalCalories,
                      title: '${totalCalories.toInt()}',
                    ),
                    PieChartSectionData(
                      color: Colors.red,
                      value: totalProtein,
                      title: '${totalProtein.toInt()}',
                    ),
                    PieChartSectionData(
                      color: Colors.green,
                      value: totalCarbohydrates,
                      title: '${totalCarbohydrates.toInt()}',
                    ),
                  ],
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'calorie_tracker.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE meals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        food_items TEXT
      )
    ''');
  }

  Future<int> insertMeal(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('meals', row);
  }

  Future<List<Map<String, dynamic>>> getAllMeals() async {
    Database db = await instance.database;
    return await db.query('meals');
  }

  Future<int> deleteMeal(int id) async {
    Database db = await instance.database;
    return await db.delete('meals', where: 'id = ?', whereArgs: [id]);
  }
}

class Meal {
  int? id;
  String name;
  List<FoodItem> foodItems;

  Meal({this.id, required this.name, required this.foodItems});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'food_items': jsonEncode(foodItems.map((item) => item.toMap()).toList()), // Serialize here
    };
  }

  Meal.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        foodItems = List<FoodItem>.from(jsonDecode(map['food_items']).map((x) => FoodItem.fromMap(x))); // Deserialize here

  double getTotalCalories() {
    return foodItems.fold(0, (total, item) => total + item.calories);
  }
}

class FoodItem {
  String name;
  double calories;
  double protein;
  double carbohydrates;

  FoodItem({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbohydrates,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbohydrates': carbohydrates,
    };
  }

  FoodItem.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        calories = map['calories'],
        protein = map['protein'],
        carbohydrates = map['carbohydrates'];
}
