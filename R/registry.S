#
# Create and delete key (rather than delete value) are having problems!
#


# Some of these are NT, 2000 and XP only.
# PERFORMACE_*TEXT is XP-specific.

.BuiltinKeys <-
	paste("HKEY_", c("CLASSES_ROOT", "CURRENT_CONFIG", "CURRENT_USER", "LOCAL_MACHINE", 
	                  "DYN_DATA", "PERFORMANCE_DATA", "PERFORMANCE_NLSTEXT", "PERFORMANCE_TEXT"), sep="")

setMethod("getRegistryValue", 
           "character",
function(path, key = character(0), isError = TRUE, top = .BuiltinKeys[1])
{
   getRegistryValue(createRegistryPath(c(path, key), isValue = TRUE, top = top), isError = isError)
    # Lose the fact that this is now a RegistryValuePath if we just append.
    # getRegistryValue(append(path, key), isError)
}
)

setMethod("getRegistryValue", 
           "RegistryKeyPath",
function(path, key = character(0), isError = TRUE, top = .BuiltinKeys[1])
{
 path@path = c(paste(path@path[-length(path@path)], collapse="\\"), path@path[length(path@path)])

 .Call("R_getRegistryKey", path@top, path@path, as.logical(isError), PACKAGE="SWinRegistry")
})

setMethod("createRegistryKey",
            signature("character"),  #, "character"),
#
# The recursive argument is like -p in the GNU mkdir.
#
function(path, key = character(0), top = .BuiltinKeys[1], recursive = FALSE, check = TRUE)
{
 tmp = createRegistryPath(c(path, key), top, isValue = FALSE)
 createRegistryKey(tmp, recursive = recursive, check = check)
}
)

setMethod("createRegistryKey", 
           signature("RegistryKeyPath", "missing"),
	   function(path, key = character(0), top = .BuiltinKeys[1], recursive = FALSE, check = TRUE)
	   {
             if(check && !is.null(tmp <- resolveKey(path))) {
               if(is(tmp, "RegistryValuePath"))
                stop("Key is a value not a regular key")

               return(tmp)
             }

             orig = path
	     path@path = c(paste(path@path[-length(path@path)], collapse="\\"), path@path[length(path@path)])
	     ok <- .Call("R_createRegistryKey", path@top, path@path, PACKAGE="SWinRegistry")
	      
	     if(ok) 
	       return(orig)

             stop("Can't create registry key")
          })

setMethod("createRegistryKey", 
           signature("RegistryKeyPath", "character"),
	   function(path, key = character(0), top = .BuiltinKeys[1], recursive = FALSE, check = TRUE)
	   {
             createRegistryKey(append(path, key), recursive = recursive, check = check)
           })

registryKeyExists <-
function(path = "", top = .BuiltinKeys[1])
{
  !is.null(resolveKey(path, top))
}


setMethod("resolveKey",
            "RegistryKeyPath",
            function(path, top = .BuiltinKeys[1]) {

             els = c(paste(path@path[-length(path@path)], collapse="\\"), path@path[length(path@path)])
             .Call("R_registryKeyResolve", path@top, 
                                          paste(path@path, collapse="\\"),
					  els,
					  PACKAGE="SWinRegistry")
            }
          )
setMethod("resolveKey", "character",
            function(path = "", top = .BuiltinKeys[1])
	     resolveKey(createRegistryPath(path, top))
          )

setMethod("getRegistrySubKeyNames", "character",
            function(path = "", top = .BuiltinKeys[1])
	     getRegistrySubKeyNames(createRegistryPath(path, top))
          )

setMethod("getRegistrySubKeyNames", "RegistryKeyPath",
            function(path = "", top = .BuiltinKeys[1])
              names(.Call("R_getRegistryKeys", path@top, paste(path@path, collapse="\\"), as.logical(TRUE), PACKAGE="SWinRegistry"))
          )


setMethod("getRegistryKeyValues",
           c("RegistryKeyPath", "missing"),
           function(path = "", top = .BuiltinKeys[1]) {
               .Call("R_getRegistryKeys", path@top, 
                                          paste(path@path, collapse="\\"),
                                          as.logical(FALSE), PACKAGE="SWinRegistry")              
           })

setMethod("getRegistryKeyValues",
           c("character"),
           function(path = "", top = .BuiltinKeys[1]) {
             getRegistryKeyValues(createRegistryPath(path, top, isValue = FALSE))
           })

.RegistryTypes <-
 c("none" = 0, 
   "sz" = 1,
   "expand_sz" = 2,
   "binary" = 3,
   "dword" = 4,
   "dword_little_endian" = 4,
   "dword_big_endian" = 5,
   "link" = 6,
   "mutli_sz" = 7,
   "resource_list" = 8,
   "resource_descriptor" = 9,
   "resource_requirements_list" = 10)

storage.mode(.RegistryTypes) <- "integer"


# should key default to "" or NULL so that
# we can set the default value of a key.
setMethod("setRegistryValue",
           c("character", "character"),
           function(path, key, value, type = .RegistryTypes["none"], top = .BuiltinKeys[1]) {
              setRegistryValue(createRegistryPath(c(path, key), top, isValue = TRUE), value = value, type = type)
           })

