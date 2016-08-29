/// @title A multisignatory loan contract
// TODO: implement a cancel method that could also have some rules
contract BasicContract {
  uint stateIntA;
  uint stateIntB;
  string stateString;

  function BasicContract() {
  }

  function initialise(uint _stateIntA, uint _stateIntB, string _stateString) {
    stateIntA = _stateIntA;
    stateIntB = _stateIntB;
    stateString = _stateString;
  }
  
  function setStateIntA(uint x) {
    stateIntA = x;
  }

  function setStateIntB(uint x) {
    stateIntB = x;
  }
  
  function setStateString(string s) {
    stateString = s;
  }

  function getStateIntA() constant returns (uint) {
    return stateIntA;
  }
  
  function getStateIntB() constant returns (uint) {
    return stateIntB;
  }
  
  function getStateString() constant returns (string) {
    return stateString;
  }

  
}
