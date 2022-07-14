.WinRegistryError =
function(type, wmsg, umsg)
{
   eclass = switch(as.character(type),
           "5" = "AccessDenied",
	   "12" = "InvalidAccess",
	   "13" = "InvalidDate",
	   "2" = "FileNotFound",
	   "3" = "PathNotFound",
    	   character())

    msg = paste(umsg, wmsg)
    e = structure(list(message = msg, call = NULL),
                  class = c(eclass, "WinRegistryError", "simpleError", "error", "condition"))

    stop(e)
}
