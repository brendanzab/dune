This tests shows how to use the `dune ocaml doc` command to open the
documentation index to a browser.
  $ export PATH=.:$PATH 
  $ dune ocaml doc | sed -e 's|.*file://\([^ ]*\).*|\1|'
  Docs built. Index can be found here: _build/default/_doc/_html/index.html
  open command received args:
  _build/default/_doc/_html/index.html