<script>
    let contractvar
    let accountsvar

    const endVoting = () => {
        contractvar.methods.endVotingSession().send({from: accountsvar[0]})
    }
</script>

<div class="container py-2">
    <div class="row justify-content-center">
        <button class="btn btn-primary" on:click={endVoting}>End voting</button>
    </div>
</div>
