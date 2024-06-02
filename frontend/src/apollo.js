import { ApolloClient, createHttpLink, InMemoryCache, split, HttpLink } from '@apollo/client/core'


// HTTP connection to the API

const httpLink = createHttpLink({
  // You should use an absolute URL here
  uri: '/gql',
})



// Cache implementation
const cache = new InMemoryCache()

// Create the apollo client
const apolloClient = new ApolloClient({
  link: httpLink,
  cache,
})

const apolloClientTickets = new ApolloClient({
  link: httpLink,
  cache,
})

import { Socket as PhoenixSocket } from "phoenix";
import * as AbsintheSocket from "@absinthe/socket";
import { createAbsintheSocketLink } from "@absinthe/socket-apollo-link";
// import { ApolloClient, HttpLink, InMemoryCache, split } from "@apollo/client";
import { hasSubscription } from "@jumpn/utils-graphql";
import { getMainDefinition } from "@apollo/client/utilities"

// Create the websocket link
const phoenixSocket = new PhoenixSocket("/socket", {
  params: () => {
    const token = "xxx"; // an auth token (e.g. from cookies or another authentication process)
    return { token };
  },
});
const absintheSocket = AbsintheSocket.create(phoenixSocket);
const websocketLink = createAbsintheSocketLink(absintheSocket);
 
// Create http link
const http = new HttpLink({ uri: "/gql" });
 
// Create a split link
const link = split(
  (operation) => {
    const definition = getMainDefinition(query);

    return (
      definition.kind === "OperationDefinition" &&
      definition.operation === "subscription"
    );
  },
  websocketLink,
  http
);
 
// Create the client
const wsClient = new ApolloClient({
  link,
  cache: new InMemoryCache(),
});

export { apolloClient , apolloClientTickets, wsClient }