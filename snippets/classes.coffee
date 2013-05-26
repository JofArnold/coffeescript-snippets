# Snippet demonstrating how `apply` can be used to copy the variables from a class to its parent

class MyClass1
  constructor : ->
    @myClass1Thing = 1
    console.log "myClass1Vars",arguments,@myClass1Thing,@myClass2Thing

class MyClass2 extends MyClass1
  constructor: (name) ->
    @myClass2Thing = 2
    MyClass1.apply(@,[name])
    console.log "myClass2Vars",arguments,@myClass1Thing,@myClass2Thing

test = new MyClass2("dave")

# > myClass1Vars ["dave"] 1 2
# > myClass2Vars ["dave"] 1 2

