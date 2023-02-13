import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: ReorderableListTest(),
      ),
    );
  }
}

class ReorderableListTest extends StatefulWidget {
  ReorderableListTest({super.key});

  @override
  State<ReorderableListTest> createState() => _ReorderableListTestState();
}

class _ReorderableListTestState extends State<ReorderableListTest> {
  final List onBike = [
    ListTile(
      key: Key('FIRM'),
      title: Text('FIRM'),
    ),
    ListTile(
      key: Key('SNOW'),
      title: Text('SNOW'),
    ),
    ListTile(
      key: Key('SOFT'),
      title: Text('SOFT'),
    ),
  ];

  final List offBike = [
    ListTile(
      key: Key('OFFBIKE1'),
      title: Text('OFFBIKE1'),
    ),
    ListTile(
      key: Key('OFFBIKE2'),
      title: Text('OFFBIKE2'),
    ),
    ListTile(
      key: Key('OFFBIKE3'),
      title: Text('OFFBIKE3'),
    ),
  ];

  reorder(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;
    if (oldIndex == 0 || oldIndex == 4) return;

    final bool movingItemIsOnBike = oldIndex <= 4;
    final bool targetItemIsOnBike = newIndex <= 4;

    late final item;
    if (movingItemIsOnBike) {
      item = onBike.removeAt(oldIndex - 1);
    } else {
      item = offBike.removeAt(oldIndex - 5);
    }

    if (targetItemIsOnBike) {
      final insertIndex = newIndex - 1;
      onBike.insert(insertIndex, item);

      // If list is greater than 3, move the rest to the other list
      if (onBike.length > 3) {
        final extraItems = onBike.sublist(3);
        onBike.removeRange(3, onBike.length);
        offBike.insertAll(0, extraItems);
      }
    } else {
      final insertIndex = newIndex - 5;
      offBike.insert(insertIndex, item);

      // If list is greater than 3, move the first item to the other list
      if (offBike.length > 3) {
        final extraItem = offBike.removeAt(0);
        onBike.add(extraItem);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      onReorder: reorder,
      children: [
        GestureDetector(
          key: Key('ON BIKE ITEMS'),
          onLongPress: () {},
          child: const ReorderableDragStartListener(
            index: 0,
            enabled: false,
            child: ListTile(
                title: Text('ON BIKE ITEMS',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ),
        ),
        ...onBike,
        GestureDetector(
          key: Key('OFF BIKE ITEMS'),
          onLongPress: () {},
          child: const ReorderableDragStartListener(
            index: 4,
            enabled: false,
            child: ListTile(
                title: Text('OFF BIKE ITEMS',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ),
        ),
        ...offBike,
      ],
    );
  }
}

class Lists extends StatefulWidget {
  const Lists({super.key});

  @override
  State<Lists> createState() => _ListsState();
}

class _ListsState extends State<Lists> {
  final onBike = <DragAndDropItem>[
    DragAndDropItem(
      child: _ListItem('FIRM'),
    ),
    DragAndDropItem(
      child: _ListItem('SNOW'),
    ),
    DragAndDropItem(
      child: _ListItem('SOFT'),
    ),
  ];

  final offBike = <DragAndDropItem>[
    DragAndDropItem(
      child: _ListItem('OFFBIKE1'),
    ),
    DragAndDropItem(
      child: _ListItem('OFFBIKE2'),
    ),
    DragAndDropItem(
      child: _ListItem('OFFBIKE3'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DragAndDropLists(
      children: [
        DragAndDropList(
          canDrag: false,
          header: Text('On Bike', style: Theme.of(context).textTheme.headline6),
          children: onBike,
        ),
        DragAndDropList(
          canDrag: false,
          header:
              Text('Off Bike', style: Theme.of(context).textTheme.headline6),
          children: offBike,
        )
      ],
      onItemReorder: _onItemReorder,
      onListReorder: _onListReorder,
    );
  }

  _onItemReorder(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    late final DragAndDropItem item;

    if (oldListIndex == 0) {
      item = onBike.removeAt(oldItemIndex);
    } else {
      item = offBike.removeAt(oldItemIndex);
    }

    if (newListIndex == 0) {
      onBike.insert(newItemIndex, item);

      // If list is greater than 3, move the rest to the other list
      if (onBike.length > 3) {
        final extraItems = onBike.sublist(3);
        onBike.removeRange(3, onBike.length);
        offBike.insertAll(0, extraItems);
      }
    } else {
      offBike.insert(newItemIndex, item);

      // If list is greater than 3, move the first item to the other list
      if (offBike.length > 3) {
        final extraItem = offBike.removeAt(0);
        onBike.add(extraItem);
      }
    }
    setState(() {});
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {});
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem(
    this.label, {
    Key? key,
  }) : super(key: key);
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Text(label),
    );
  }
}
