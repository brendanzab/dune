A test case for #5064: errors when changing module dependencies in the
file-watching mode.

  $ . ./helpers.sh

  $ echo '(lang dune 3.0)' > dune-project
  $ mkdir lib
  $ cat > lib/dune <<EOF
  > (library (name lib))
  > EOF
  $ cat > dune <<EOF
  > (executable (name x) (libraries lib))
  > EOF
  $ echo 'let hello = "Hello"' > lib/a.ml
  $ echo 'let world = "World"' > lib/b.ml
  $ echo 'let message = A.hello ^ ", " ^ B.world' > lib/lib.ml

  $ echo 'print_endline Lib.message' > x.ml

  $ start_dune

  $ build x.exe
  Success
  $ _build/default/x.exe
  Hello, World

Now let's make [lib/a.ml] depend on [lib/b.ml]. It doesn't work!

  $ cat > lib/a.ml <<EOF
  > let _ = B.world
  > let hello = "Hello"
  > EOF

  $ build x.exe
  Failure

Let's try a manual restart.

  $ stop_dune
  waiting for inotify sync
  waited for inotify sync
  Success, waiting for filesystem changes...
  waiting for inotify sync
  waited for inotify sync
  File "_none_", line 1:
  Error: No implementations provided for the following modules:
           Lib__B referenced from lib/lib.cmxa(Lib__A)
  Had errors, waiting for filesystem changes...

  $ start_dune

It works now!

  $ build x.exe
  Success

We're done.

  $ stop_dune
  waiting for inotify sync
  waited for inotify sync
  Success, waiting for filesystem changes...