setMethod("setRegistryValue",
           c("character", "missing"),
           function(path, key, value, type = .RegistryTypes["none"], top = .BuiltinKeys[1]) {
              setRegistryValue(createRegistryPath(path, top, isValue = TRUE), value = value, type = type)
           })

setMethod("setRegistryValue",
           c("RegistryKeyPath", "character"),
           function(path, key, value, type = .RegistryTypes["none"], top = .BuiltinKeys[1]) {
              setRegistryValue(createRegistryPath(c(path@path, key), path@top, isValue = TRUE), value = value, type = type)})


setMethod("setRegistryValue",
           c("RegistryValuePath"),
            function(path, key, value, type = .RegistryTypes["none"], top = .BuiltinKeys[1]) {
             if(is.character(type)) {
	        idx <- pmatch(type, names(.RegistryTypes))
		if(is.na(idx))
		   stop("Can't interpret ", type, " as a registry type. See .RegistryTypes")
	       type <- .RegistryTypes[idx]
	     }

#XXX Needs more work, to say the least.
      if(is.na(value)) {
        stop("Don't know how to deal with NAs in registry. Explicitly coerce to a string(?)")
      } else if(is.null(value)) {
         type <- .RegistryTypes["none"]
      } else if(type == .RegistryTypes["none"]) {
         tp <- typeof(value)
	 len <- length(value)

        if(tp == "character") {
           if(len > 1)
            type <- .RegistryTypes["multi_sz"]
           else
            type <- .RegistryTypes["sz"]
        } else if(tp == "integer") {
          type <- .RegistryTypes["dword"]
        } else if(tp == "double") {
          type <- .RegistryTypes["dword"]
        }
      }


     if(type %in% c(1, 2, 7)) {
        value = as.character(value)
     } else if(type == 4) {
        value = as.integer(value)
     } 
             
     .Call("R_setRegistryKey", path@top, 
                                paste(as.character(path@path[-length(path@path)]),  collapse="\\"),
                                as.character(path@path[length(path@path)]),
                                value, as.integer(type), PACKAGE="SWinRegistry")

     path
})


flushRegistryKey <-
function(path, top = .BuiltinKeys[1])
{
 top <- .resolveToplevelRegistryKey(top, path)
 .Call("R_flushRegKey", top$top, top$path, PACKAGE="SWinRegistry")
}




setMethod("deleteRegistryKey",
           c("character"),
           function(path, key = character(0), top = .BuiltinKeys[1], asKey = FALSE,
                      recursive = FALSE, resolve = TRUE) 
           {
             deleteRegistryKey(createRegistryPath(c(path, key), top), 
                                asKey = asKey, recursive = recursive, resolve = resolve)
         })


setMethod("deleteRegistryKey",
           c("RegistryValuePath", "missing"),
           function(path, key = character(0), top = .BuiltinKeys[1], asKey = FALSE, 
                    recursive = FALSE, resolve = TRUE) 
           {
		ans = .Call("R_deleteRegKey", path@top, 
                               paste(path@path[-length(path@path)], collapse="\\"),
                               path@path[length(path@path)],
			       FALSE,
                               FALSE, PACKAGE="SWinRegistry")
         })


setMethod("deleteRegistryKey",
           c("RegistryKeyPath", "character"),
           function(path, key = character(0), top = .BuiltinKeys[1], asKey = FALSE, 
                       recursive = FALSE, resolve = TRUE) {

             deleteRegistryKey(createRegistryPath(c(path@path, key), top = path@top, isValue = !asKey), 
                               resolve = resolve, recursive = recursive, asKey = asKey)
           })

setMethod("deleteRegistryKey",
           c("RegistryKeyPath", "missing"),
           function(path, key = character(0), top = .BuiltinKeys[1], asKey = FALSE, 
                     recursive = FALSE, resolve = TRUE) {
             if(resolve) {
	       orig = path  
               path = resolveKey(path)
               if(is.null(path))
                 stop("No such key", as(orig, "character"))

                  # potentially need to redispatch, so call again.
               return(deleteRegistryKey(path, recursive = recursive, resolve = FALSE))
             }

             if(recursive) {
               keys = names(getRegistryKeyValues(path))
	       for(i in keys) {
                 deleteRegistryKey(path, i, asKey = FALSE, recursive = FALSE, resolve =FALSE)
	       }

               sub = getRegistrySubKeyNames(path)
	       for(i in sub) {
                  deleteRegistryKey(path, i, asKey = TRUE, recursive = TRUE)
               }
              }

              path = resolveKey(path)
	      asKey = (class(path) == "RegistryKeyPath") 

	      ans = .Call("R_deleteRegKey", path@top, 
                           paste(path@path[-length(path@path)], collapse="\\"),
                           path@path[length(path@path)],
		           as.logical(asKey),
                           as.logical(recursive), PACKAGE="SWinRegistry")
		ans
          })
