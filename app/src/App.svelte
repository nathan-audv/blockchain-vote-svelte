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

    let workflow
    let isOwnervar

    contractvar.methods.getWorkflowStatus.call((err1, res1) => {
        workflow = res1
    })

    console.log(workflow)
</script>

<Navbar/>
{#if !isOwnervar}
    {#if workflow === ''}
        <AddProposal/>
    {:else if workflow === ''}
        <UserVote/>
    {:else if workflow === ''}
        <ViewVotes/>
    {/if}
{:else}
    {#if workflow === ''}
        <RegisterVoters/>
    {:else if workflow === ''}
        <ShowProposal/>
    {:else if workflow === ''}
        <StartVote/>
    {:else if workflow === ''}
        <FinishVote/>
    {:else if workflow === ''}
        <TallyVote/>
    {/if}
{/if}