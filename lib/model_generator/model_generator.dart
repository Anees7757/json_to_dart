import 'dart:convert';

//  [
//     {
//         "userId": 1,
//         "id": 1,
//         "title": "delectus aut autem",
//         "completed": false
//     },
//     {
//         "userId": 1,
//         "id": 2,
//         "title": "quis ut nam facilis et officia qui",
//         "completed": false
//     }
//   ]

class Generator {
  String jsonToDart(String json, String className) {
    List<String> keys = [];
    List<dynamic> values = [];
    String variables = '';
    String constructorArgs = '';
    String fromJsonArgs = "";
    String toJsonArgs = "";

    List<dynamic> jsonArray = jsonDecode(json);
    Set<String> uniqueKeys = {};
    jsonArray.forEach((jsonObject) {
      if (jsonObject is Map<String, dynamic>) {
        uniqueKeys.addAll(jsonObject.keys);
        values.addAll(jsonObject.values);
      }
    });
    keys = uniqueKeys.toList();
    values.removeRange(keys.length - 1, values.length - 1);

    for (int i = 0; i < keys.length; i++) {
      if (i == keys.length - 1) {
        if (values[i].runtimeType.toString() == "_JsonMap") {
          variables += "final Map<String, dynamic> ${keys[i]};";
        } else {
          variables += "final ${values[i].runtimeType} ${keys[i]};";
        }
        constructorArgs += "this.${keys[i]}";
        fromJsonArgs += "${keys[i]} = json['${keys[i]}']";
        toJsonArgs += "'${keys[i]}': ${keys[i]},";
      } else {
        if (values[i].runtimeType.toString() == "_JsonMap") {
          variables += "final Map<String, dynamic> ${keys[i]};\n";
        } else {
          variables += "final ${values[i].runtimeType} ${keys[i]};\n";
        }
        constructorArgs += "this.${keys[i]}, ";
        fromJsonArgs += "${keys[i]} = json['${keys[i]}'],\n";
        toJsonArgs += "'${keys[i]}': ${keys[i]},\n";
      }
    }

    return '''
    class $className {
      ${variables.trim()}
    
    $className($constructorArgs);
    
    $className.fromJsonArgs(Map<String, dynamic> json)
       : ${fromJsonArgs.trim()};
       
    Map<String, dynamic> toJsonArgs() => {
        ${toJsonArgs.trim()}
      };
     }
    ''';
  }
}
