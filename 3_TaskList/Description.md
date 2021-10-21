# TaskList

Each task has the following structure:
- name of the case;
- time of addition;
- flag of completion of the case (bool).

The structure is placed in the mapping int8 => struct.

Following options available:
- add task (a sequential integer key is filled in the mapping);
- get the number of open tasks (returns a number);
- get a list of tasks;
- get a description of the task by key;
- delete a task by key;
- mark the task as completed by the key.
==================================================
Каждая задача имеет следующую структуру:
- название дела;
- время добавления;
- флаг завершения дела (bool).

Структуру размещаем в сопоставление int8 => struct

Доступны следующие опции:
- добавить задачу (в сопоставлении заполняется последовательный целочисленный ключ);
- получить количество открытых задач (возвращает число);
- получить список задач;
- получить описание задачи по ключу;
- удалить задачу по ключу
- отметить задачу как выполненную по ключу.