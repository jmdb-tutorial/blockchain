/// @title A multisignatory loan contract
// TODO: implement a cancel method that could also have some rules
contract LoanContract {
  enum State { Created, BorrowerSigned, ReadyToPay, Active, Cancelled }

  struct SignatureTracking {
    uint borrowerCount;
    bool lender;
    bool counterFraud;
  }

  // Our loan system would listen for this so that it could make the loan payment
  event ReadyToPay(address loanContract);

  modifier onlyExecutor() {
    if (msg.sender != executor) throw;
    _
  }

  
  address executor; // The "controlling" entity for the contract  
  address lender;
  address counterFraud;
  address[] borrowers;

  string hashOfContract;

  SignatureTracking signatures;

  function LoanContract(string _hashOfContract, address _lender, address _counterFraud) {
    hashOfContract = _hashOfContract;
    lender = _lender;
    counterFraud = _counterFraud;
    executor = msg.sender;
  }

  // Can't initialise constructor from epm at the moment - waiting for rc3
  function initialise (string _hashOfContract, address _lender, address _counterFraud)
    onlyExecutor()
  {
    hashOfContract = _hashOfContract;
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
    if (_state != getStatus()) throw;
    _
  }

  // --------------------
  // this is copied from https://github.com/ethereum/dapp-bin/blob/master/library/stringUtils.sol
  // --------------------

  /// @dev Does a byte-by-byte lexicographical comparison of two strings.
  /// @return a negative number if `_a` is smaller, zero if they are equal
  /// and a positive numbe if `_b` is smaller.
  function compare(string _a, string _b) returns (int) {
    bytes memory a = bytes(_a);
    bytes memory b = bytes(_b);
    uint minLength = a.length;
    if (b.length < minLength) minLength = b.length;
    //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
    for (uint i = 0; i < minLength; i ++)
      if (a[i] < b[i])
        return -1;
      else if (a[i] > b[i])
        return 1;
    if (a.length < b.length)
      return -1;
    else if (a.length > b.length)
      return 1;
    else
      return 0;
  }

  // --------------------

  modifier hashOfContractsMustMatch(string testHash) {
    if (compare(hashOfContract, testHash) != 0) throw;
    _
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
    hashOfContractsMustMatch(_hashOfContract)
  {    
    signatures.borrowerCount ++;
  }

  function approved(string _hashOfContract)
    onlyCounterFraud()
    inState(State.BorrowerSigned)
    hashOfContractsMustMatch(_hashOfContract)
  {
    signatures.counterFraud = true;
    ReadyToPay(this);
  }

  
   function paid(string _hashOfContract)
    onlyLender()
    inState(State.ReadyToPay)
    hashOfContractsMustMatch(_hashOfContract)
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
