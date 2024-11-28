// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.18;

import {Test, console} from "forge-std/Test.sol";
import "../src/ProposalHelpers.sol";
import "../src/MetaVoting.sol";
import "../src/GasPrepaidManager.sol";
import "../src/MetaTxHandler.sol";
import "lib/forge-std/src/console.sol";
import "../src/RightToVote.sol";



contract MetaVotingTest is Test {
    ProposalHelpers public proposalHelpers;
    MetaVoting public metaVoting;
    GasPrepaidManager public gasPrepaidManager;
    MetaTxHandler public metaTxHandler;
    RightToVote public rightToVote;
    Polls public polls;


    address public owner = address(0x1234);
    address public relayer = address(0x5678);
    address public voter = address(0x9ABC);
    address public attacker = address(0xDEAD);

    uint256 public pollId = 1;
    uint256 public proposalId = 0;
    uint256 public groupId = 1; // Add groupId


function setUp() public {
    // Existing setup
    vm.startPrank(owner);
    proposalHelpers = new ProposalHelpers();
    polls = new Polls();
    gasPrepaidManager = new GasPrepaidManager(address(metaVoting), owner);
    metaVoting = new MetaVoting(address(proposalHelpers), address(gasPrepaidManager));
    metaTxHandler = new MetaTxHandler(address(polls), address(gasPrepaidManager));
    rightToVote = new RightToVote(); // Initialize RightToVote

    vm.stopPrank();

    // Set relayer in GasPrepaidManager
    address admin = gasPrepaidManager.admin();
    vm.prank(admin);
    gasPrepaidManager.setRelayer(relayer);

    // Set relayer in MetaTxHandler
    vm.prank(owner);
    metaTxHandler.setRelayer(relayer);

    // Fund admin and create poll
    vm.deal(owner, 1 ether);
    vm.prank(owner);
    gasPrepaidManager.depositFunds{value: 1 ether}();
    vm.prank(owner);
    proposalHelpers.setMetaVoting(address(metaVoting));
    vm.prank(owner);
    polls.createPoll(
        "Sample Poll",
        "General",
        1,
        block.timestamp,
        block.timestamp + 1 days,
        block.timestamp + 2 days,
        block.timestamp + 3 days,
        block.timestamp + 4 days,
        100,
        true
    );
    vm.prank(owner);
    polls.addProposal(1, "Test Proposal");
}

    function testMetaTxHandler() public {
        // Ensure the voter belongs to the group
        console.log("Ensuring voter is a member of the group...");
        vm.startPrank(voter); // Simulate voter action
        rightToVote.becomeMemberOfGroup(groupId); // Add voter to the group
        console.log("Voter has joined group:", groupId);
        vm.stopPrank();

        // Warp to the voting period
        vm.warp(block.timestamp + 2 days); 
        console.log("Warped to timestamp:", block.timestamp);

        // Set gas price
        vm.txGasPrice(1 gwei);
        console.log("Set gas price to:", tx.gasprice);

        // Simulate relayer calling the function
        vm.startPrank(relayer);
        console.log("Starting prank as relayer:", relayer);
        console.log("Calling handleMetaVote with:");
        console.log("pollId:", pollId);
        console.log("proposalId:", proposalId);
        console.log("voter:", voter);

        // Call the function
        metaTxHandler.handleMetaVote(pollId, proposalId, 80, voter, groupId);
        console.log("handleMetaVote executed successfully");
        vm.stopPrank();

        // Verify proposal state
        console.log("Fetching proposal state for pollId:", pollId, "proposalId:", proposalId);
        ProposalHelpers.Proposal memory proposal = proposalHelpers.getProposal(pollId, proposalId);
        console.log("Proposal vote count:", proposal.voteCount);
        console.log("Proposal score:", proposal.score);

        assertEq(proposal.voteCount, 1, "Vote count should be 1");
        assertEq(proposal.score, 80, "Score should be 80");
        console.log("Assertions passed. Test complete.");
    }


    function testCastVoteMeta() public {
        vm.warp(block.timestamp + 2 days); // Move to voting period
        vm.txGasPrice(1 gwei); // Set gas price

        vm.startPrank(relayer);
        metaVoting.castVoteMeta(pollId, proposalId, voter); // Relayer casts vote
        vm.stopPrank();

        // Verify vote was recorded
        bool isRecorded = proposalHelpers.isMetaVoteRecorded(pollId, proposalId, voter);
        assertTrue(isRecorded, "Meta-vote should be recorded");
    }

    function testUnauthorizedRelayer() public {
        vm.startPrank(attacker); // Use unauthorized address
        vm.expectRevert("Only relayer can submit meta-votes");
        metaVoting.castVoteMeta(pollId, proposalId, voter); // Attempt to cast vote
        vm.stopPrank();
    }

    function testHandleMetaVoteUnauthorized() public {
        vm.startPrank(attacker); // Use unauthorized address
        vm.expectRevert("Only the relayer can call this function");
        metaTxHandler.handleMetaVote(pollId, proposalId, 80, voter, 1); // Attempt to handle vote
        vm.stopPrank();
    }
}
