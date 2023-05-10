<script>
    import {writable} from "svelte/store";

    export let contractvar
    export let accountsvar

    const addresses = writable([])
    let item

    const startProposal = () => {
        contractvar.methods.registerVoters($addresses).send({from: accountsvar[0]})
        contractvar.methods.startProposalsRegistration().send({from: accountsvar[0]}).then(() => {
            location.reload();
        })
    }

    const add = () => {
        const value = document.querySelector("#addedAddress").value
        if (value !== "" && !$addresses.includes(value)) {
            addresses.update(items => [...items, value])
        }
    }

    function deleteRow(deleteItem) {
        addresses.update(items => items.filter(i => i !== deleteItem))
    }
</script>

<div class="container">
    <div class="row my-4">
        <div class="col-8">
            <label for="addedAddress" class="form-label">Address to register</label>
            <input class="form-control" type="text" id="addedAddress"/>
        </div>
        <div class="col-4 d-grid my-auto">
            <button class="btn btn-primary btn-block buttonSave" id="buttonSave" on:click={add}>Add to list</button>
        </div>
    </div>
    <div class="row my-4 AddList">
        <table class="table" id="myTable">
            {#each $addresses as item}
                <tr>
                    <th style="width: 80%;" scope="row" id="{item}">{item}</th>
                    <td style="width: 20%;">
                        <button class="btn btn-outline-danger " on:click={() => {deleteRow(item)}}>
                            Delete
                        </button>
                    </td>
                </tr>
            {/each}
        </table>
    </div>
    <div class="row justify-content-center">
        <button class="btn btn-primary" on:click={startProposal}>Start proposal session
        </button>
    </div>
</div>