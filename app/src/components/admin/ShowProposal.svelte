<script>
    export let contractvar
    export let accountsvar

    const proposals = []
    let item

    contractvar.methods.getProposalsLength().call((err, res) => {
        for (let i = 0; i < res; i++) {
            contractvar.methods.getOneProposal(i).call((err1, res1) => {
                proposals.value.push(res1)
            })
        }
    })

    const endProposal = () => {
        contractvar.methods.endProposalsRegistration().send({from: accountsvar[0]})
    }
</script>

<div class="container py-2">
    <div class="row my-4">
        <table class="table" id="myTable">
            {#each item as proposals}
                <tr>
                    <th style="width: 80%;" scope="row">{ item.description }</th>
                </tr>
            {/each}
        </table>
    </div>
    <div class="row justify-content-center">
        <button class="btn btn-primary" on:click={endProposal}>Finish proposals</button>
    </div>
</div>