Happy programmers write happy code
Summarized thusly: 
Only program the happy case, what the specification says the task is supposed to do
 ~ Joe Armstrong
Did you know that Erlang programmers would make mighty fine actors (or at least actor managers)? Besides the fact that they deal with 
actors
 all day long (Erlang processes), they also take on the character of the process. When branching (using case, if, or function clauses), the executing process needs to determine 
Do I know how to handle an error here
?
A common idiom is to return {ok, Result} or {error, Error} when calling another module to do something for you. If you, the calling process, don't know what to do with {error, Error}, why branch? Just match {ok, Result} and continue programming the happy case. Let some one else (a supervisor or whomever spawned you) clean up the mess. That said, if you know how to handle the error, you should certainly branch and handle it appropriately.
It's not always this cut and dry, of course, but asking 
Do I know how to handle an error here
 is a good start to deciding whether to wrap that function call in a case statement or not. If this is a long-running server, failing intentionally probably isn't a wise course of action. However, if it's a worker process spawned by the server, it's likely okay to not handle the error. By keeping your workers' outlooks happy, you simplify and reduce the amount of code in those workers, and hopefully make it easier to reason about them when determining if they are meeting their specification.
