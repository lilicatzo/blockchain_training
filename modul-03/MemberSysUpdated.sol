// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract UpgradedMembershipSystem {
    enum MembershipType { Basic, Premium }

    struct Member {
        uint256 id;
        string name;
        uint256 balance;
        MembershipType membershipType;
    }

    mapping(address => Member) public members;

    //ID-nya mulai dr 1 instead of 0
    uint256 public nextMemberId = 1; 

    event MemberAdded(address newMember, uint256 id);
    event MemberRemoved(address member);
    event MemberUpdated(address member, string name, uint256 balance, MembershipType membershipType);

    function addMember(address newMember, string memory name, MembershipType membershipType) external {
        members[newMember] = Member(nextMemberId, name, 0, membershipType);
        emit MemberAdded(newMember, nextMemberId);
        nextMemberId++;
    }

    function removeMember(address member) external {
        delete members[member];
        emit MemberRemoved(member);
    }

    function isMember(address member) external view returns (bool) {
        return members[member].id != 0;
    }

    function updateMember(address member, string memory name, uint256 balance, MembershipType membershipType) external {
        require(members[member].id != 0, "Member does not exist");
        members[member].name = name;
        members[member].balance = balance;
        members[member].membershipType = membershipType;
        emit MemberUpdated(member, name, balance, membershipType);
    }

    function getMember(address member) external view returns (uint256, string memory, uint256, MembershipType) {
        Member memory m = members[member];
        require(m.id != 0, "Member does not exist");
        return (m.id, m.name, m.balance, m.membershipType);
    }

    receive() external payable {}
    fallback() external payable {}
}
