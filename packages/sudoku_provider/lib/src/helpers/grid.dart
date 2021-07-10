import '../helpers/grid_debugger.dart';
import '../helpers/grid_validator.dart';
import '../models/box_model.dart';

abstract class Grid {
  static const size = 9;
  static const length = size * size;

  static List<int> getIndexListOfBoxInSameRow(int index) {
    int rowIndex = (index / Grid.size).floor();
    int rowStartIndex = rowIndex * Grid.size;
    int rowEndIndex = rowStartIndex + Grid.size;
    List<int> indexInSameRow = [];

    for (int currIndex = rowStartIndex; currIndex < rowEndIndex; currIndex++) {
      if (currIndex != index) {
        indexInSameRow.add(currIndex);
      }
    }
    return indexInSameRow;
  }

  static List<int> getIndexListOfBoxInSameColumn(int index) {
    int columnIndex = index % Grid.size;
    List<int> indexInSameColumn = [];

    for (int i = 0; i < Grid.size; i++) {
      int currIndex = columnIndex + (i * Grid.size);
      if (currIndex != index) {
        indexInSameColumn.add(currIndex);
      }
    }
    return indexInSameColumn;
  }

  static List<int> getIndexListOfBoxInSameBlock(int index) {
    int blocStartColumIndex = ((index % Grid.size) / 3).floor() * 3;
    int blocStartRowIndex = (((index / Grid.size).floor()) / 3).floor() * 3;
    List<int> indexInSameBlock = [];

    for (int y = 0; y < 3; y++) {
      for (int x = 0; x < 3; x++) {
        int currRowIndex = blocStartRowIndex + y;
        int currColumnIndex = blocStartColumIndex + x;
        int currIndex = currRowIndex * Grid.size + currColumnIndex;
        if (currIndex != index) {
          indexInSameBlock.add(currIndex);
        }
      }
    }
    return indexInSameBlock;
  }

  static get validator => GridValidator;
  static get debugger => GridDebugger;
  static get list => List.generate(length, (_) => BoxPuzzled.ordered());
}

enum GridLevel { beginner, easy, medium, advanced, expert }
