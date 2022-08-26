//https://eloquentjavascript.net/07_robot.html
//
const roads = [
    "Alice's House-Bob's House",   "Alice's House-Cabin",
    "Alice's House-Post Office",   "Bob's House-Town Hall",
    "Daria's House-Ernie's House", "Daria's House-Town Hall",
    "Ernie's House-Grete's House", "Grete's House-Farm",
    "Grete's House-Shop",          "Marketplace-Farm",
    "Marketplace-Post Office",     "Marketplace-Shop",
    "Marketplace-Town Hall",       "Shop-Town Hall"
];

// build a road graph  
function buildGraph(edges){
    let graph = Object.create(null); //use Object.create to create an object with a specific prototype

    function addEdge(from, to){
        if (graph[from] == null) {
            graph[from] = [to];
        } else {
            graph[from].push(to);
        }
    }
    for (let [from, to] of edges.map(r => r.split("-"))){
        addEdge(from, to);
        addEdge(to, from);
    }

    return graph;
}

//roadGraph object stores an array of connected nodes  
const roadGraph = buildGraph(roads);
console.log(roadGraph)

// note: condense the village's state down to the min set of values that define it
//   - the robot's current location 
//   - the collection of undelivered parcels  
//        + each has a current location and a destination address  
//
class VillageState {
    constructor(place, parcels){
        this.place = place;
        this.parcels = parcels;
    }

    // we don't change this state when the robot moves
    // but rather compute a new state for the situation after the move 
    //
    // the move methos is where the action happens
    move(destination){
        // if not a road going from the current place to the destination
        // returns the old state since this is not a valid move
        if (!roadGraph[this.place].includes(destination)){
            return this; 
        } else {
            //carete a new state with the destination as the robot's new place
            let parcels = this.parcels.map(p => {
                if (p.place != this.place) return p;
                return {place: destination, address: p.address};
            }).filter(p => p.place != p.address);
            
            return new VillageState(destination, parcels);
        }
    }
}

let first = new VillageState("Post Office", [{place: "Post Office", address: "Alice's House"}]);
// the init state describe the situation where the robot is and the parcel is undelivered
console.log(first.place);
console.log(first.parcels);
let next = first.move("Alice's House");
// the move causes the parcel to be delivered, and this is reflected in the next state  
console.log(next.place);
console.log(next.parcels);

//TODO - Simulation  