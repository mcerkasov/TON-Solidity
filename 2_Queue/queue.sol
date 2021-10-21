pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Queue {

	string[] public queueArray;

	// Function that adds the name of the next buyer to the end of the array.
	function getInLine(string name) public returns (string){
		tvm.accept();
		queueArray.push(name);
		return format("{}, you got in line, there are {} people in front of you", 
			queueArray[queueArray.length-1], uint(queueArray.length-1));
	}

	// Function that removes the null element in the array.
	function callTheNext() public returns (string){
		tvm.accept();
		if (!queueArray.empty()) {
			for (uint i = 0; i < queueArray.length-1; i++){
			queueArray[i] = queueArray[i+1];
			}
			queueArray.pop();
			return format("There are {} people left in the queue", uint(queueArray.length));
		} 
		return "The queue is over";
	}

}