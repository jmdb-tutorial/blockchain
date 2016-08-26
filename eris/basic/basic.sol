/// @title A multisignatory loan contract
// TODO: implement a cancel method that could also have some rules
contract BasicContract {
  uint stateInteger;
  string stateString;

  function BasicContract(uint x) {
    stateInteger = x;
    stateString = "foo";
  }

  function setStateInt(uint x) {
    stateInteger = x;
  }
  
  function getStateInt() returns (uint state) {
    return stateInteger;
  }

  function setStateString(string s) {
    stateString = s;
  }

  function getStateString() returns (string s) {
    return stateString;
  }
  
}
