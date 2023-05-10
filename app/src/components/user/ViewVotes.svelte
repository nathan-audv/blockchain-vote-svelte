<script>
    import {writable} from "svelte/store";

    export let contractvar

    const proposals = writable([])
    let item

    contractvar.methods.getProposalsLength().call((err, res) => {
        for (let i = 0; i < res; i++) {
            contractvar.methods.getOneProposal(i).call((err1, res1) => {
                proposals.update(items => [...items, res1])
            })
        }
    })
</script>

<div class="container py-2">
    <div class="row">
        <table class="table" id="myTable">
            {#each $proposals as item}
                <tr>
                    <th style="width: 80%;" scope="row">{item.description }</th>
                    <td style="width: 20%;"><span>{item.voteCount}</span></td>
                </tr>
            {/each}
        </table>
    </div>
</div>