#setGeneric("createRegistryPath",
#  function(path, top = .BuiltinKeys[1], isValue = FALSE),
#    standardGeneric("createRegistryPath"))

#setMethod("createRegistryPath",
#           c("character", "character")
createRegistryPath  <-
function(path, top = .BuiltinKeys[1], isValue = FALSE)
{
  k = new(ifelse(isValue, "RegistryValuePath", "RegistryKeyPath"))
  tmp = .resolveToplevelRegistryKey(top, path)
  k@top = tmp$top
  if(length(tmp$path))
    k@path = unlist(lapply(tmp$path, function(x) strsplit(x, "\\\\")[[1]]))

#browser()
  if(substring(tmp$path, nchar(tmp$path)) == "\\")
    k@path = c(k@path, "")

  k   	 
}	
		 	

setAs("RegistryKeyPath", "character", function(from) { paste(c(from@top, from@path), collapse="\\")})

setMethod("append", c("RegistryKeyPath", "character"),
              function(x,values, after = length(x)) {
                x@path = c(x@path, values)
                x
              })