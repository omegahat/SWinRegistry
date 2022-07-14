library(SWinRegistry)

registryKeyExists("HKEY_CURRENT_USER")

getRegistrySubKeyNames("HKEY_CURRENT_USER")


registryKeyExists(c("HKEY_CURRENT_USER", "EUDC"))


k1 = getRegistrySubKeyNames(c("HKEY_CURRENT_USER", "EUDC"))
k2 = getRegistrySubKeyNames(c("HKEY_CURRENT_USER\\EUDC"))

getRegistrySubKeyNames(c("HKEY_CLASSES_ROOT"))


# Gives error - access denied
k = tryCatch(getRegistrySubKeyNames(c("HKEY_CLASSES_ROOT", "Excel.Application")),
               AccessDenied = function(e) e)