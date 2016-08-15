/// @title A multisignatory loan contract
// TODO: implement a cancel method that could also have some rules
contract LoanContract {
  enum State { Created, BorrowerSigned, Active, Cancelled }
  
  string hashOfContract; // The SHA256 hash of the terms of the contract
  
  // The participants
  
  address executor; // The "controlling" entity for the contract
  address[] borrowers;
  address lender;
  address counterFraud;

  struct SignatureTracking {
    uint borrowerCount;
    bool lender;
    bool counterFraud;
  }

  SignatureTracking signatures;

  
  function LoanContract(string _hashOfContract,
		address[] _borrowers,
		address _lender,
		address _counterFraud) {
    executor = msg.sender;
    
    hashOfContract = _hashOfContract;
    borrowers = _borrowers;
    lender = _lender;
    counterFraud = _counterFraud;
  }

  modifier onlyBorrower() {
    uint borrowerMatch = 0;
    for (uint i = 0; i < borrowers.length; i++) {
      if (borrowers[i] == msg.sender) {
        borrowerMatch++;
      }
    }
    if (borrowerMatch > 1) throw;
    if (borrowerMatch ==0) throw;
    _
  }

  modifier onlyLender() {
    if (msg.sender != lender) throw;
    _
  }

  modifier onlyCounterFraud() {
    if (msg.sender != counterFraud) throw;
    _
  }

  modifier inState(State _state) {
    if (_state != status()) throw;
    _
  }

  // The hash gets passed in by each party so we can check it matches the one that we created.
  function sign_borrower(string _hashOfContract)
    onlyBorrower()
    inState(State.Created)
  {
    signatures.borrowerCount ++;
  }

  function sign_lender(string _hashOfContract)
    onlyLender()
    inState(State.BorrowerSigned)
  {
    signatures.lender = true;
  }

  function sign_counter_fraud(string _hashOfContract)
    onlyCounterFraud()
    inState(State.BorrowerSigned)
  {
    signatures.counterFraud = true;
  }

  // TODO: Work out what to do about cancelling
  function status() returns (State status) {
    status = State.Created;
    if (signatures.borrowerCount == borrowers.length) {
      if (signatures.lender && signatures.counterFraud) {
        status = State.Active;
      }
    }
    return status;
  }
  
  function () {
    // gets executed if invalid data is sent
    throw;
  }
  
  
}
