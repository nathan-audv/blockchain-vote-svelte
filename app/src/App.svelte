<script>
    import Voting from '../../back/build/contracts/Voting.json'
    import {onMount} from "svelte";
    import getWeb3 from "../scripts/getWeb3";
    // user components
    import AddProposal from "./components/user/AddProposal.svelte";
    import UserVote from "./components/user/UserVote.svelte";
    import ViewVotes from "./components/user/ViewVotes.svelte";
    //admin components
    import RegisterVoters from "./components/admin/RegisterVoters.svelte";
    import ShowProposal from "./components/admin/ShowProposal.svelte";
    import StartVote from "./components/admin/StartVote.svelte";
    import FinishVote from "./components/admin/FinishVote.svelte";
    import TallyVote from "./components/admin/TallyVote.svelte";
    //other
    import Navbar from "./components/Navbar.svelte";

    let web3var = null
    let accountsvar = null
    let contractvar = null
    let userAddressvar = null
    let workflow
    let isOwnervar
    let isVoter


    onMount(async () => {
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
            web3var = web3
            accountsvar = accounts
            contractvar = instance
            userAddressvar = accountsvar[0]

            // Check if the user is the owner
            const owner = await instance.methods.owner().call()
            if (userAddressvar === owner) {
                isOwnervar = true
            }
        } catch (error) {
            // Catch any errors for any of the above operations.
            alert(
                `Failed to load web3, accounts, or contract. Check console for details.`
            )
            console.error(error)
        }
    })
    setTimeout(delayed, 2000);
    function delayed(){
        contractvar.methods.getWorkflowStatus().call((err1, res1) => {
            workflow = res1
        })

        contractvar.methods.isVoter(accountsvar[0]).call((err1, res1) => {
            isVoter = res1
        })
    }

</script>
<Navbar userAddressvar={userAddressvar}/>
<div class="container">
    {#if isVoter}
        <h4>Action voter</h4>
        {#if workflow === '1'}
            <AddProposal contractvar={contractvar} accountsvar={accountsvar}/>
        {:else if workflow === '3'}
            <UserVote contractvar={contractvar} accountsvar={accountsvar}/>
        {:else if workflow === '5'}
            <ViewVotes contractvar={contractvar}/>
        {/if}
    {/if}
    {#if isOwnervar}
        <h4>Action admin</h4>
        {#if workflow === '0'}
            <RegisterVoters contractvar={contractvar} accountsvar={accountsvar}/>
        {:else if workflow === '1'}
            <ShowProposal contractvar={contractvar} accountsvar={accountsvar}/>
        {:else if workflow === '2'}
            <StartVote contractvar={contractvar} accountsvar={accountsvar}/>
        {:else if workflow === '3'}
            <FinishVote contractvar={contractvar} accountsvar={accountsvar}/>
        {:else if workflow === '4'}
            <TallyVote contractvar={contractvar} accountsvar={accountsvar}/>
        {/if}
    {/if}
</div>