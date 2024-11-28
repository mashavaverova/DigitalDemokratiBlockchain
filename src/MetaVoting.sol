// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./ProposalHelpers.sol";
import "./GasPrepaidManager.sol";
import "forge-std/console.sol";

/**
 * @title MetaVoting
 * @notice This contract enables meta-transactions for voting, allowing a relayer to submit votes on behalf
 *         of users. It facilitates gasless voting through a relayer who covers the transaction fees.
 * @dev This contract interacts with ProposalHelpers to record votes, using a designated relayer to submit
 *      meta-transaction votes for participants in various polls.
 *
 * Inherits:
 * - `Ownable`: Allows only the contract owner to assign the relayer.
 *
 * State Variables:
 * - `relayer`: The address authorized to submit meta-transactions on behalf of voters.
 * - `proposalHelpersContract`: Reference to the ProposalHelpers contract where votes are recorded.
 *
 * Features:
 * - **Relayer Management**: Enables the contract owner to assign a relayer responsible for submitting votes.
 * - **Meta-Vote Submission**: Allows the relayer to submit a vote via `castVoteMeta` for a specified voter and proposal.
 *
 * Events:
 * - `VoteCastMeta`: Emitted when a meta-vote is successfully cast, providing poll and proposal IDs along with the voter's address.
 *
 * Requirements:
 * - Only the contract owner can change the relayer.
 * - Only the designated relayer can call `castVoteMeta`.
 */
contract MetaVoting is Ownable {
    // -------------------- State Variables --------------------
    ProposalHelpers public proposalHelpersContract; // Reference to ProposalHelpers contract
    GasPrepaidManager public gasManager;

    // -------------------- Events --------------------
    event VoteCastMeta(uint256 indexed pollId, uint256 indexed proposalId, address indexed voter);
    event RelayerSet(address indexed newRelayer);

    // -------------------- Constructor --------------------
      /**
     * @param _proposalHelpersContract Address of the ProposalHelpers contract.
     * @param _gasManager Address of the GasPrepaidManager contract.
     */
    constructor(address _proposalHelpersContract, address _gasManager) {
        proposalHelpersContract = ProposalHelpers(_proposalHelpersContract); // Initialize ProposalHelpers contract
        gasManager = GasPrepaidManager(_gasManager); // Initialize GasPrepaidManager contract
   
    }

    /**
 * @notice Updates the address of the GasPrepaidManager contract.
 * @dev Can only be called by the contract owner.
 * @param _gasManager The new GasPrepaidManager contract address.
 */
function setGasPrepaidManager(address _gasManager) external onlyOwner {
    require(_gasManager != address(0), "Invalid GasPrepaidManager address");
    gasManager = GasPrepaidManager(_gasManager);
    console.log("GasPrepaidManager address updated to:", _gasManager);
}

      // -------------------- External Functions --------------------



    /**
     * @notice Casts a vote via meta-transaction on behalf of a voter.
     * @dev The relayer submits this transaction on behalf of the voter, covering the gas fees via GasPrepaidManager.
     * @param pollId The ID of the poll in which to cast a vote.
     * @param proposalId The ID of the proposal within the poll to vote on.
     * @param voter The address of the voter casting the vote.
     */
   function castVoteMeta(uint256 pollId, uint256 proposalId, address voter) external {
console.log("=== Debugging castVoteMeta ===");
console.log("Caller (msg.sender):", msg.sender);
console.log("Expected Relayer (gasManager.relayer):", gasManager.relayer());
    require(msg.sender == gasManager.relayer(), "Only relayer can submit meta-votes");

    uint256 initialGas = gasleft();
    console.log("Initial Gas:", initialGas);

    // Process the vote
    _processVote(pollId, proposalId, voter);

    // Calculate gas used and pay
    uint256 gasUsed = initialGas - gasleft();
    console.log("Gas Used:", gasUsed);
    console.log("Gas Price:", tx.gasprice);

    gasManager.payGas(gasManager.relayer(), gasUsed, tx.gasprice);

    console.log("=== End Debugging castVoteMeta ===");
}


    // -------------------- Internal Functions --------------------

    /**
     * @dev Internal function to process the vote. Calls recordMetaVote in ProposalHelpers.
     * @param pollId The ID of the poll.
     * @param proposalId The ID of the proposal.
     * @param voter The address of the voter casting the vote.
     */
    function _processVote(uint256 pollId, uint256 proposalId, address voter) internal {
        proposalHelpersContract.recordMetaVote(pollId, proposalId, voter);
        emit VoteCastMeta(pollId, proposalId, voter);
    }
}