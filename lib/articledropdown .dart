import 'package:daraweb/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArticlleDropdownWidget extends StatefulWidget {
  //final Function(String?) onItemSelected;

  //ArticlleDropdownWidget({Key? key, required this.onItemSelected})
  //    : super(key: key);

  @override
  State<ArticlleDropdownWidget> createState() => _ArticlleDropdownWidgetState();
}

class _ArticlleDropdownWidgetState extends State<ArticlleDropdownWidget> {
  String? _selectedItem;
  //final List<String> _items = ['Item 1', 'Item 2', 'Item 3'];

  // Map containing category keys and their display values
  final Map<String, String> categories = {
    "agriculture": "Agriculture",
    "health": "Health",
    "climate": "Climate",
    "law & order": "Law & Order",
    "society": "Society",
    "education": "Education",
    "politics": "Politics",
  };

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      // Set the initial selected value (optional)
      value: _selectedItem,

      // Generate DropdownMenuItems from the categories map
      items: categories.entries
          .map((entry) => DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value),
              ))
          .toList(),

      // Callback function to handle selection changes
      onChanged: (String? newValue) {
        setState(() {
          _selectedItem = newValue;
        });
        //print(newValue);
        context.read<PostProvider>().fetchpostbasedoncategory(newValue!);
        // context.read<PostProvider>().changecategory(newValue!);
        String newcate = newValue;
        String newcat = context.read<PostProvider>().changecategory(newcate);
        print(newcat);
        //print(newcat);
        // Usage (Assuming newValue is String)

// Optional: Get the updated category after change
        //print(x);
        //context.read<PostProvider>().changecategory(newcat:)
      },

      // Hint text to display when nothing is selected (optional)
      hint: const Text('Article Categories'),

      // Dropdown button text style (optional)
      // dropdownTextStyle: const TextStyle(color: Colors.black),

      // Icon displayed next to the button (optional)
      icon: const Icon(Icons.arrow_drop_down),

      // Additional customization options (refer to DropdownButton documentation)
    );
  }
}
