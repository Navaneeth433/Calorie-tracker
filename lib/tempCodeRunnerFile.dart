//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
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
//       debugShowCheckedModeBanner: false,
//       title: 'Calorie Tracker',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
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
//     setState(() {
//       _totalCalories = _foodItems.fold(0, (total, item) => total + item.calories);
//     });
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
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//         backgroundColor: Colors.transparent,
//         title: Text('Calorie Tracker',style:
//         GoogleFonts.podkova(),),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/image/baackground.jpg"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             SizedBox(
//               height: 60,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 'Total Calories: $_totalCalories',
//                 style: GoogleFonts.podkova(fontSize: 24, fontWeight: FontWeight.w600),
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _foodItems.length,
//                 itemBuilder: (context, index) {
//                   return FoodListItem(
//                     foodItem: _foodItems[index],
//                     onDelete: () {
//                       setState(() {
//                         _totalCalories -= _foodItems[index].calories;
//                         _foodItems.removeAt(index);
//                         _saveItems();
//                       });
//                     },
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ElevatedButton(
//                 onPressed: () async {
//                   final result = await Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => AddFoodScreen()),
//                   );
//                   if (result != null && result is FoodItem) {
//                     setState(() {
//                       _foodItems.add(result);
//                       _totalCalories += result.calories;
//                       _saveItems();
//                     });
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.blueAccent,
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text('Add Food',style:
//                     GoogleFonts.podkova(),),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class FoodListItem extends StatelessWidget {
//   final FoodItem foodItem;
//   final VoidCallback onDelete;
//
//   const FoodListItem({Key? key, required this.foodItem, required this.onDelete}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: ListTile(
//         title: Text(foodItem.name,style:
//             GoogleFonts.podkova(),),
//         subtitle: Text('${foodItem.calories} calories',style:
//             GoogleFonts.podkova(),),
//         trailing: IconButton(
//           icon: Icon(Icons.delete),
//           onPressed: onDelete,
//         ),
//       ),
//     );
//   }
// }
//
// class AddFoodScreen extends StatefulWidget {
//   @override
//   _AddFoodScreenState createState() => _AddFoodScreenState();
// }
//
// class _AddFoodScreenState extends State<AddFoodScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _caloriesController = TextEditingController();
//   String? _nameError;
//   String? _caloriesError;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(scrolledUnderElevation: 0,
//         backgroundColor: Colors.transparent,
//         title: Text('Add Food',style:
//         GoogleFonts.podkova(),),
//       ),
//       resizeToAvoidBottomInset: false,
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/image/baackground.jpg"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               SizedBox(
//                 height: 100,
//               ),
//               TextField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: 'Food Name',
//                   errorText: _nameError,
//                 ),
//               ),
//               SizedBox(height: 16),
//               TextField(
//                 controller: _caloriesController,
//                 decoration: InputDecoration(
//                   labelText: 'Calories',
//                   errorText: _caloriesError,
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   _validateInput();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.blueAccent,
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text('Save',style:
//                 GoogleFonts.podkova(),),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _validateInput() {
//     setState(() {
//       _nameError = _nameController.text.isEmpty ? 'Please enter food name' : null;
//       _caloriesError = _caloriesController.text.isEmpty ? 'Please enter calories' : null;
//     });
//
//     if (_nameError == null && _caloriesError == null) {
//       _saveFoodItem();
//     }
//   }
//
//   void _saveFoodItem() {
//     String name = _nameController.text;
//     double calories = double.parse(_caloriesController.text);
//     FoodItem foodItem = FoodItem(name: name, calories: calories);
//     Navigator.pop(context, foodItem);
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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const CalorieTrackerApp());
}

class CalorieTrackerApp extends StatelessWidget {
  const CalorieTrackerApp({super.key});

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
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FoodItem> _foodItems = [];
  double _totalCalories = 0;

  @override
  void initState() {
    super.initState();
    _loadSavedItems();
  }

  _loadSavedItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _foodItems = FoodItem.decodeItems(prefs.getStringList('foodItems') ?? []);
      _updateTotalCalories();
    });
  }

  _updateTotalCalories() {
    setState(() {
      _totalCalories = _foodItems.fold(0, (total, item) => total + item.calories);
    });
  }

  _saveItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedItems = _foodItems.map((item) => item.encode()).toList();
    prefs.setStringList('foodItems', encodedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Calorie Tracker',
          style: GoogleFonts.podkova(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/baackground.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total Calories: $_totalCalories',
                style: GoogleFonts.podkova(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _foodItems.length,
                itemBuilder: (context, index) {
                  return FoodListItem(
                    foodItem: _foodItems[index],
                    onDelete: () {
                      setState(() {
                        _totalCalories -= _foodItems[index].calories;
                        _foodItems.removeAt(index);
                        _saveItems();
                      });
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddFoodScreen()),
                  );
                  if (result != null && result is FoodItem) {
                    setState(() {
                      _foodItems.add(result);
                      _totalCalories += result.calories;
                      _saveItems();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Add Food',
                  style: GoogleFonts.podkova(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class FoodListItem extends StatelessWidget {
  final FoodItem foodItem;
  final VoidCallback onDelete;
  final List<List<Color>> gradientColors = [
    [Colors.red.withOpacity(0.5), Colors.red.withOpacity(0.2)],
    [Colors.green.withOpacity(0.5), Colors.green.withOpacity(0.2)],
    [Colors.orange.withOpacity(0.5), Colors.orange.withOpacity(0.2)],
    [Colors.purple.withOpacity(0.5), Colors.purple.withOpacity(0.2)],
    [Colors.teal.withOpacity(0.5), Colors.teal.withOpacity(0.2)],
  ];

  FoodListItem({Key? key, required this.foodItem, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int colorIndex = foodItem.hashCode % gradientColors.length;
    final List<Color> tileGradientColors = gradientColors[colorIndex];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: tileGradientColors,
        ),
      ),
      child: ListTile(
        title: Text(
          foodItem.name,
          style: GoogleFonts.podkova(),
        ),
        subtitle: Text(
          '${foodItem.calories} calories',
          style: GoogleFonts.podkova(),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}


class AddFoodScreen extends StatefulWidget {
  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  String? _nameError;
  String? _caloriesError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Add Food',
          style: GoogleFonts.podkova(),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/baackground.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 100,
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Food Name',
                  errorText: _nameError,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _caloriesController,
                decoration: InputDecoration(
                  labelText: 'Calories',
                  errorText: _caloriesError,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _validateInput();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Save',
                  style: GoogleFonts.podkova(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateInput() {
    setState(() {
      _nameError = _nameController.text.isEmpty ? 'Please enter food name' : null;
      _caloriesError = _caloriesController.text.isEmpty ? 'Please enter calories' : null;
    });

    if (_nameError == null && _caloriesError == null) {
      _saveFoodItem();
    }
  }

  void _saveFoodItem() {
    String name = _nameController.text;
    double calories = double.parse(_caloriesController.text);
    FoodItem foodItem = FoodItem(name: name, calories: calories);
    Navigator.pop(context, foodItem);
  }
}

class FoodItem {
  final String name;
  final double calories;

  FoodItem({required this.name, required this.calories});

  String encode() {
    return '$name;$calories';
  }

  static List<FoodItem> decodeItems(List<String> encodedItems) {
    return encodedItems.map((item) {
      List<String> parts = item.split(';');
      return FoodItem(name: parts[0], calories: double.parse(parts[1]));
    }).toList();
  }
}
