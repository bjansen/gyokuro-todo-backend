import net.gyokuro.transform.api {
    Transformer
}
import ceylon.json {
    JsonObject,
    parse,
    JsonArray
}
import ceylon.interop.java {
    javaClass
}

object jsonTransformer satisfies Transformer {

    contentTypes => ["application/json"];

    shared actual Instance deserialize<Instance>(String serialized)
            given Instance satisfies Object {

        if (`Instance` == `Todo`,
            is JsonObject json = parse(serialized),
            is Instance todo = Todo {
                title = json.getString("title");
            }) {

            return todo;
        }

        return javaClass<Instance>().newInstance();
    }

    function serializeTodo(Todo o) =>
            JsonObject {
                "title" -> o.title,
                "completed" -> o.completed
            };

    shared actual String serialize(Object o) {
        if (is List<Todo> o) {
            return JsonArray {
                for (todo in o)
                serializeTodo(todo)
            }.string;
        }

        if (is Todo o) {
            return serializeTodo(o).string;
        }

        return "{}";
    }

}