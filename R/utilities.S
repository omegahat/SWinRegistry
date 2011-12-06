expandEnvironmentStrings <-
function(x)
{
 tmp <- as.character(x)
 tmp <- .Call("R_ExpandEnvironmentStrings", tmp, PACKAGE="SWinRegistry")
 names(tmp) <- names(x)
 
 tmp
}


.resolveToplevelRegistryKey <-
function(top, path)
{
 if(is.numeric(top)) {
  top <- .BuiltinKeys[top]
 } else {
   idx <- pmatch(top, .BuiltinKeys)
   if(!is.na(idx)) 
    top <- .BuiltinKeys[idx]
   else
    top <- NULL
 }

 if(length(path)) {
   tmp = path
   path <- unlist(lapply(path, function(x) strsplit(x, "\\\\")[[1]]))
   if(tmp[length(tmp)] == "" || substring(tmp[length(tmp)], nchar(tmp[length(tmp)])) == "\\")
     path <- c(path, "")
 }

 if(length(path)) {
    idx <- pmatch(path[1], .BuiltinKeys)
    if(!is.na(idx)) {
       top <- path[1]
       path <- path[-1]
    } 

    path <- paste(path, collapse = "\\")
 }

# Want to throw an error at the end if top has not been found.
  if(is.null(top)) 
    stop("Invalid top-level key")

 list(top = top, path = path)
}
	