<script>
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

    let contractvar
    let accountsvar
    let workflow
    let isOwnervar
    let isVoter

    contractvar.methods.getWorkflowStatus.call((err1, res1) => {
        workflow = res1
    })

    console.log(workflow)
</script>

<Navbar/>
{#if isVoter}
    {#if workflow === ''}
        <AddProposal contractvar={contractvar} accountsvar={accountsvar}/>
    {:else if workflow === ''}
        <UserVote contractvar={contractvar} accountsvar={accountsvar}/>
    {:else if workflow === ''}
        <ViewVotes contractvar={contractvar}/>
    {/if}
{/if}
{#if isOwnervar}
    {#if workflow === ''}
        <RegisterVoters contractvar={contractvar} accountsvar={accountsvar}/>
    {:else if workflow === ''}
        <ShowProposal contractvar={contractvar} accountsvar={accountsvar}/>
    {:else if workflow === ''}
        <StartVote contractvar={contractvar} accountsvar={accountsvar}/>
    {:else if workflow === ''}
        <FinishVote contractvar={contractvar} accountsvar={accountsvar}/>
    {:else if workflow === ''}
        <TallyVote contractvar={contractvar} accountsvar={accountsvar}/>
    {/if}
{/if}