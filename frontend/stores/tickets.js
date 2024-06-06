import { defineStore } from 'pinia'
import { useQuery, useMutation } from '@vue/apollo-composable'
import gql from 'graphql-tag'
import { ref, computed, watch, reactive } from 'vue'
import { apolloClientTickets } from '../src/apollo'
import { provideApolloClient } from "@vue/apollo-composable";


export const useTicketStore = defineStore('tickets', () => {
    const ticketsClosed = ref({})
    const tickets = ref([])
    function closeUserTicket(ticketId) {
        console.log(ticketId)
        const query = provideApolloClient(apolloClientTickets)(() => useMutation(gql`
            mutation CloseTicket{
                closeTicket(id: "${ticketId}") {
                    result {
                        id
                        status
                        subject
                        representative {
                            id
                            name
                        }
                    }
                }
            }
        `))
        query.mutate((r) =>  console.log(r))
        query.onDone((r) => {
            console.log(r)
            const result = r.data.closeTicket?.result ?? null
            if (result){
                ticketsClosed.value = result
            }
        })
    }
    function fetchTickets() {
        const query = provideApolloClient(apolloClientTickets)(() => useMutation(gql`
            query ListTickets {
                listAllTickets(limit: 250) {
                    results {
                        id
                        subject
                        status
                        representative {
                            id
                            name
                        }
                    }
                }
            }
        `))
        query.mutate()
        query.onDone((value) => {
            tickets.value = value.data.listAllTickets?.results ?? []
        })
    }
    function deleteTicket(ticketId) {
        console.log(ticketId)
        const query = provideApolloClient(apolloClientTickets)(() => useMutation(gql`
            mutation DeleteTicket {
                deleteTicket(id: "${ticketId}") {
                    result {
                        id
                    }
                }
            }
        `))
        query.mutate((r) =>  console.log(r))
        query.onDone((r) => {
            console.log(r)
            const result = r.data.deleteTicket?.result ?? null
        })
    }
    function assignTicket(ticketId, userId) {
        console.log(ticketId)
        const query = provideApolloClient(apolloClientTickets)(() => useMutation(gql`
            mutation AssingRepresentative {
                assingRepresentative(id: "${ticketId}", input: { representativeId: "${userId}" }) {
                    result {
                        id
                    }
                }
            }
        `))
        query.mutate((r) =>  console.log(r))
        query.onDone((r) => {
            console.log(r)
        })
    }
    function setTickets(ticketsCollection){
        console.log("set ticket")
        console.log(ticketsCollection)
        tickets.value = ticketsCollection.value
    }

    return { tickets, ticketsClosed, setTickets, closeUserTicket, deleteTicket, assignTicket, fetchTickets }
  })