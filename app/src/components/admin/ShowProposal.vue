<script setup lang="ts">
import "bootstrap/dist/css/bootstrap.css";
import "bootstrap/dist/js/bootstrap.js";

const finishProposal = () => {

}

const emit = defineEmits<{
    (e:'endProposal'):void
}>()
</script>

<template>
    <div class="container">
        <div class="row my-5">
            <ul class="list-group">
                <li class="list-group-item">test1</li>
                <li class="list-group-item">test2</li>
            </ul>
        </div>
        <div class="row justify-content-center">
            <button class="btn btn-primary" v-on:click="finishProposal">Finish proposals</button>
        </div>
    </div>
</template>

<style scoped>

</style>