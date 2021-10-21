pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Multiply {

	uint mult = 1;

	// Function that multiplies its argument (from 1 to 10) by a state variable.
	function multiply(uint value) public returns(uint){
		tvm.accept();
		require(value >= 1, 123, "Enter a number from 1 to 10 inclusive");
		require(value <= 10, 123, "Enter a number from 1 to 10 inclusive");
		return mult *= value;
	}
}