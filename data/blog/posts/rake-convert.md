rake-convert - a Rakefile -> Makefile/configure generator
=========================================================

Being the GNU hater I am if I can avoid autohell I'm more than happy, the problem is that having
Ruby as dependency for building something (Rake) isn't really good.

Well, now things may be a bit easier, with this rake plugin a Rakefile can be converted into a
normal Makefile and configure script.

There obviously are some limitations, but generally it works.

The trick is that it overloads the sh rake function making it add the shell command to a Makefile
instead of executing it. It then executes the tasks to write down Makefile rules in the right way.

The configure generation instead overloads mkmf functions and translates them into simple shell script.

Still have to see if the other guys will agree to convert the craftd to this building system, hope
they'll see the light :)
