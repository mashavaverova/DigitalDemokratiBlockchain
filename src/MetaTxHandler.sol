// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.18;

import {Polls} from "./Polls.sol";
import {GasPrepaidManager} from "./GasPrepaidManager.sol";
import "forge-std/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MetaTxHandler
 * @notice This contract handles meta-transactions for voting, allowing off-chain signature verification
 *         and relayed transactions to the Polls contract for gasless voting.
 * @dev The MetaTxHandler contract interacts with an instance of the Polls contract, enabling
 *      verified votes to be relayed by an authorized relayer. The relayer is initially set to the
 *      deployer but can be changed by the contract owner.
 */
contract MetaTxHandler is Ownable {
    // -------------------- State Variables --------------------
    Polls public pollsContract;
    GasPrepaidManager public gasPrepaidManager;
    address public relayer; // Address of the authorized relayer

    // -------------------- Events --------------------
    event Debug(address voter, uint256 pollId, uint256 proposalId, uint8 score, uint256 group);
    event RelayerSet(address indexed newRelayer);

    // -------------------- Constructor --------------------
    /**
     * @param _pollsContract Address of the Polls contract instance.
     * @param _gasPrepaidManager Address of the GasPrepaidManager contract.
     */
    constructor(address _pollsContract, address _gasPrepaidManager) {
        pollsContract = Polls(_pollsContract);
        gasPrepaidManager = GasPrepaidManager(_gasPrepaidManager);
        relayer = msg.sender; // Initially, the deployer is the relayer
    }

    // -------------------- Modifiers --------------------
    /**
     * @dev Restricts access to the relayer.
     */
    modifier onlyRelayer() {
        require(msg.sender == relayer, "Only the relayer can call this function");
        _;
    }

    // -------------------- External Functions --------------------

    /**
     * @notice Allows the owner to set a new relayer address.
     * @dev Only callable by the owner of the contract.
     * @param _relayer The new relayer address.
     */
    function setRelayer(address _relayer) external onlyOwner {
        require(_relayer != address(0), "Relayer address cannot be zero");
        relayer = _relayer;
        emit RelayerSet(_relayer);
    }

    /**
     * @notice Processes a meta-vote after off-chain verification.
     * @dev Only the relayer can call this function after verifying the voter's signature off-chain.
     *      Deducts gas costs from the prepaid balance in GasPrepaidManager.
     * @param _pollId The ID of the poll.
     * @param _proposalId The ID of the proposal within the poll.
     * @param _score The score for the vote.
     * @param voter The address of the voter.
     * @param _group The ID of the group in which the voter is participating.
     */
    function handleMetaVote(
        uint256 _pollId,
        uint256 _proposalId,
        uint8 _score,
        address voter,
        uint256 _group
    ) external onlyRelayer {
        uint256 initialGas = gasleft();
        emit Debug(voter, _pollId, _proposalId, _score, _group);
        pollsContract.vote(_pollId, _proposalId, _score, _group);
        uint256 gasUsed = initialGas - gasleft();
        gasPrepaidManager.payGas(msg.sender, gasUsed, tx.gasprice);
    }
}
