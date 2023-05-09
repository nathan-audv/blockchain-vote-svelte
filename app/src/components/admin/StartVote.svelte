<script>
    let contractvar
    let accountsvar

    const startVote = () => {
        contractvar.methods.startVotingSession().send({from: accountsvar[0]})
    }
</script>

<div class="container py-2">
    <div class="row justify-content-center">
        <button class="btn btn-primary" on:click={startVote}>Start vote</button>
    </div>
</div>