import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:campus_collaboration_app/core/network/token_storage.dart';
import '../models/group_model.dart';

class GroupRemoteDatasource {
  static const String _base = 'http://10.0.2.2:3000';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (TokenStorage.getToken() != null)
      'Authorization': 'Bearer ${TokenStorage.getToken()}',
  };

  Future<List<GroupModel>> fetchAllGroups() async {
    final res = await http.get(Uri.parse('$_base/groups'), headers: _headers);
    if (res.statusCode != 200) throw Exception('Failed to fetch groups');
    final List data = jsonDecode(res.body);
    return data.map((e) => GroupModel.fromJson(e)).toList();
  }

  Future<GroupModel?> fetchGroupById(String id) async {
    final res = await http.get(
      Uri.parse('$_base/groups/$id'),
      headers: _headers,
    );
    if (res.statusCode == 404) return null;
    if (res.statusCode != 200) throw Exception('Failed to fetch group');
    return GroupModel.fromJson(jsonDecode(res.body));
  }

  Future<List<GroupMemberModel>> fetchGroupMembers(String groupId) async {
    final res = await http.get(
      Uri.parse('$_base/groups/$groupId'),
      headers: _headers,
    );
    if (res.statusCode != 200) throw Exception('Failed to fetch members');
    final data = jsonDecode(res.body);
    final List members = data['members'] ?? [];
    return members.map((e) => GroupMemberModel.fromJson(e)).toList();
  }

  Future<GroupModel> createGroup({
    required String name,
    required String topic,
    required String description,
    required String creatorId,
    required String creatorName,
    required String creatorField,
  }) async {
    final res = await http.post(
      Uri.parse('$_base/groups'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'topic': topic,
        'description': description,
      }),
    );
    if (res.statusCode != 201) throw Exception('Failed to create group');
    return GroupModel.fromJson(jsonDecode(res.body));
  }

  Future<GroupModel> updateGroup({
    required String groupId,
    required String name,
    required String topic,
    required String description,
  }) async {
    final res = await http.put(
      Uri.parse('$_base/groups/$groupId'),
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'topic': topic,
        'description': description,
      }),
    );
    if (res.statusCode != 200) throw Exception('Failed to update group');
    return GroupModel.fromJson(jsonDecode(res.body));
  }

  Future<void> deleteGroup(String groupId) async {
    final res = await http.delete(
      Uri.parse('$_base/groups/$groupId'),
      headers: _headers,
    );
    if (res.statusCode != 200) throw Exception('Failed to delete group');
  }

  Future<GroupMemberModel> joinGroup({
    required String groupId,
    required String userId,
    required String userName,
    required String userField,
  }) async {
    final res = await http.post(
      Uri.parse('$_base/groups/$groupId/join'),
      headers: _headers,
    );
    if (res.statusCode != 201) throw Exception('Failed to join group');
    return GroupMemberModel(
      id: '',
      groupId: groupId,
      userId: userId,
      userName: userName,
      userField: userField,
      role: 'member',
      joinedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<void> leaveGroup({
    required String groupId,
    required String userId,
  }) async {
    final res = await http.delete(
      Uri.parse('$_base/groups/$groupId/leave'),
      headers: _headers,
    );
    if (res.statusCode != 200) throw Exception('Failed to leave group');
  }
}
