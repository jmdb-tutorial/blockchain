/// @title A multisignatory loan contract
// TODO: implement a cancel method that could also have some rules
contract LoanContract {
  enum State { Created, BorrowerSigned, Active, Cancelled };
  
  bytes64 hashOfContract; // The SHA256 hash of the terms of the contract
  State status;

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

  
  function LoanContract(bytes64 _hashOfContract, address[] _borrowers, address _lender, address _counterFraud) {
    executor = msg.sender;
    
    hashOfContract = _hashOfContract;
    borrowers = _borrowers;
    lender = _lender;
    counterFraud = _counterFraud;
  }

  modifier onlyBorrower() {
    uint borrowerMatch = 0;
    for (uint i = 0; i < borrowers.length; i++) {
      if (borrowers[i] = msg.sender) {
        borrowerMatch++;
      }
    }
    if (borrowerMatch > 1) {
      throw;
    }
    return (borrowerMatch == 1);
  }

  // The hash gets passed in by each party so we can check it matches the one that we created.
  function sign_borrower(byte64 _hashOfContract)
    onlyBorrower()
  {
    signatures.borrowerCount ++;
  }

  function sign_lender(byte64 _hashOfContract)
    onlyLender()
  {
    signatures.lenderSigned = true;
  }

  function sign_counter_fraud(byte64 _hashOfContract)
    onlyCounterFraud()
  {
    signatures.counterFraudSigned = true;
  }

  // TODO: Work out what to do about cancelling
  function status() returns (State state) {
    State status = Created;
    if (signature.borrowerCount = borrowers.length) {
      if (signatures.lender && signatures.counterFraud) {
        status = Active;
      }
    }
    return status;
  }
  
  function () {
    // gets executed if invalid data is sent
    throw;
  }
  
  
}
