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
                title = json.getStringOrNull("title") else "";
                completed = json.getBooleanOrNull("completed") else false;
                order = json.getIntegerOrNull("order") else -1;
            }) {

            return todo;
        } else if (`Instance` == `JsonObject`,
            is Instance json = parse(serialized)) {

            return json;
        }

        return javaClass<Instance>().newInstance();
    }

    function serializeTodo(Todo o) =>
            JsonObject {
                "title" -> o.title,
                "completed" -> o.completed,
                "order" -> o.order,
                "url" -> o.url
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
