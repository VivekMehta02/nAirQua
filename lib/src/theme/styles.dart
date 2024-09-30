import 'package:flutter/material.dart';

final InputDecoration loginTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: const Color.fromRGBO(248, 247, 251, 1),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Color(0xFF21899C)),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.transparent),
  ),
  border: InputBorder.none,
);
