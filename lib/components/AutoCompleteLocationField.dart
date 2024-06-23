import 'package:flutter/material.dart';
import 'package:super_liquid_galaxy_controller/utils/autocomplete_controller.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';

import '../data_class/PlaceSuggestionResponse.dart';

class AutoCompleteLocationField extends StatefulWidget {
  AutoCompleteLocationField(
      {
        super.key,
      required this.hintText,
      required this.labelText,
      required this.iconData,
      required this.textInputType,
      required this.isPassword,
      required this.autocompleteController,
      this.controller,
      this.buttonAction,
      this.endIcon,
      this.fillColor,
      this.textColor
      });

  String hintText;
  String labelText;
  IconData iconData;
  TextInputType textInputType;
  bool isPassword;
  TextEditingController? controller;
  VoidCallback? buttonAction;
  IconData? endIcon;
  Color? fillColor;
  Color? textColor;
  AutocompleteController autocompleteController;

  @override
  State<AutoCompleteLocationField> createState() =>
      _AutoCompleteLocationFieldState();
}

class _AutoCompleteLocationFieldState extends State<AutoCompleteLocationField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Features>(
      fieldViewBuilder: (BuildContext context, TextEditingController controller,
          FocusNode focusNode, VoidCallback onFieldSubmitted) {
        return TextField(
            obscureText: _obscureText,
            onChanged: (text) {},
            controller: widget.controller,
            decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                    fontSize: 20, color: Colors.grey.withOpacity(0.4)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    widget.iconData,
                    color: widget.textColor ?? Colors.grey,
                    size: 50.0,
                  ),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                        width: 2.5)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: GalaxyColors.blue,
                        style: BorderStyle.solid,
                        width: 2.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                        width: 2.5)),
                fillColor: widget.fillColor ?? Colors.transparent,
                filled: widget.fillColor == null ? false : true,
                label: Text(widget.labelText),
                focusColor: Colors.grey,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelStyle: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                alignLabelWithHint: true,
                suffixIcon: (widget.endIcon == null)
                    ? (widget.isPassword
                        ? (Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: widget.buttonAction ??
                                  (() {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  }),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                  size: 40.0,
                                ),
                              ),
                            )))
                        : null)
                    : (Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: widget.buttonAction ??
                              (() {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              }),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Icon(
                              widget.endIcon,
                              color: Colors.grey,
                              size: 40.0,
                            ),
                          ),
                        )))),
            style: TextStyle(
                fontSize: 25, color: widget.textColor ?? Colors.grey),
            maxLines: 1,
            minLines: 1,
            keyboardType: widget.textInputType,
            );
      },
      displayStringForOption: (option) =>
          '${option.properties?.name} - ${option.properties?.city}',
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text.isEmpty) {
          return widget.autocompleteController.lastOptions;
        }
        setState(() {
          widget.autocompleteController.networkError = false;
        });
        //debug
        print("Request sent: ${textEditingValue.text}");
        final Iterable<Features>? options =
            await widget.autocompleteController.debouncedSearch(textEditingValue.text);
        if (options == null) {
          return widget.autocompleteController.lastOptions;
        }
        widget.autocompleteController.lastOptions = options;
        print("suggestion: ${options.length}");
        return options;
      },
      optionsViewBuilder: (context, onSelected, options) {
        print('Building: ${options.length}');
        return Material(
          elevation: 4.0,
          child: SizedBox(
            height: 200.0,
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                final option = options.elementAt(index);
                return GestureDetector(
                  onTap: () {
                    onSelected(option);
                  },
                  child: ListTile(
                    title: Text(
                        '${option.properties?.name} - ${option.properties?.city}'),
                  ),
                );
              },
            ),
          ),
        );
      },
      onSelected: (Features selection) {
        debugPrint('You just selected ${selection.properties?.name}');
      },
    );
  }
}
