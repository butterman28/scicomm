import 'package:flutter/material.dart';

class DropdownWidget extends StatefulWidget {
  const DropdownWidget({super.key});

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String? _selectedItem;
  final List<String> _items = ['Item 1', 'Item 2', 'Item 3'];
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
    return DropdownMenu<String>(
        dropdownMenuEntries: <DropdownMenuEntry<String>>[
          categories.map(DropdownMenuEntry(value: categories.values, label: categories.keys))
        ]);
  }
}


leading: post.base64Image != null
                                  ? Container(
                                      width: screenWidth * 0.15,
                                      height: screenHeight * 0.15,
                                      child: Image.memory(
                                        base64Decode(post
                                            .base64Image!), // Decode base64 image
                                        width: 50, // Adjust width as needed
                                        height: 50, // Adjust height as needed
                                        //fit: BoxFit.cover,
                                      ),
                                    )
                                  : SizedBox.shrink(),


leading: post.base64Image != null
                                  ? Image.memory(
                                      base64Decode(post
                                          .base64Image!), // Decode base64 image
                                      width: 50, // Adjust width as needed
                                      height: 50, // Adjust height as needed
                                      fit: BoxFit.cover,
                                    )
                                  : SizedBox.shrink(),

                                   crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(post.content),
                              SizedBox(height: 8),
                              
                              SizedBox(height: 4),
                              Text('Comments: ${post.comments.length}'),
                            ],
                          ),


                          hint: Text('Select an item'),
      onChanged: (String? newValue) {
        setState(() {
          _selectedItem = newValue;
        });
      },
      items: _items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );


    DropdownMenu<ColorLabel>(
                      initialSelection: ColorLabel.green,
                      controller: colorController,
                      // requestFocusOnTap is enabled/disabled by platforms when it is null.
                      // On mobile platforms, this is false by default. Setting this to true will
                      // trigger focus request on the text field and virtual keyboard will appear
                      // afterward. On desktop platforms however, this defaults to true.
                      requestFocusOnTap: true,
                      label: const Text('Color'),
                      onSelected: (ColorLabel? color) {
                        setState(() {
                          selectedColor = color;
                        });
                      },
                      dropdownMenuEntries: ColorLabel.values
                          .map<DropdownMenuEntry<ColorLabel>>(
                              (ColorLabel color) {
                        return DropdownMenuEntry<ColorLabel>(
                          value: color,
                          label: color.label,
                          enabled: color.label != 'Grey',
                          style: MenuItemButton.styleFrom(
                            foregroundColor: color.color,
                          ),
                        );
                      }).toList(),



                    ),