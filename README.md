# Tapestry

The goal of this project is to implement in Elixir using the actor model the Tapestry Algorithm and a simple object access service to prove its usefulness. The specification of the Tapestry protocol can be found in the paper-Tapestry: A Resilient Global-Scale Overlay for Service Deployment by Ben Y. Zhao, Ling Huang, Jeremy Stribling, Sean C. Rhea, Anthony D. Joseph and John D. Kubiatowicz. Link to paper- https://pdos.csail.mit.edu/~strib/docs/tapestry/tapestry_jsac03.pdf.

Input: The input provided (as command line to your program will be of theform:mix runproject3 .exs numNodes numRequestsWhere numNodes is the number of peers to be created in the peer to peer system andnumRequests the number of requests each peer has to make. When all peers performedthat many requests, the program can exit. Each peer should send a request/second.Output: Print the average number of hops (node connections) that must be traversedto deliver a message.
