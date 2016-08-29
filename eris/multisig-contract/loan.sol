/// @title A multisignatory loan contract
// TODO: implement a cancel method that could also have some rules
contract LoanContract {
  enum State { Created, BorrowerSigned, ReadyToPay, Active, Cancelled }
  
  string hashOfContract;
  
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

  function LoanContract(address _lender, address _counterFraud, address[] _borrowers) {
    lender = _lender;
    counterFraud = _counterFraud;
    borrowers = _borrowers;
    executor = msg.sender;
  }

  // Our loan system would listen for this so that it could make the loan payment
  event ReadyToPay(address loanContract);

  modifier onlyExecutor() {
    if (msg.sender != executor) throw;
    _
  }

  function initialise (string _hashOfContract, address _lender, address _counterFraud)
  {
    hashOfContract = _hashOfContract;
    lender = _lender;
    counterFraud = _counterFraud;
  }

  function addBorrower(address addr) {
    borrowers.push(addr);
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
    if (_state != getStatus()) throw;
    _
  }

  // The hash gets passed in by each party so we can check it matches the one that we created.
  function sign(string _hashOfContract)
    onlyBorrower()
    inState(State.Created)
  {
    signatures.borrowerCount ++;
  }

  function paid(string _hashOfContract)
    onlyLender()
    inState(State.ReadyToPay)
  {
    signatures.lender = true;
  }

  function approve(string _hashOfContract)
    onlyCounterFraud()
    inState(State.BorrowerSigned)
  {
    signatures.counterFraud = true;
    ReadyToPay(this);
  }

  // TODO: Work out what to do about cancelling
  function getStatus() returns (State status) {
    status = State.Created;
    if (signatures.borrowerCount == borrowers.length) {
      if (signatures.counterFraud) {
        if (signatures.lender) {
          status = State.Active;
        } else {
          status = State.ReadyToPay;
        }
      }     
    }
    return status;
  }

  function getHashOfContract() returns (string hashOfContract) {
    return hashOfContract;
  }

  function getExecutor() returns (address executor) {
    return msg.sender;
  }
  
  function () {
    // gets executed if invalid data is sent
    throw;
  }
  
  
}
