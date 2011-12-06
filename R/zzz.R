.First.lib <-
function(lib, pkg) {
 library(methods)
 library.dynam("SWinRegistry", pkg, lib)
}
