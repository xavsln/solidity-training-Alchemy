// SPDX-License-Identifier: Unlicensed

// A very simple Smart Contract that allows to:
// 1. Assign a value to a State Variable myNumber
// 2. Return the value of this State Variable (as an alternative to the getMyNumber() function, we could declare myNumber as public (this would create a getter function for us))


pragma solidity 0.8.17;

contract SimpleNumber {
    uint myNumber;

    function setMyNumber(uint _myNumber) public {
        myNumber = _myNumber;
    }

    function getMyNumber() public view returns(uint) {
        return myNumber;
    }
}
