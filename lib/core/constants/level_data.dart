class LevelData {
  final int id;
  final String name;
  final String description;
  final int targetStars;

  const LevelData({
    required this.id,
    required this.name,
    required this.description,
    required this.targetStars,
  });
}

const List<LevelData> levels = [
  LevelData(
    id: 1,
    name: '加法入门',
    description: '学习 1+1 到 1+3',
    targetStars: 5,
  ),
  LevelData(
    id: 2,
    name: '加法进阶',
    description: '学习 2+1 到 2+4',
    targetStars: 6,
  ),
  LevelData(
    id: 3,
    name: '加法挑战',
    description: '3+1 到 3+6',
    targetStars: 6,
  ),
  LevelData(
    id: 4,
    name: '凑五训练',
    description: '1+4, 2+3, 3+2, 4+1',
    targetStars: 6,
  ),
  LevelData(
    id: 5,
    name: '减法入门',
    description: '2-1, 3-1, 3-2',
    targetStars: 5,
  ),
  LevelData(
    id: 6,
    name: '减法进阶',
    description: '4-1 到 4-3',
    targetStars: 6,
  ),
  LevelData(
    id: 7,
    name: '减法挑战',
    description: '5-1 到 5-5',
    targetStars: 6,
  ),
  LevelData(
    id: 8,
    name: '凑十训练',
    description: '6+4, 7+3, 8+2, 9+1',
    targetStars: 6,
  ),
  LevelData(
    id: 9,
    name: '混合练习',
    description: '加减混合',
    targetStars: 8,
  ),
  LevelData(
    id: 10,
    name: '数学大挑战',
    description: '综合测试',
    targetStars: 10,
  ),
];
