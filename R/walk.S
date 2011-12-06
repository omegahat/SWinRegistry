getRegistry <-
function(path = character(0), top = .BuiltinKeys[1]) 
{
 top <- .resolveToplevelRegistryKey(top, path)
 values = getRegistryKeyValues(top$path, top = top$top)

	 
 sub = getRegistrySubKeyNames(top$path, top = top$top)
 folders <- list()
 for(i in sub) {
    folders[[i]] <- getRegistry(c(top$path, i), top$top)
 }
 
 new("RegistryKeyContents", values = values, folders = folders)
}
