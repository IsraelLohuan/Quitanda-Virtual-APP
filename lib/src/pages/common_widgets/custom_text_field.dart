import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSecret;
  final String? initialValue;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({ 
    Key? key, 
    required this.icon,  
    required this.label,
    this.isSecret = false,
    this.inputFormatters,
    this.initialValue,
    this.readOnly = false
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscure = false;

  @override
  void initState() {
    super.initState();
    isObscure = widget.isSecret;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField( 
        readOnly: widget.readOnly,
        initialValue: widget.initialValue,
        inputFormatters: widget.inputFormatters,
        obscureText: isObscure,
        decoration: InputDecoration(
          suffixIcon: Visibility(
            visible: widget.isSecret,
            child: IconButton(
              onPressed: () {
                setState(() {
                  isObscure = !isObscure;
                });
              }, 
              icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
            ),
          ),
          prefixIcon: Icon(widget.icon),
          labelText: widget.label,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18)
          )
        ),
      ),
    );
  }
}