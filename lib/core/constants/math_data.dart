class MathProblem {
  final int operand1;
  final int operand2;
  final String operator; // "+" or "-"
  final int answer;
  final List<int> options;

  MathProblem({
    required this.operand1,
    required this.operand2,
    required this.operator,
    required this.answer,
    required this.options,
  });

  String get question => '$operand1 $operator $operand2 = ?';

  static List<MathProblem> generateProblems(int levelId) {
    final problems = <MathProblem>[];

    switch (levelId) {
      case 1: // 加法入门 1+1 到 1+3
        for (int i = 1; i <= 3; i++) {
          problems.add(_makeProblem(1, i, '+'));
          problems.add(_makeProblem(1, i, '+'));
        }
        break;
      case 2: // 加法进阶
        for (int j = 1; j <= 4; j++) {
          problems.add(_makeProblem(2, j, '+'));
          problems.add(_makeProblem(2, j, '+'));
        }
        break;
      case 3: // 加法挑战
        for (int i = 3; i <= 5; i++) {
          for (int j = 1; j <= 6 - i + 3; j++) {
            if (i + j <= 9) {
              problems.add(_makeProblem(i, j, '+'));
            }
          }
        }
        break;
      case 4: // 凑五训练
        problems.add(_makeProblem(1, 4, '+'));
        problems.add(_makeProblem(2, 3, '+'));
        problems.add(_makeProblem(3, 2, '+'));
        problems.add(_makeProblem(4, 1, '+'));
        problems.add(_makeProblem(1, 4, '+'));
        problems.add(_makeProblem(2, 3, '+'));
        problems.add(_makeProblem(3, 2, '+'));
        problems.add(_makeProblem(4, 1, '+'));
        break;
      case 5: // 减法入门
        for (int i = 2; i <= 3; i++) {
          for (int j = 1; j < i; j++) {
            problems.add(_makeProblem(i, j, '-'));
            problems.add(_makeProblem(i, j, '-'));
          }
        }
        break;
      case 6: // 减法进阶
        for (int i = 4; i <= 5; i++) {
          for (int j = 1; j <= i - 1; j++) {
            problems.add(_makeProblem(i, j, '-'));
            problems.add(_makeProblem(i, j, '-'));
          }
        }
        break;
      case 7: // 减法挑战
        for (int i = 5; i <= 7; i++) {
          for (int j = 1; j <= 5; j++) {
            if (i - j >= 0) {
              problems.add(_makeProblem(i, j, '-'));
            }
          }
        }
        break;
      case 8: // 凑十训练
        problems.add(_makeProblem(6, 4, '+'));
        problems.add(_makeProblem(7, 3, '+'));
        problems.add(_makeProblem(8, 2, '+'));
        problems.add(_makeProblem(9, 1, '+'));
        problems.add(_makeProblem(6, 4, '+'));
        problems.add(_makeProblem(7, 3, '+'));
        problems.add(_makeProblem(8, 2, '+'));
        problems.add(_makeProblem(9, 1, '+'));
        break;
      case 9: // 混合练习
        for (int i = 0; i < 5; i++) {
          problems.add(_makeProblem(i + 2, 1, '+'));
          problems.add(_makeProblem(i + 3, 1, '-'));
        }
        break;
      case 10: // 综合测试
        for (int i = 1; i <= 9; i++) {
          for (int j = 1; j <= 9 - i; j++) {
            if (i + j <= 9) {
              problems.add(_makeProblem(i, j, '+'));
            }
          }
          for (int k = 2; k <= 9; k++) {
            problems.add(_makeProblem(k, 1, '-'));
          }
        }
        break;
    }

    problems.shuffle();
    return problems;
  }

  static MathProblem _makeProblem(int a, int b, String op) {
    final answer = op == '+' ? a + b : a - b;
    final options = _generateOptions(answer);
    return MathProblem(
      operand1: a,
      operand2: b,
      operator: op,
      answer: answer,
      options: options,
    );
  }

  static List<int> _generateOptions(int correct) {
    final options = <int>{correct};
    while (options.length < 4) {
      final wrong = (correct + (options.length * 2 + 1)) % 15;
      if (wrong != correct && wrong >= 0 && wrong <= 18) {
        options.add(wrong);
      }
    }
    final list = options.toList()..shuffle();
    return list;
  }
}
