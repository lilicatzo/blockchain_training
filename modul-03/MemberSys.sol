// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract MembershipSystem {
    mapping(address => bool) public members;
    
    event MemberAdded(address newMember);
    event MemberRemoved(address existingMember);

    function addMember(address newMember) external {
        members[newMember] = true;
        emit MemberAdded(newMember);
    }

    function removeMember(address existingMember) external {
        members[existingMember] = false;
        emit MemberRemoved(existingMember);
    }

    function isMember(address checkAddress) external view returns (bool) {
        return members[checkAddress];
    }

    receive() external payable {}
    fallback() external payable {}
}
