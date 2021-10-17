pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract taskList {

	struct task {
        string caseName;
        uint32 timeOfAddition;
        bool completionFlag;
    }
    mapping (int8 => task) public tasks;
    int8 totalTasks = 0;
    int8 delTasks = 0;

    // Function is called if key is not found
    function noKeyToTask(int8 keyToTask) private inline returns (string) {
        string keys;
        for ((int8 key,) : tasks) {
            keys += format("{}, ", key);
        }
        return format("There is no task with the {} key. You need to select one of the following keys: {}",
                keyToTask, keys.substr(0,keys.byteLength()-2));
    }

	// Add task (sequential integer key is filled into the mapping)
	function addTask(string taskName) public returns (string){
        tvm.accept();
        totalTasks += 1;
        task mytask = task(taskName, now, false);
        tasks[totalTasks] = mytask;
        return format("task '{}' added", tasks[totalTasks].caseName);
	}

    // Get number open tasks (returns number)
	function numberOpenTasks() public returns (string){
        tvm.accept();
        if (totalTasks > 0) {
            int8 openTasks = 0;
            for ((int8 key,) : tasks) {
                if (!tasks[key].completionFlag) {
                    openTasks += 1;
                }
            }
            return format("{} tasks are open", openTasks);
        }
        else {
            return "No tasks";
        }     
	}

    // Get list tasks
	function getListTasks() public returns (string){
        tvm.accept();
        if (totalTasks > 0) {
            string listTasks;
            for ((int8 key,) : tasks) {
                listTasks += tasks[key].caseName + ", ";
            }
            return format("Task list: {}", listTasks.substr(0,listTasks.byteLength()-2));
        }
        else {
            return "No tasks";
        }     
	}

    // Get description task by key
	function descriptionTaskByKey(int8 keyToTask) public returns (string){
        tvm.accept();
        if (totalTasks > 0) {
            if  (tasks[keyToTask].caseName == "") {
                return noKeyToTask(keyToTask);
            }
            return format("The key {} corresponds to task {}", keyToTask, tasks[keyToTask].caseName); 
        }
        else {
            return "No tasks";
        }
             
	}

    // Delete task by key
	function deleteTaskByKey(int8 keyToTask) public returns (string){
        tvm.accept();
        if (totalTasks > 0) {
            if (delTasks != totalTasks) {
                if  (tasks[keyToTask].caseName == "") {
                   return noKeyToTask(keyToTask);
                   }
                delTasks += 1;
                string taskToDel = tasks[keyToTask].caseName;
                delete tasks[keyToTask];
                if (delTasks != totalTasks) {
                    return format("Task {} has been deleted", taskToDel);
                }
                else {
                    mapping (int8 => task) tasks;
                    delTasks = totalTasks = 0;
                    return format("Task {} has been deleted. No more tasks", taskToDel);
                }
            }
            
        }
        else {
            return "No tasks";
        }     
	}

    // Mark task as completed by key
    function taskCompleted(int8 keyToTask) public returns (string){
        tvm.accept();
        if (totalTasks > 0) {
            if  (tasks[keyToTask].caseName == "") {
                return noKeyToTask(keyToTask);
            }
            tasks[keyToTask].completionFlag = true;
            return format("Task {} is completed", tasks[keyToTask].caseName); 
        }
        else {
            return "No tasks";
        } 
             
	}
}