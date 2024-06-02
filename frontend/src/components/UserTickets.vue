<template>
    {{ result }}
</template>

<script setup>
import { wsClient } from '../apollo'
import gql from 'graphql-tag'
// import { gql, useSubscription } from "@apollo/client";
import { useSubscription } from "@vue/apollo-composable"
import { provideApolloClient } from "@vue/apollo-composable";
import { watch } from 'vue';
const userTickets = gql`
    subscription AssingRepresentative {
        assingRepresentative(representativeId: "ff40e08c-ad1c-4911-b082-29f463de6ae9") {
            id
            subject
            status
        }
    }
`
console.log(wsClient)
const { result, loading, error } = provideApolloClient(wsClient)(() => useSubscription(userTickets))
console.log(result)
console.log(loading)
console.log(error)
watch(result, value => {
    console.log(value)
})
</script>