import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/skill_model.dart';

class SkillsRemoteDatasource {
  static const String _base = 'http://10.0.2.2:3000';

  Future<List<SkillModel>> fetchAllSkills() async {
    final res = await http.get(Uri.parse('$_base/skills'));
    if (res.statusCode != 200) throw Exception('Failed to fetch skills');
    final List data = jsonDecode(res.body);
    return data.map((e) => SkillModel.fromJson(e)).toList();
  }

  Future<SkillModel> createSkill(SkillModel skill) async {
    final res = await http.post(
      Uri.parse('$_base/skills'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': skill.title,
        'category': skill.category,
        'description': skill.description,
        'availability': skill.availability,
        'prerequisites': skill.prerequisites,
      }),
    );
    if (res.statusCode != 201) throw Exception('Failed to create skill');
    return SkillModel.fromJson(jsonDecode(res.body));
  }

  Future<SkillModel> updateSkill(SkillModel skill) async {
    final res = await http.put(
      Uri.parse('$_base/skills/${skill.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': skill.title,
        'category': skill.category,
        'description': skill.description,
        'availability': skill.availability,
        'prerequisites': skill.prerequisites,
      }),
    );
    if (res.statusCode != 200) throw Exception('Failed to update skill');
    return SkillModel.fromJson(jsonDecode(res.body));
  }

  Future<void> deleteSkill(String id) async {
    final res = await http.delete(Uri.parse('$_base/skills/$id'));
    if (res.statusCode != 200) throw Exception('Failed to delete skill');
  }

  Future<void> requestSkill({
    required String skillId,
    required String requesterId,
  }) async {
    await http.post(Uri.parse('$_base/skills/$skillId/request'));
  }
}
