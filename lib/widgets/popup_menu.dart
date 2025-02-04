import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum Menu {
  TaskLists,
  AddInBatchMode,
  RemoveAds,
  MoreApps,
  SendFeedback,
  FollowUs,
  Invite,
  Settings,
  MenuPage,
  Logout
}

Widget buildPopupMenu(BuildContext context) {
  return PopupMenuButton<Menu>(
    elevation: 0,
    constraints: const BoxConstraints.tightFor(height: 340, width: 200),
    color: const Color.fromARGB(135, 33, 149, 243),
    icon: const Icon(Icons.more_vert, color: Colors.white),
    onSelected: (Menu item) {
      switch (item) {
        case Menu.TaskLists:
          GoRouter.of(context).go('/tasklist');
          break;
        case Menu.AddInBatchMode:
          break;
        case Menu.RemoveAds:
          break;
        case Menu.MoreApps:
          break;
        case Menu.FollowUs:
          break;
        case Menu.Invite:
          break;
        case Menu.Settings:
          GoRouter.of(context).go('/setting');
          break;
        case Menu.Logout:
          GoRouter.of(context).go('/logout');
          break;
        case Menu.MenuPage:
          break;
        default:
      }
    },
    itemBuilder: (context) => <PopupMenuEntry<Menu>>[
      const PopupMenuItem<Menu>(
          value: Menu.TaskLists,
          child: Text(
            'TaskList',
            style: TextStyle(color: Colors.white),
          )),
      const PopupMenuItem<Menu>(
          value: Menu.AddInBatchMode,
          child: Text(
            'AddInBatchMode',
            style: TextStyle(color: Colors.white),
          )),
      const PopupMenuItem<Menu>(
          value: Menu.RemoveAds,
          child: Text(
            'RemoveAds',
            style: TextStyle(color: Colors.white),
          )),
      const PopupMenuItem<Menu>(
          value: Menu.MoreApps,
          child: Text(
            'MoreApps',
            style: TextStyle(color: Colors.white),
          )),
      const PopupMenuItem<Menu>(
          value: Menu.FollowUs,
          child: Text(
            'Follow Us',
            style: TextStyle(color: Colors.white),
          )),
      const PopupMenuItem<Menu>(
          value: Menu.Invite,
          child: Text(
            'Invite ',
            style: TextStyle(color: Colors.white),
          )),
      const PopupMenuItem<Menu>(
          value: Menu.Settings,
          child: Text(
            'Settings',
            style: TextStyle(color: Colors.white),
          )),
      const PopupMenuItem<Menu>(
          value: Menu.Logout,
          child: Text(
            'Logout',
            style: TextStyle(color: Colors.white),
          )),
      const PopupMenuItem<Menu>(
          value: Menu.MenuPage,
          child: Text(
            'MenuPage',
            style: TextStyle(color: Colors.white),
          )),
    ],
  );
}
