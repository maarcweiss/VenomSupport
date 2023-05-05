pragma ever-solidity >= 0.61.2;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "./interfaces/IVote.sol";

contract Ballot {
    address static _vote;
    uint256 static _managerPublicKey;
    // we have a static for owner...so our logic would be like "allow this address to vote"
    // we can store a static here for ballot number, and our logic would been "allow that ballot to vote"
    address static _owner;

    bool _activated; // have ballot already been activated
    bool _used;      // have ballot already been used (vote)

    constructor(address sendRemainingGasTo) public {
        // we are reserving another 0.1 here for paying for future external call
        // all another reserves will be on 0.1 only
        tvm.rawReserve(0.1 ever + 0.1 ever, 0);
        if (msg.sender != _vote) {
            selfdestruct(msg.sender);
        }
        _activated = false;
        _used = false;
        sendRemainingGasTo.transfer({ value: 0, flag: 128, bounce: false });
    }

    // this function will be called by external message, so contract will pay for this call
    // this mechanic exists for moving commision paying to user responsibility
    // in consctructor we reserver a little more venoms, so here we just will use them (with returning remains)
    // useful mechaninc for your dapp
    function activate() external {
        require(msg.pubkey() == _managerPublicKey, 200);
        tvm.accept(); // allow to use contract balance for paying this function execution
        _activated = true;
        tvm.rawReserve(0.1 ever, 0);
        _owner.transfer({ value: 0, flag: 128, bounce: false });
    }

    function vote(address sendRemainingGasTo, bool accept) external {
        require(msg.sender == _owner, 201);
        require(_activated && !_used, 202);
        tvm.rawReserve(0.1 ever, 0);
        // just call our vote contract
        IVote(_vote).onBallotUsed{
            value: 0,
            flag: 128,
            bounce: true
        }(_owner, sendRemainingGasTo, accept);
        _used = true;
    }

    // onBounce function!
    // if our vote contract will reject message, it sends a bounce message to this callback. We should return _used flag to false!
    onBounce(TvmSlice bounce) external {
        uint32 functionId = bounce.decode(uint32);
        // IVote.onBallotUsed send us a bounce message
        if (functionId == tvm.functionId(IVote.onBallotUsed) && msg.sender == _vote) {
            tvm.rawReserve(0.1 ever, 0);
            _used = false;
        }
    }

}