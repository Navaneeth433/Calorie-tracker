// // import 'package:flutter/material.dart';
// //
// // void main() {
// //   runApp(CalorieTrackerApp());
// // }
// //
// // class CalorieTrackerApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Calorie Tracker',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: HomeScreen(),
// //     );
// //   }
// // }
// //
// // class HomeScreen extends StatefulWidget {
// //   @override
// //   _HomeScreenState createState() => _HomeScreenState();
// // }
// //
// // class _HomeScreenState extends State<HomeScreen> {
// //   List<FoodItem> _foodItems = []; // List to store food items
// //   double _totalCalories = 0; // Total calories consumed
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Calorie Tracker'),
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             Text(
// //               'Total Calories: $_totalCalories',
// //               style: TextStyle(fontSize: 20),
// //             ),
// //             SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: () {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (context) => AddFoodScreen(
// //                       onFoodAdded: (foodItem) {
// //                         setState(() {
// //                           _foodItems.add(foodItem);
// //                           _totalCalories += foodItem.calories;
// //                         });
// //                       },
// //                     ),
// //                   ),
// //                 );
// //               },
// //               child: Text('Add Food'),
// //             ),
// //             SizedBox(height: 20),
// //             Expanded(
// //               child: ListView.builder(
// //                 itemCount: _foodItems.length,
// //                 itemBuilder: (context, index) {
// //                   return ListTile(
// //                     title: Text(_foodItems[index].name),
// //                     subtitle: Text(
// //                         '${_foodItems[index].calories.toString()} calories'),
// //                   );
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class AddFoodScreen extends StatefulWidget {
// //   final Function(FoodItem) onFoodAdded;
// //
// //   AddFoodScreen({required this.onFoodAdded});
// //
// //   @override
// //   _AddFoodScreenState createState() => _AddFoodScreenState();
// // }
// //
// // class _AddFoodScreenState extends State<AddFoodScreen> {
// //   late TextEditingController _nameController;
// //   late TextEditingController _caloriesController;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _nameController = TextEditingController();
// //     _caloriesController = TextEditingController();
// //   }
// //
// //   @override
// //   void dispose() {
// //     _nameController.dispose();
// //     _caloriesController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Add Food'),
// //       ),
// //       body: Padding(
// //         padding: EdgeInsets.all(20),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: <Widget>[
// //             TextField(
// //               controller: _nameController,
// //               decoration: InputDecoration(labelText: 'Food Name'),
// //             ),
// //             TextField(
// //               controller: _caloriesController,
// //               decoration: InputDecoration(labelText: 'Calories'),
// //               keyboardType: TextInputType.number,
// //             ),
// //             SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: () {
// //                 String name = _nameController.text;
// //                 double calories = double.tryParse(_caloriesController.text) ?? 0;
// //                 FoodItem foodItem = FoodItem(name: name, calories: calories);
// //                 widget.onFoodAdded(foodItem);
// //                 Navigator.pop(context);
// //               },
// //               child: Text('Save'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class FoodItem {
// //   final String name;
// //   final double calories;
// //
// //   FoodItem({required this.name, required this.calories});
// // }
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// void main() {
//   runApp(CalorieTrackerApp());
// }
//
// class CalorieTrackerApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Calorie Tracker',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   List<FoodItem> _foodItems = [];
//   double _totalCalories = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSavedItems();
//   }
//
//   _loadSavedItems() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _foodItems = FoodItem.decodeItems(prefs.getStringList('foodItems') ?? []);
//       _updateTotalCalories();
//     });
//   }
//
//   _updateTotalCalories() {
//     _totalCalories = _foodItems.fold(0, (total, item) => total + item.calories);
//   }
//
//   _saveItems() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> encodedItems = _foodItems.map((item) => item.encode()).toList();
//     prefs.setStringList('foodItems', encodedItems);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Calorie Tracker'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Total Calories: $_totalCalories',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final result = await Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => AddFoodScreen()),
//                 );
//                 if (result != null && result is FoodItem) {
//                   setState(() {
//                     _foodItems.add(result);
//                     _totalCalories += result.calories;
//                     _saveItems();
//                   });
//                 }
//               },
//               child: Text('Add Food'),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _foodItems.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(_foodItems[index].name),
//                     subtitle: Text('${_foodItems[index].calories.toString()} calories'),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class AddFoodScreen extends StatelessWidget {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _caloriesController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Food'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: 'Food Name'),
//             ),
//             TextField(
//               controller: _caloriesController,
//               decoration: InputDecoration(labelText: 'Calories'),
//               keyboardType: TextInputType.number,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 String name = _nameController.text;
//                 double calories = double.tryParse(_caloriesController.text) ?? 0;
//                 FoodItem foodItem = FoodItem(name: name, calories: calories);
//                 Navigator.pop(context, foodItem);
//               },
//               child: Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class FoodItem {
//   final String name;
//   final double calories;
//
//   FoodItem({required this.name, required this.calories});
//
//   String encode() {
//     return '$name;$calories';
//   }
//
//   static List<FoodItem> decodeItems(List<String> encodedItems) {
//     return encodedItems.map((item) {
//       List<String> parts = item.split(';');
//       return FoodItem(name: parts[0], calories: double.parse(parts[1]));
//     }).toList();
//   }
// }
// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // void main() {
// //   runApp(CalorieTrackerApp());
// // }
// //
// // class CalorieTrackerApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Calorie Tracker',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //         visualDensity: VisualDensity.adaptivePlatformDensity,
// //       ),
// //       home: HomeScreen(),
// //     );
// //   }
// // }
// //
// // class HomeScreen extends StatefulWidget {
// //   @override
// //   _HomeScreenState createState() => _HomeScreenState();
// // }
// //
// // class _HomeScreenState extends State<HomeScreen> {
// //   List<FoodItem> _foodItems = [];
// //   double _totalCalories = 0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadSavedItems();
// //   }
// //
// //   _loadSavedItems() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       _foodItems = FoodItem.decodeItems(prefs.getStringList('foodItems') ?? []);
// //       _updateTotalCalories();
// //     });
// //   }
// //
// //   _updateTotalCalories() {
// //     setState(() {
// //       _totalCalories = _foodItems.fold(0, (total, item) => total + item.calories);
// //     });
// //   }
// //
// //   _saveItems() async {
// //     SharedPreferences prefs = await SharedPreferences.getInstance();
// //     List<String> encodedItems = _foodItems.map((item) => item.encode()).toList();
// //     prefs.setStringList('foodItems', encodedItems);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Calorie Tracker'),
// //       ),
// //       body: Column(
// //         crossAxisAlignment: CrossAxisAlignment.stretch,
// //         children: <Widget>[
// //           Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Text(
// //               'Total Calories: $_totalCalories',
// //               style: GoogleFonts.podkova(fontSize: 24, fontWeight: FontWeight.bold),
// //             ),
// //           ),
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: _foodItems.length,
// //               itemBuilder: (context, index) {
// //                 return FoodListItem(
// //                   foodItem: _foodItems[index],
// //                   onDelete: () {
// //                     setState(() {
// //                       _totalCalories -= _foodItems[index].calories;
// //                       _foodItems.removeAt(index);
// //                       _saveItems();
// //                     });
// //                   },
// //                 );
// //               },
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: ElevatedButton(
// //               onPressed: () async {
// //                 final result = await Navigator.push(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => AddFoodScreen()),
// //                 );
// //                 if (result != null && result is FoodItem) {
// //                   setState(() {
// //                     _foodItems.add(result);
// //                     _totalCalories += result.calories;
// //                     _saveItems();
// //                   });
// //                 }
// //               },
// //               style: ElevatedButton.styleFrom(
// //                 foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
// //                 padding: EdgeInsets.symmetric(vertical: 16),
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //               ),
// //               child: Text('Add Food'),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // class FoodListItem extends StatelessWidget {
// //   final FoodItem foodItem;
// //   final VoidCallback onDelete;
// //
// //   const FoodListItem({Key? key, required this.foodItem, required this.onDelete}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Card(
// //       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //       child: ListTile(
// //         title: Text(foodItem.name),
// //         subtitle: Text('${foodItem.calories} calories'),
// //         trailing: IconButton(
// //           icon: Icon(Icons.delete),
// //           onPressed: onDelete,
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class AddFoodScreen extends StatefulWidget {
// //   @override
// //   _AddFoodScreenState createState() => _AddFoodScreenState();
// // }
// //
// // class _AddFoodScreenState extends State<AddFoodScreen> {
// //   final TextEditingController _nameController = TextEditingController();
// //   final TextEditingController _caloriesController = TextEditingController();
// //   String? _nameError;
// //   String? _caloriesError;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Add Food'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: <Widget>[
// //             TextField(
// //               controller: _nameController,
// //               decoration: InputDecoration(
// //                 labelText: 'Food Name',
// //                 errorText: _nameError,
// //               ),
// //             ),
// //             SizedBox(height: 16),
// //             TextField(
// //               controller: _caloriesController,
// //               decoration: InputDecoration(
// //                 labelText: 'Calories',
// //                 errorText: _caloriesError,
// //               ),
// //               keyboardType: TextInputType.number,
// //             ),
// //             SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: () {
// //                 _validateInput();
// //               },
// //               style: ElevatedButton.styleFrom(
// //                 foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
// //                 padding: EdgeInsets.symmetric(vertical: 16),
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //               ),
// //               child: Text('Save'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void _validateInput() {
// //     setState(() {
// //       _nameError = _nameController.text.isEmpty ? 'Please enter food name' : null;
// //       _caloriesError = _caloriesController.text.isEmpty ? 'Please enter calories' : null;
// //     });
// //
// //     if (_nameError == null && _caloriesError == null) {
// //       _saveFoodItem();
// //     }
// //   }
// //
// //   void _saveFoodItem() {
// //     String name = _nameController.text;
// //     double calories = double.parse(_caloriesController.text);
// //     FoodItem foodItem = FoodItem(name: name, calories: calories);
// //     Navigator.pop(context, foodItem);
// //   }
// // }
// //
// // class FoodItem {
// //   final String name;
// //   final double calories;
// //
// //   FoodItem({required this.name, required this.calories});
// //
// //   String encode() {
// //     return '$name;$calories';
// //   }
// //
// //   static List<FoodItem> decodeItems(List<String> encodedItems) {
// //     return encodedItems.map((item) {
// //       List<String> parts = item.split(';');
// //       return FoodItem(name: parts[0], calories: double.parse(parts[1]));
// //     }).toList();
// //   }
// // }