// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title A voting system
/// @author Wsh on est vraiment 8 ? / Modified by Nathan
/// @notice This system permit users to make proposals and vote them
contract Voting is Ownable {

    // Structures de données

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    struct Proposal {
        string description;
        uint voteCount;
    }

    // Énumération des états du processus de vote

    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }

    uint winningProposalId;

    // Événements

    event VoterRegistered(address voterAddress);
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    event ProposalRegistered(uint proposalId);
    event Voted (address voter, uint proposalId);

    // Variables d'état

    mapping(address => Voter) voters;
    Proposal[] proposals;
    WorkflowStatus currentWorkflowStatus;

    // Modificateurs

    modifier onlyVoters() {
        require(voters[msg.sender].isRegistered, "You are not registered to vote.");
        _;
    }

    modifier onlyDuringVotingSession() {
        require(currentWorkflowStatus == WorkflowStatus.VotingSessionStarted, "The voting session is not active.");
        _;
    }

    modifier onlyAfterVotingSessionEnded() {
        require(currentWorkflowStatus == WorkflowStatus.VotingSessionEnded, "The voting session is still active.");
        _;
    }

    modifier onlyDuringProposalsRegistration() {
        require(currentWorkflowStatus == WorkflowStatus.ProposalsRegistrationStarted, "Proposals registration is not active.");
        _;
    }

    modifier onlyAfterProposalsRegistrationEnded() {
        require(currentWorkflowStatus == WorkflowStatus.ProposalsRegistrationEnded, "Proposals registration is still active.");
        _;
    }

    /// @notice Is address a voter
    /// @param _address : Address of voter
    /// @return bool : is voter
    function isVoter(address _address) external view returns (bool){
        if(voters[_address].isRegistered) {
            return true;
        }
        return false;
    }

    /// @notice Get workflow status
    /// @return WorkflowStatus : current status
    function getWorkflowStatus() external view returns (WorkflowStatus) {
        return currentWorkflowStatus;
    }

    /// @notice Get a proposal by id
    /// @param _proposalId : Id of the proposal
    /// @return Proposal : Proposal object
    function getOneProposal(uint _proposalId) external view returns (Proposal memory){
        return proposals[_proposalId];
    }

    /// @notice Get proposal array length to get array in front
    /// @custom:accessibility External
    function getProposalsLength() external view returns (uint){
        return proposals.length;
    }

    // Fonctions d'administration

    /// @notice Register voters
    /// @param _voters : Address of voters
    /// @custom:accessibility Admin
    function registerVoters(address[] memory _voters) external onlyOwner {
        // Vérifie que l'état courant du workflow est en cours d'inscription des électeurs.
        require(currentWorkflowStatus == WorkflowStatus.RegisteringVoters, "Cannot register voters at this time.");
        // Boucle sur la liste des adresses d'électeurs fournie et vérifie que chaque électeur n'est pas déjà enregistré.
        for (uint i = 0; i < _voters.length; i++) {
            require(!voters[_voters[i]].isRegistered, "Voter already registered.");
            // Enregistre l'électeur comme étant enregistré.
            voters[_voters[i]].isRegistered = true;
            // Émet un événement pour signaler que l'électeur a été enregistré.
            emit VoterRegistered(_voters[i]);
        }
    }

    /// @notice Start proposal session
    /// @custom:accessibility Admin
    function startProposalsRegistration() external onlyOwner {
        // Vérifie que l'état courant du workflow est en cours d'inscription des électeurs.
        require(currentWorkflowStatus == WorkflowStatus.RegisteringVoters, "Cannot start proposals registration at this time.");
        // Modifie l'état courant du workflow pour indiquer que l'inscription des propositions a commencé.
        currentWorkflowStatus = WorkflowStatus.ProposalsRegistrationStarted;
        // Émet un événement pour signaler que l'état du workflow a changé.
        emit WorkflowStatusChange(WorkflowStatus.RegisteringVoters, currentWorkflowStatus);
    }

    /// @notice End proposal session
    /// @custom:accessibility Admin
    function endProposalsRegistration() external onlyOwner {
        // Vérifie que l'état courant du workflow est en cours d'inscription des propositions.
        require(currentWorkflowStatus == WorkflowStatus.ProposalsRegistrationStarted, "Cannot end proposals registration at this time.");
        // Modifie l'état courant du workflow pour indiquer que l'inscription des propositions est terminée.
        currentWorkflowStatus = WorkflowStatus.ProposalsRegistrationEnded;
        // Émet un événement pour signaler que l'état du workflow a changé.
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationStarted, currentWorkflowStatus);
    }

    /// @notice Start voting session
    /// @custom:accessibility Admin
    function startVotingSession() external onlyOwner {
        // Vérifie que l'état courant du workflow est l'inscription des propositions terminée.
        require(currentWorkflowStatus == WorkflowStatus.ProposalsRegistrationEnded, "Cannot start voting session at this time.");
        // Modifie l'état courant du workflow pour indiquer que la session de vote a commencé.
        currentWorkflowStatus = WorkflowStatus.VotingSessionStarted;
        // Émet un événement pour signaler que l'état du workflow a changé.
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationEnded, currentWorkflowStatus);
    }

    /// @notice End voting session
    /// @custom:accessibility Admin
    function endVotingSession() external onlyOwner {
        // Vérifie que l'état courant du workflow est la session de vote en cours.
        require(currentWorkflowStatus == WorkflowStatus.VotingSessionStarted, "Cannot end voting session at this time.");
        // Modifie l'état courant du workflow pour indiquer que la session de vote est terminée.
        currentWorkflowStatus = WorkflowStatus.VotingSessionEnded;
        // Émet un événement pour signaler que l'état du workflow a changé.
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionStarted, currentWorkflowStatus);
    }

    /// @notice For users to register proposal
    /// @param _description : Description of their proposal
    /// @custom:accessibility Voters
    function registerProposal(string memory _description) external onlyVoters onlyDuringProposalsRegistration {
        // La fonction permet à un électeur enregistré de proposer une nouvelle proposition pendant la période d'enregistrement des propositions.
        require(keccak256(abi.encodePacked(_description)) != keccak256(""), "Proposal can't be null");
        for (uint i = 0; i < proposals.length; i++) {
            require(keccak256(abi.encodePacked(proposals[i].description)) != keccak256(abi.encodePacked(_description)), "Proposal already registered.");
            proposals.push(Proposal({
                description: _description,
                voteCount: 0
            }));
            // Ajouter une nouvelle proposition à la liste des propositions existantes et émettre un événement.
            emit ProposalRegistered(proposals.length - 1);
        }
    }

    /// @notice For users to vote
    /// @param _proposalId : Id of proposal
    /// @custom:accessibility Voters
    function vote(uint _proposalId) external onlyVoters onlyDuringVotingSession {
        // Récupère le votant actuel depuis le mapping de votants
        Voter storage voter = voters[msg.sender];
        // Vérifie si le votant n'a pas déjà voté
        require(!voter.hasVoted, "You have already voted.");
        // Enregistre le vote et le votant dans les mappings correspondants
        voter.hasVoted = true;
        voter.votedProposalId = _proposalId;
        // Incrémente le compteur de votes pour la proposition correspondante
        proposals[_proposalId].voteCount++;
        // Émet un événement pour signaler que le votant a voté pour la proposition correspondante
        emit Voted(msg.sender, _proposalId);
    }

    /// @notice Tally votes after ending voting session
    /// @custom:accessibility Admin
    function tallyVotes() external onlyOwner onlyAfterVotingSessionEnded {
        // Initialise le compteur de votes gagnants à zéro et l'indice de la proposition gagnante à zéro
        uint winningVoteCount = 0;
        uint winningProposalIndex = 0;
        // Parcourt toutes les propositions enregistrées
        for (uint i = 0; i < proposals.length; i++) {
            // Si le nombre de votes pour la proposition actuelle est supérieur au nombre de votes gagnants, alors la proposition actuelle devient la proposition gagnante
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposalIndex = i;
            }
        }
        // Enregistre l'ID de la proposition gagnante et met à jour le statut de workflow
        winningProposalId = winningProposalIndex;
        currentWorkflowStatus = WorkflowStatus.VotesTallied;
    }

    function test() external pure returns (uint) {
        return 1;
    }

}
