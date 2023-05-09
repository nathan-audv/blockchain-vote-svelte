<script setup lang="ts">

const makeProposal = () => {
    const value = document.querySelector("#addedProposal").value
    props.contract.methods.registerProposal(value).send({from: props.account[0]}).then((result)=>console.log(result))

}

const props = defineProps<{
    contract:any,
    account:any
}>()
</script>

<template>
    <div class="container">
        <div class="row my-4">
            <div class="col-8">
                <label for="addedProposal" class="form-label">Make a proposal</label>
                <input class="form-control" type="text" id="addedProposal"/>
            </div>
            <div class="col-4 d-grid my-auto">
                <button class="btn btn-primary btn-block" id="buttonAdd" v-on:click="makeProposal">Submit proposal
                </button>
            </div>
        </div>
    </div>
</template>

<style scoped>

</style>