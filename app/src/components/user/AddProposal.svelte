<script>
    let contractvar
    let accountsvar

    const makeProposal = () => {
        const value = document.querySelector("#addedProposal").value
        if (value !== "") {
            contractvar.value.methods.registerProposal(value).send({from: accountsvar.value[0]})
        }
    }
</script>
<div class="container py-2">
    <div class="row my-4">
        <div class="col-8">
            <label for="addedProposal" class="form-label">Make a proposal</label>
            <input class="form-control" type="text" id="addedProposal"/>
        </div>
        <div class="col-4 d-grid my-auto">
            <button class="btn btn-primary btn-block" id="buttonAdd" on:click="makeProposal()">Submit proposal
            </button>
        </div>
    </div>
</div>