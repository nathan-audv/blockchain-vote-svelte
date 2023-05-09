<script setup lang="ts">
import Voting from '../../../back/build/contracts/Voting.json'
import {onMounted, ref} from "vue";
import getWeb3 from './assets/getWeb3.js'
import InputWhiteList from "@/components/admin/InputWhiteList.vue";
import ShowProposal from "@/components/admin/ShowProposal.vue";
import StartVote from "@/components/admin/StartVote.vue";
import FinishVote from "@/components/admin/FinishVote.vue";
import TallyVote from "@/components/admin/TallyVote.vue";
import AddProposal from "@/components/user/AddProposal.vue";
import Navbar from "@/components/Navbar.vue";
import ViewVotes from "@/components/user/ViewVotes.svelte";
import UserVote from "@/components/user/UserVote.svelte";


const web3var = ref(null)
const accountsvar = ref(null)
const contractvar = ref(null)
const userAddressvar = ref(null)
const isOwnervar = ref(false)


onMounted(async () => {
    try {
        // Get network provider and web3 instance.
        const web3 = await getWeb3()

        // Use web3 to get the user's accounts.
        /* on récupère le tableau des comptes sur le metamask du user */
        const accounts = await web3.eth.getAccounts()

        // Get the contract instance.
        const networkId = await web3.eth.net.getId()
        const deployedNetwork = Voting.networks[networkId]
        console.log("deployedNetwork", deployedNetwork)
        /* Création de l'objet de contrat avec l'abi, le deployedNetwork et son address  */
        const instance = new web3.eth.Contract(
            Voting.abi,
            deployedNetwork && deployedNetwork.address
        )

        // Set web3, accounts, and contract to the state, and then proceed with an
        // example of interacting with the contract's methods.
        web3var.value = web3
        accountsvar.value = accounts
        contractvar.value = instance
        userAddressvar.value = accountsvar.value[0]

        // Check if the user is the owner
        const owner = await instance.methods.owner().call()
        if (userAddressvar.value === owner) {
            isOwnervar.value = true
        }
    } catch (error) {
        // Catch any errors for any of the above operations.
        alert(
            `Failed to load web3, accounts, or contract. Check console for details.`
        )
        console.error(error)
    }
})
const startProposal = (reactiveData: string[]) => {
    contractvar.value.methods.registerVoters(reactiveData).send({from: accountsvar.value[0]})
    contractvar.value.methods.startProposalsRegistration().send({from: accountsvar.value[0]})
}

const endProposal = () => {
    contractvar.value.methods.endProposalsRegistration().send({from: accountsvar.value[0]})
}

const makeProposal = (value: string) => {
    contractvar.value.methods.registerProposal(value).send({from: accountsvar.value[0]})
}

const startVote = () => {
    contractvar.value.methods.startVotingSession().send({from: accountsvar.value[0]})
}

const endVoting = () => {
    contractvar.value.methods.endVotingSession().send({from: accountsvar.value[0]})
}

const tallyVote = () => {
    contractvar.value.methods.tallyVotes().send({from: accountsvar.value[0]})
}

</script>

<template>
    <navbar :userAddressvar="userAddressvar"></navbar>
    <div v-if="isOwnervar">
        <input-white-list @startProposal="startProposal"></input-white-list>
    </div>
    <div v-if="isOwnervar">
        <show-proposal :contractvar="contractvar" @endProposal="endProposal"></show-proposal>
    </div>
    <div v-if="isOwnervar">
        <start-vote @startVote="startVote"></start-vote>
    </div>
    <div v-if="isOwnervar">
        <finish-vote @endVoting="endVoting"></finish-vote>
    </div>
    <div v-if="isOwnervar">
        <tally-vote @tallyVote="tallyVote"></tally-vote>
    </div>
    <div v-if="isOwnervar">
        <add-proposal @makeProposal="makeProposal"></add-proposal>
    </div>
    <div v-if="isOwnervar">
        <user-vote :contractvar="contractvar" :accountsvar="accountsvar"></user-vote>
    </div>
    <div v-if="isOwnervar">
        <view-votes :contractvar="contractvar"></view-votes>
    </div>
</template>


<style scoped>
</style>
