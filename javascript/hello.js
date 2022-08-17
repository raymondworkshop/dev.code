"use strict";
// basics

let message = "Hello World";
console.log(message)

// function
export function User(name)  {
    this.name = name;
    this.isAdmin = false;
};


// constructor function
let user = new User("Raymond")
console.log(user.name)

// class 
class User1 {
    // create a function named User1
    constructor(name) {this.name = name;}  
    // store class methods in User1.prototype
    sayHi() {console.log(this.name);}
}
let user1 = new User1("Raymond1");
user1.sayHi();

function ask(question, yes, no) {
    if (question) yes()
    else no();
}

ask(
    "Do you agree?",
    function () { console.log("You agree."); },
    function () { console.log("YOu canceled the execution."); }
)