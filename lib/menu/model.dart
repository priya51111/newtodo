class Menu {
       
  final String menuname;  
  final String date;      
  final String menuId;    

  Menu({     
    required this.menuname, 
    required this.date,    
    required this.menuId, 
  });

 
  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
     
      menuname: json['menuname'],      
      date: json['date'],              
      menuId: json['_id'],             
    );
  }


  Map<String, dynamic> toJson() {
    return {
                           
      'menuname': menuname,           
      'date': date,                    
      'menuId': menuId,                
    };
  }
}
