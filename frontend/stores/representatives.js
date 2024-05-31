import { defineStore } from 'pinia'
import { useQuery } from '@vue/apollo-composable'
import gql from 'graphql-tag'
import { ref, computed, watch } from 'vue'


export const useRepresentativeStore = defineStore('representatives', () => {
    const _state = ref({"value": {"listRepresentatives": {"results": []}}})
    const names = computed(() => {
        return _state.value.value.listRepresentatives.results.map((entry) => {
            return entry.name
        })
    })
    const representativesData = computed(() => _state.value.value.listRepresentatives.results)
    function fetchRepresentatives() {
        const { result } = useQuery(gql`
            query ListRepresentatives {
                listRepresentatives {
                    results {
                        id
                        name
                    }
                }
            }
            `)
        watch(result, value => {
            console.log(value)
            this._state.value = value
        })
    }
    return { names, representativesData, _state, fetchRepresentatives }
  })