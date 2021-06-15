class Level {
  final int baseAmountOfPuzzle;
  final String label;

  const Level({required this.baseAmountOfPuzzle, required this.label});
}

class Levels {
  final List<Level> list = [
    const Level(label: 'debutant', baseAmountOfPuzzle: 50),
    const Level(label: 'facile', baseAmountOfPuzzle: 40),
    const Level(label: 'moyen', baseAmountOfPuzzle: 30),
    const Level(label: 'difficile', baseAmountOfPuzzle: 20),
    const Level(label: 'expert', baseAmountOfPuzzle: 0),
  ];

  String getLabel(index) => list[index].label;
  int getAmountOfPuzzle(index) => list[index].baseAmountOfPuzzle;
}
