import 'package:flutter/material.dart';
import 'package:super_liquid_galaxy_controller/utils/galaxy_colors.dart';

class GalaxyTextField extends StatefulWidget {
  GalaxyTextField(
      {super.key,
      required this.hintText,
      required this.labelText,
      required this.iconData,
      required this.textInputType,
      required this.isPassword,
      this.controller,
      this.buttonAction,
      this.endIcon,
      this.fillColor,
      this.textColor});

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

  @override
  State<GalaxyTextField> createState() => _GalaxyTextFieldState();
}

class _GalaxyTextFieldState extends State<GalaxyTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: TextFormField(
          obscureText: _obscureText,
          onChanged: (text) {},
          controller: widget.controller,
          decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle:
                  TextStyle(fontSize: 20, color: Colors.grey.withOpacity(0.4)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(
                  widget.iconData,
                  color: widget.textColor??Colors.grey,
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

              fillColor:widget.fillColor??Colors.transparent,
              filled: widget.fillColor==null?false:true,
              label: Text(widget.labelText),
              focusColor: Colors.grey,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              alignLabelWithHint: true,
              suffixIcon:
              (widget.endIcon==null)?
              (widget.isPassword
                  ? (Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: widget.buttonAction ?? (() {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        }),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                            size: 40.0,
                          ),
                        ),
                      )))
                  : null):
              (Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: widget.buttonAction ?? (() {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    }),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Icon(
                        widget.endIcon,
                        color: Colors.grey,
                        size: 40.0,
                      ),
                    ),
                  )))

          ),
          style:TextStyle(fontSize: 25, color: widget.textColor ?? Colors.grey),
          maxLines: 1,
          minLines: 1,
          keyboardType: widget.textInputType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a pill name';
            }
            return null;
          }),
    );
  }
}
