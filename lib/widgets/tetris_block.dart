import 'package:flutter/material.dart';

class TetrisBlock extends StatelessWidget {
  final List<List<bool>> shape;
  final Color color;

  const TetrisBlock({super.key, required this.shape, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: shape
          .map((row) => Row(
                children: row
                    .map((isFilled) => Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              color: isFilled ? color : Colors.transparent,
                              border: isFilled
                                  ? Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    )
                                  : const Border()),
                        ))
                    .toList(),
              ))
          .toList(),
    );
  }
}
