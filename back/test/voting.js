const Voting = artifacts.require("Voting")
const { expectEvent, BN} = require('@openzeppelin/test-helpers')

const WorkflowStatus = Object.freeze({
    RegisteringVoters: 0,
    ProposalsRegistrationStarted: 1,
    ProposalsRegistrationEnded: 2,
    VotingSessionStarted: 3,
    VotingSessionEnded: 4,
    VotesTallied: 5
});


contract("Voting", (accounts) => {
    const [owner, voter1, voter2, voter3] = accounts

    let voting

    const proposal1 = "Proposition 1"
    const proposal2 = "Proposition 2"

    beforeEach(async () => {
        voting = await Voting.new({from: owner})
        await voting.registerVoters([voter1, voter2, voter3], {from: owner})
    });

    it('should start proposal', async () => {
        let event = await voting.startProposalsRegistration()

        expectEvent(event, 'WorkflowStatusChange', {previousStatus: new BN('0'), newStatus: new BN('1')})
    })
})