import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:collection';

class try_graph extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _try_graph();
  }
}

class _try_graph extends State<try_graph>{

  static int total_cells_r = 10;
  static int total_cells_c = 30;
  static int total_cells = total_cells_r*total_cells_c;
  

  var arr = List.generate(total_cells, (i) => List.generate(total_cells, (j) => 0));
  var weights = List.generate(total_cells, (int index) => total_cells*2);
  HashSet _visited = new HashSet<int>();
  HashSet _wall = new HashSet<int>();
  Queue<int> _positions = new Queue();
  Queue<int> _path = new Queue();
  bool found = false;
  Map map_path = Map<int, int>();
  var _algos = ["DIJKSTRA", "DFS"];
  String curr_algo="DIJKSTRA";

    @override
  void initState() {
    
    super.initState();
    
    for(int i=0; i<total_cells_r; i++){
      for(int j=0; j<total_cells_c-1; j++){
        int temp = j+i*total_cells_c;
        arr[temp][temp+1]=arr[temp+1][temp]=1;
      }
    }
    for(int i=0; i<total_cells_r-1; i++){
      for(int j=0; j<total_cells_c; j++){
        int temp = j+i*total_cells_c;
        arr[temp][temp+total_cells_c]=arr[temp+total_cells_c][temp]=1;
      }
    }
    
  }


  @override
  Widget build(BuildContext context) {
    
    
    return Container(
      color: Colors.blueGrey.shade600,
      child: main_page(context),
    );
  }

