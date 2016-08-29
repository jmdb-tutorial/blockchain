/// @title A multisignatory loan contract
// TODO: implement a cancel method that could also have some rules
contract LoanContract {
  enum State { Created, BorrowerSigned, ReadyToPay, Active, Cancelled }

  struct SignatureTracking {
    uint borrowerCount;
    bool lender;
    bool counterFraud;
  }
  
  address executor; // The "controlling" entity for the contract  
  address lender;
  address counterFraud;
  address[] borrowers;

  string hashOfContract;

  SignatureTracking signatures;

  function LoanContract(address _lender, address _counterFraud) {
    lender = _lender;
    counterFraud = _counterFraud;
    executor = msg.sender;
  }

  // Our loan system would listen for this so that it could make the loan payment
  event ReadyToPay(address loanContract);

  modifier onlyExecutor() {
    if (msg.sender != executor) throw;
    _
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

  function initialise (string _hashOfContract, address _lender, address _counterFraud)
    onlyExecutor()
  {
    hashOfContract = _hashOfContract;
    lender = _lender;
    counterFraud = _counterFraud;
  }

  function addBorrower(address addr)
    onlyExecutor()
  {
    borrowers.push(addr);
  }
    

  function getHashOfContract() constant returns (string) {
    return hashOfContract;
  }

  function getExecutor() constant returns (address) {
    return executor;
  }    

  function getLender() constant returns (address) {
    return lender;
  }

  function getCounterFraud() constant returns (address) {
    return counterFraud;
  }

  function getBorrowerCount() constant returns (uint) {
    return borrowers.length;
  }

  function getBorrower(uint x) constant returns (address) {
    return borrowers[x];
  }

  function getSignatureCount() constant returns (uint) {
    return signatures.borrowerCount;
  }

  function getCounterFraudSigned() constant returns (bool) {
    return signatures.counterFraud;
  }

  // The hash gets passed in by each party so we can check it matches the one that we created.
  function sign(string _hashOfContract)
    onlyBorrower()
    inState(State.Created)
  {
    signatures.borrowerCount ++;
  }

  function approve(string _hashOfContract)
    onlyCounterFraud()
    inState(State.BorrowerSigned)
  {
    signatures.counterFraud = true;
    //  ReadyToPay(this);
  }

  
   function paid(string _hashOfContract)
    onlyLender()
    inState(State.ReadyToPay)
  {
    signatures.lender = true;
  }


  // TODO: Work out what to do about cancelling
  function getStatus() constant returns (State status) {
    status = State.Created;
    
    if (signatures.borrowerCount == borrowers.length) {
      status = State.BorrowerSigned;
      
      if (signatures.counterFraud) {
        status = State.ReadyToPay;
        
        if (signatures.lender) {
          status = State.Active;
        } 
      }     
    }
    return status;
  }
  

}
