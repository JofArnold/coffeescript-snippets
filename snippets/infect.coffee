###

WHAT IS THIS?

A simple experiment to show how an existing class can be "modified" so that arbitrary code can be ran when it is instantiated. Useful if, for example, you wanted to know when a new instance of a class was created. Probably worth mentioning it's not actually modifying the original class of course - rather, it's creating a new one that functions like the original... but "infected" is a cool word :)

###

# Class to "infect" with the extra code
class Person
  constructor : (@first,@last) ->
    console.log "Hello, I'm a Person and my constructor is still working!"
    return true
  getName : ->
    return @first


# The code that's going to be be run when an instance of the class is created
infectWith = ->
  console.log "Hello, " + @getName() + ", I'm in you! You are now my bitch!"

# modify the class to add the new code
Person = ( (Person) ->
  # The VM looks to find the deepest prototype and executes that first. Here we make one to stick at the bottom of the chain
  First = ->
  First.prototype = Person.prototype
  firstInstance = new First()

  # This is going to be the topmost constructor and is executed after the first.
  Second = ->
    Person.apply(@,arguments)
    infectWith.call(@)
  Second.prototype = firstInstance
  Second.prototype.constructor = Second

  return Second
)(Person)

person = new Person("Jof")
# > Hello, I'm a Person and my constructor is still working!
# > Hello, Jof, I'm in you! You are now my bitch!


###

HOW DOES IT WORK?

It'll be clear once you create an instance of a Person class and then create an infected version using the code above. If you explore the objects in console you'll see how the modifier function chains the constructors. I've named them First and Second to highlight which is at the bottom of the prototype chain and, hence, which is executed first.
To save you typing, I've outlined the object tree below as it appears in Chrome's dev tools. Note: to help making the indention levels clearer, I've changed "__proto__" to "proto__".

---- Original Version -----
Person (Person)
  first
  last
  proto__ (Person)
    constructor ( function Person(first, last) { this.first = first; this.last = last; console.log("This part....!"); return true; })
    getName
    proto__ (Object)

----- Infected Version -----
Person (Second)
  first
  last
  proto__ (First)
    constructor ( function () { Person.apply(this, arguments); return infectWith.call(this); } )
      prototype (tmpClass)
      proto__
        {empty}
    proto__ (Person)
      constructor ( function Person(first, last) { this.first = first; this.last = last; console.log("This part... !"); return true; }
      getName
      proto__ (Object)

Cool, huh? Hopefully that will be of use to someone else one day!

###

