/// @title A multisignatory loan contract
// TODO: implement a cancel method that could also have some rules
contract BasicContract {
  uint A;
  uint B;
  string C;
  address creator;
  address user;

  function BasicContract(uint _A, uint _B,
		 string _C) {
    A = _A;
    B = _B;
    C = _C;
    creator = msg.sender;
  }

  function initialise(uint _A, uint _B,
	          string _C, address _user) {
    A = _A;
    B = _B;
    C = _C;
    user = _user;
  }
  
  function setA(uint x) {
    A = x;
  }

  function setB(uint x) {
    B = x;
  }
  
  function setC(string s) {
    C = s;
  }

  function getA() constant returns (uint) {
    return A;
  }
  
  function getB() constant returns (uint) {
    return B;
  }
  
  function getC() constant returns (string) {
    return C;
  }

  function getCreator() constant returns (address) {
    return creator;
  }

  function getUser() constant returns (address) {
    return user;
  }

  
}
