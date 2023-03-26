import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class ProductModel {
  const ProductModel(this.uid, this.provider_name, this.song_title,
      this.song_no, this.song_artist_name,this.is_like);
  final String uid;
  final String provider_name;
  final String song_title;
  final String song_no;
  final String song_artist_name;
  final int is_like;
}

const productList = [
  ProductModel("0", "금영", "Monologue", "82308", "TEI",1),
  ProductModel("1", "태진", "사건의 지평선", "81425", "윤하",0),
  ProductModel("2", "금영", "Monologue", "82308", "TEI",0),
  ProductModel("3", "금영", "Monologue", "82308", "TEI",1),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Mic App';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: _title,
        home: DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: TabBar(tabs: [
                Text('우울할때', style: TextStyle(color: Colors.black)),
                Text('즐거울때', style: TextStyle(color: Colors.black)),
                Text('자주부르는 노래', style: TextStyle(color: Colors.black)),
                Text('신나는 곡', style: TextStyle(color: Colors.black)),
              ]),
              body: TabBarView(children: [
                ListTileSelectWidget(title: '우울할때', data: productList),
                ListTileSelectWidget(title: '즐거울때', data: productList),
                ListTileSelectWidget(title: '자주부르는 노래', data: productList),
                ListTileSelectWidget(title: '신나는 곡', data: productList),
              ]),
            )));
  }
}

class ListTileSelectWidget extends StatefulWidget {
  const ListTileSelectWidget(
      {super.key, required this.title, required this.data});
  final String title;
  final List<ProductModel> data;
  @override
  ListTileSelectWidgetState createState() => ListTileSelectWidgetState();
}

class ListTileSelectWidgetState extends State<ListTileSelectWidget> {
  bool isSelectionMode = false;
  late List<bool> _selected;
  bool _selectAll = false;
  bool _isGridMode = false;

  @override
  void initState() {
    super.initState();
    initializeSelection();
  }

  void initializeSelection() {
    _selected = List<bool>.generate(widget.data.length, (_) => false);
  }

  @override
  void dispose() {
    _selected.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: isSelectionMode
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      isSelectionMode = false;
                    });
                    initializeSelection();
                  },
                )
              : const SizedBox(),
          actions: <Widget>[
            if (_isGridMode)
              IconButton(
                icon: const Icon(Icons.grid_on),
                onPressed: () {
                  setState(() {
                    _isGridMode = false;
                  });
                },
              )
            else
              IconButton(
                icon: const Icon(Icons.list),
                onPressed: () {
                  setState(() {
                    _isGridMode = true;
                  });
                },
              ),
            if (isSelectionMode)
              TextButton(
                  child: !_selectAll
                      ? const Text(
                          'select all',
                          style: TextStyle(color: Colors.white),
                        )
                      : const Text(
                          'unselect all',
                          style: TextStyle(color: Colors.white),
                        ),
                  onPressed: () {
                    _selectAll = !_selectAll;
                    setState(() {
                      _selected =
                          List<bool>.generate(widget.data.length, (_) => _selectAll);
                    });
                  }),
          ],
        ),
        body: _isGridMode
            ? GridBuilder(
                isSelectionMode: isSelectionMode,
                selectedList: _selected,
                onSelectionChange: (bool x) {
                  setState(() {
                    isSelectionMode = x;
                  });
                },
              )
            : ListBuilder(
                isSelectionMode: isSelectionMode,
                selectedList: _selected,
                data: widget.data,
                onSelectionChange: (bool x) {
                  setState(() {
                    isSelectionMode = x;
                  });
                },
              ));
  }
}

class GridBuilder extends StatefulWidget {
  const GridBuilder({
    super.key,
    required this.selectedList,
    required this.isSelectionMode,
    required this.onSelectionChange,
  });

  final bool isSelectionMode;
  final Function(bool)? onSelectionChange;
  final List<bool> selectedList;

  @override
  GridBuilderState createState() => GridBuilderState();
}

class GridBuilderState extends State<GridBuilder> {
  void _toggle(int index) {
    if (widget.isSelectionMode) {
      setState(() {
        widget.selectedList[index] = !widget.selectedList[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: widget.selectedList.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (_, int index) {
          return InkWell(
            onTap: () => _toggle(index),
            onLongPress: () {
              if (!widget.isSelectionMode) {
                setState(() {
                  widget.selectedList[index] = true;
                });
                widget.onSelectionChange!(true);
              }
            },
            child: GridTile(
                child: Container(
              child: widget.isSelectionMode
                  ? Checkbox(
                      onChanged: (bool? x) => _toggle(index),
                      value: widget.selectedList[index])
                  : const Icon(Icons.image),
            )),
          );
        });
  }
}

class ListBuilder extends StatefulWidget {
  const ListBuilder({
    super.key,
    required this.selectedList,
    required this.data,
    required this.isSelectionMode,
    required this.onSelectionChange,
  });

  final List<ProductModel> data;
  final bool isSelectionMode;
  final List<bool> selectedList;
  final Function(bool)? onSelectionChange;

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  void _toggle(int index) {
    if (widget.isSelectionMode) {
      setState(() {
        widget.selectedList[index] = !widget.selectedList[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.selectedList.length,
        itemBuilder: (_, int index) {
          return ListTile(
              onTap: () => _toggle(index),
              onLongPress: () {
                if (!widget.isSelectionMode) {
                  setState(() {
                    widget.selectedList[index] = true;
                  });
                  widget.onSelectionChange!(true);
                }
              },
              trailing: widget.isSelectionMode
                  ? Checkbox(
                      value: widget.selectedList[index],
                      onChanged: (bool? x) => _toggle(index),
                    )
                  : const SizedBox.shrink(),
              title: Row(children: [
                Expanded(
                  /*1*/
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*2*/
                      Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          widget.data[index].song_title,
                          style: TextStyle(fontWeight: FontWeight.bold,),
                        ),
                      ),
                      Text(
                        widget.data[index].song_artist_name,
                        style: TextStyle(color: Colors.grey[500],),
                      ),
                    ],
                  ),
                ),
                Center(child: (widget.data[index].is_like==1)?Icon(Icons.star,color: Colors.red[500]):null)
              ]));
        });
  }
}
