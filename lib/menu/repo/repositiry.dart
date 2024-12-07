
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:get_storage/get_storage.dart';
import 'package:newtodo/menu/model.dart';

class MenuRepository {
  final String createMenuUrl =
      'https://app-project-9.onrender.com/api/menu/menu';
  final String fetchMenusUrl =
      'https://app-project-9.onrender.com/api/menu/getbyid';
  final GetStorage box = GetStorage();
  final Logger logger = Logger();

  final List<String> defaultMenus = [
    "Wishlist",
    "Shopping",
    "Default",
    "Personal",
    "Work"
  ];

  Future<Map<String, dynamic>> createMenu(String menuname, String date) async {
    try {
      final userId = box.read('userId');
      final token = box.read('token');

      final response = await http.post(
        Uri.parse(createMenuUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'menuname': menuname,
          'userId':    userId,
          'date': date,
        }),
      );

      logger.i("API Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final menuId = data['data']['menu']['_id'];
        final menuDate = data['data']['menu']['date'];

        logger.i("Menu created with ID: $menuId on $menuDate");
        box.write('menuId', menuId);
        box.write('menuDate', menuDate);

        logger.i("Menu ID and Date saved to GetStorage");

        return data;
      } else {
        logger.e("API Error: ${response.body}");
        throw Exception("Error creating menu: ${response.body}");
      }
    } catch (e) {
      logger.e("Error creating menu: $e");
      throw Exception('Failed to create menu');
    }
  }

  Future<List<Menu>> fetchMenus({required String userId, required String date}) async {
    try {
      final token = box.read('token');

      logger.i("Using saved date for fetchMenus: $date");

      final response = await http.get(
        Uri.parse('$fetchMenusUrl/$userId/$date'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      logger.i("API Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success' && data['data']['menu'] != null) {
          List<Menu> menuList = (data['data']['menu'] as List)
              .map((menu) => Menu.fromJson(menu))
              .toList();

          await _createDefaultMenusIfNeeded(menuList, userId, date);
          return menuList;
        } else {
          throw Exception('Menu not found in response');
        }
      } else {
        throw Exception('Failed to fetch menus');
      }
    } catch (error) {
      logger.e("Error fetching menus: $error");
      throw Exception('Failed to fetch menus');
    }
  }

  Future<void> _createDefaultMenusIfNeeded(
      List<Menu> existingMenus, String userId, String date) async {
    final existingMenuNames =
        existingMenus.map((menu) => menu.menuname).toList();
    logger.i('Existing menu names: $existingMenuNames');
    for (var defaultMenu in defaultMenus) {
      if (!existingMenuNames.contains(defaultMenu)) {
        await createMenu(defaultMenu, date);
        logger.i('Default menu "$defaultMenu" created');
      }
    }
  }
}

