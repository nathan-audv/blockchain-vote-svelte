<script>
    let contractvar
    let accountsvar

    const tallyVote = () => {
        contractvar.value.methods.tallyVotes().send({from: accountsvar.value[0]})
    }
</script>

<div class="container py-2">
    <div class="row justify-content-center">
        <button class="btn btn-primary" on:click="tallyVote()">Tally votes</button>
    </div>
</div>