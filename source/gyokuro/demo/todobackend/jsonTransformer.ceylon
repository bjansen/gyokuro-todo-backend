import net.gyokuro.transform.api {
    Transformer
}
import ceylon.json {
    JsonObject,
    parse
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

    shared actual String serialize(Object o) {
        if (is Todo o) {
            return JsonObject {
                "title" -> o.title
            }.string;
        }

        return "{}";
    }

}