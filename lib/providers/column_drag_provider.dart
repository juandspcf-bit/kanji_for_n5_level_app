import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColumnDragProvider extends Notifier<ColumnDragData> {
  @override
  ColumnDragData build() {
    return ColumnDragData(scale: 1, isDown: true);
  }

  void changeScale() {
    if (state.isDown) {
      state = ColumnDragData(scale: 3, isDown: false);
      Future.delayed(const Duration(seconds: 3), () {
        state = ColumnDragData(scale: 1, isDown: true);
      });
    }

    //setState(() => scale = scale == 1.0 ? 3.0 : 1.0);
  }
}

final columnDragProvider = NotifierProvider<ColumnDragProvider, ColumnDragData>(
    ColumnDragProvider.new);

class ColumnDragData {
  final double scale;
  final bool isDown;

  ColumnDragData({required this.scale, required this.isDown});
}
