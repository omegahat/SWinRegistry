setClass("RegistryKeyPath",
	  representation(top ="character",
	                 path="character"))

setClass("RegistryValuePath",
	  representation("RegistryKeyPath"))



setClass("RegistryKeyContents",
          representation(values="list",
                         folders = "list"))
	
setGeneric("createRegistryKey",
           function(path, key = character(0), top = .BuiltinKeys[1], recursive = FALSE, check = TRUE)  
             standardGeneric("createRegistryKey"))

setGeneric("setRegistryValue",
            function(path, key, value, type = .RegistryTypes["none"], top = .BuiltinKeys[1])
              standardGeneric("setRegistryValue"))

setGeneric("getRegistryKeyValues", 
             function(path = "", top = .BuiltinKeys[1])
                standardGeneric("getRegistryKeyValues"))

setGeneric("resolveKey", 
             function(path = "", top = .BuiltinKeys[1])
                standardGeneric("resolveKey"))

setGeneric("getRegistrySubKeyNames", 
             function(path = "", top = .BuiltinKeys[1])
                standardGeneric("getRegistrySubKeyNames"))


setGeneric("deleteRegistryKey",
            function(path, key = character(0), top = .BuiltinKeys[1], asKey = FALSE, recursive = FALSE, resolve = TRUE) 
              standardGeneric("deleteRegistryKey")
            )

setGeneric("getRegistryValue",      
             function(path, key = character(0), isError = TRUE, top = .BuiltinKeys[1])
               standardGeneric("getRegistryValue"))