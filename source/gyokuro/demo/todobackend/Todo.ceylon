variable Integer sequence = 0;

class Todo(title, completed = false, order = -1) {
    shared variable String title;
    shared variable Boolean completed;
    shared Integer order;

    shared Integer id = sequence++;
    shared variable String url = "/todo/``id``";
}
