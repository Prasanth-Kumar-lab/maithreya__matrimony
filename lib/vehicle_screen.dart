import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({Key? key}) : super(key: key);

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  final TextEditingController businessIdController =
  TextEditingController(text: "1");
  final TextEditingController catIdController = TextEditingController(text: "1");

  bool isLoading = false;
  String errorMessage = '';
  List<dynamic> vehicles = [];

  Future<void> fetchVehicles() async {
    final businessId = businessIdController.text.trim();
    final catId = catIdController.text.trim();

    if (businessId.isEmpty || catId.isEmpty) {
      setState(() {
        errorMessage = "Please enter both Business ID and Category ID.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
      vehicles.clear();
    });

    final uri = Uri.parse(
        'https://posapp.in/vehicle_management_system/vehicle_api_v1/list_vehicle_api.php?business_id=$businessId&cat_id=$catId');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          vehicles = data;
        });
      } else {
        setState(() {
          errorMessage = "Server error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching vehicles: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildVehicleCard(dynamic vehicle) {
    final imageUrl =
        'https://posapp.in/vehicle_management_system/vehicle_api_v1/${vehicle['image']}';

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.directions_car, size: 50)),
              ),
            ),
            const SizedBox(height: 8),
            Text(vehicle['name'] ?? 'Unknown Vehicle',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("Price: ₹${vehicle['price'] ?? '-'}"),
            Text("Model: ${vehicle['model'] ?? '-'}"),
            Text("Mileage: ${vehicle['mileage'] ?? '-'}"),
            Text("Location: ${vehicle['location'] ?? '-'}"),
            const SizedBox(height: 4),
            Text(vehicle['additional_info'] ?? '',
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget buildVehicleList() {
    if (vehicles.isEmpty) {
      return Center(
        child: Text(
          errorMessage.isNotEmpty ? errorMessage : "No vehicles to display.",
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: vehicles.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return buildVehicleCard(vehicles[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vehicle List")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: businessIdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Business ID",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: catIdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Category ID",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchVehicles,
              child: const Text("Fetch Vehicles"),
            ),
            const SizedBox(height: 16),
            if (isLoading) const CircularProgressIndicator(),
            const SizedBox(height: 16),
            buildVehicleList(),
          ],
        ),
      ),
    );
  }
}
/*
import 'package:flutter/material.dart';
class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('First Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(_createRoute());
          },
          child: Text('Go to Second Page'),
        ),
      ),
    );
  }
}
// Custom PageRoute with fade and bottom-left → top-right transition
Route _createRoute() {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 700),
    pageBuilder: (context, animation, secondaryAnimation) => SecondPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Define animation curve
      final curve = Curves.easeInOut;

      // Fade transition
      final opacityAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      // Slide from bottom-left to top-right
      final offsetAnimation = Tween<Offset>(
        begin: Offset(-1.0, 1.0), // bottom-left corner
        end: Offset.zero,         // center
      ).animate(CurvedAnimation(parent: animation, curve: curve));

      return FadeTransition(
        opacity: opacityAnimation,
        child: SlideTransition(
          position: offsetAnimation,
          child: child,
        ),
      );
    },
  );
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Second Page')),
      body: Center(child: Text('Hello from the second page!')),
    );
  }
}

 */