  Widget main_page(BuildContext context){
    double widths = MediaQuery.of(context).size.width;
    double heights = MediaQuery.of(context).size.height;
    return Container(
      height: 1000,
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 8.0))
          ,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(left: 8.0)),
             DropdownButton<String>(
               items: _algos.map((String s){
                 return DropdownMenuItem<String>(
                   value: s,
                   child: Text(s, style: TextStyle(
                     fontSize: 32.0,
                     color: Colors.blue,
                     fontWeight: FontWeight.w500,
                   )),
                 );
               }).toList(),
               onChanged: (String ?st){
                 setState(() {
                   curr_algo = st!;
                 });
               }
               ,
               value: curr_algo,
             ),
             
             Expanded(
               child: ListTile(
               leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(height: 24, width: 24, color: Colors.red.shade400),
               ),
               title: Text("Nodes"),
             )
            )
             ,
             //Icon(Icons.crop_square_rounded, color: Colors.red.shade400),
             Expanded(
               child: ListTile(
               leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(height: 24, width: 24, color: Colors.black87),
               ),
               title: Text("Wall"),
             )
            )
             
             ,
             Expanded(
               child: ListTile(
               leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(height: 24, width: 24, color: Colors.green.shade400),
               ),
               title: Text("Path"),
             )
             )
             ,
             Padding(padding: EdgeInsets.only(right: 8.0)),
            ],
          )
          ,
          
          Padding(padding: EdgeInsets.only(top: 8.0))
          ,
          Flexible(
            child: make_grid(context)
            )
          ,
          Padding(padding: EdgeInsets.only(top: 8.0))
          ,
          RaisedButton(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Play", style: TextStyle(fontSize: 20.0),),
              ),
            elevation: 10.0,
            onPressed: ((){
              lets_play();
            })
            )
            ,
            Padding(padding: EdgeInsets.only(top: 8.0))
            ,
            
            RaisedButton(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Modify", style: TextStyle(fontSize: 20.0),),
              ),
            elevation: 10.0,
            onPressed: ((){
              modify_data();
            })
            )
            ,
            Padding(padding: EdgeInsets.only(top: 8.0))
            ,

            RaisedButton(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Clear", style: TextStyle(fontSize: 20.0),),
              ),
            elevation: 10.0,
            onPressed: ((){
              clear_data();
            })
            )
            ,
        ],
      ),
    );
  }


 Widget make_grid(BuildContext context){
    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: total_cells,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: total_cells_c
        ),
          
        itemBuilder: ((context, index) {
          if(_positions.contains(index)) return make_cells(context, index, Colors.redAccent.shade200);
          else if(_wall.contains(index)) return make_cells(context, index, Colors.black87);
          else if(_path.contains(index)) return make_cells(context, index, Colors.greenAccent.shade200);
          else if(_visited.contains(index)) return make_cells(context, index, Colors.blue.shade400);
          return make_cells(context, index, Colors.brown.shade300);
        }),
        ),
    );
  }


  Widget make_cells(BuildContext context, int index, Color c){

    return Container(
      padding: EdgeInsets.all(1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          color: c,
          child: GestureDetector(
            onTap: (){
              int y = index%total_cells_c;
              int x = (index/total_cells_c).floor();
              int res = x*total_cells_c+y;
              if(_positions.length<2){
                setState(() {
                _positions.add(index);
              });
              }
              else{
                setState(() {
                _wall.add(index);
              });
              }
            },

            onDoubleTap: (){
              while(_wall.contains(index)) _wall.remove(index);
              setState(() {
                  
                }
              );
            },
          ),
        ),
      ),
    );
  }

  void dummy(){
    setState(() {});
  }

  void clear_data(){
    setState(() {
      _visited.clear();
      _positions.clear();
      _path.clear();
      found=false;
      map_path.clear();
      _wall.clear();
      for(int i=0; i<total_cells; i++) weights[i]=total_cells*2;
    });
  }

  void modify_data(){
    setState(() {
      _visited.clear();
      _path.clear();
      for(int i=0; i<total_cells; i++) weights[i]=total_cells*2;
    });
  }

  Future<void> lets_play() async {
    print(_wall);

    if(_positions.length==2){
      int st = _positions.first;
      int en = _positions.last;
      if(curr_algo==_algos[0]) dijkstra();
      else path(st, en);
    }
    else if(_positions.length==1){
      setState(() {
        raisedialogbox(context, "Select one more cell");
      });
    }
    else if(_positions.length>2){
      setState(() {
        raisedialogbox(context, "clear and select two cells");
      });
    }
    else if(_positions.length==0){
      setState(() {
        raisedialogbox(context, "Select two cells cell");
      });
    }
  }

  void raisedialogbox(BuildContext context, String s){
    var alertDia = AlertDialog(
      title: Text("Alert!"),
      content: Text(s),
    );
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return alertDia;
      }
    );

  }

  Future<bool> path(int sv, int dt) async {

    if(arr[sv][dt]==1){
      _path.add(sv);
      return true;
    }

    for(int i=0; i<total_cells*2; i++){
      if(sv==i) continue;
      if(!_visited.contains(i) && arr[i][sv]==1 && !_wall.contains(sv) && !_wall.contains(i)  ){
        await Future.delayed(Duration(milliseconds: 40), () {
                setState(() {
                _visited.add(i);
                });
            });
        bool found2 = await path(i, dt);

        if(sv == _positions.first){
          return found2;
        }
        if(found2){
          await Future.delayed(Duration(milliseconds: 10), () {
              setState(() {
              _path.add(sv);
              });
          });
          return found2;
        }
      }
    }
    return false;
  }

  Future<void> dijkstra() async {
    int sv = _positions.first;
    int en = _positions.last;
    int minver = sv;
    weights[minver]=0;
    outerLoop: while(minver!=-1){
      await Future.delayed(Duration(milliseconds: 40), () {
              setState(() {
              _visited.add(minver);
              });
          });
      innerLoop:for(int j=0; j<total_cells; j++){
        if(arr[minver][j]>0 && !_wall.contains(minver) && !_wall.contains(j)  ){
          if(weights[j]>arr[minver][j]+weights[minver] && !_visited.contains(j)){
            weights[j] = arr[minver][j] + weights[minver];
            map_path[j] = minver;
            if(_visited.contains(en)) break outerLoop;
          }
        }
      }
      minver = findmin();
    }
    int dist = en;
    while(true){
      dist = map_path[dist];
      if(dist==sv) break;

      await Future.delayed(Duration(milliseconds: 10), () {
              setState(() {
              _path.add(dist);
              });
          });
    }
  }

  int findmin(){
    int mx = total_cells*2, minver=-1;
    for(int i=0; i<total_cells; i++){
      if(!_visited.contains(i) && weights[i]<mx){
        minver = i;
        mx = weights[i];
      }
    }
    return minver;
  }
}
