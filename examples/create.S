library(SWinRegistry)

keys = list()
keys[[1]] = createRegistryKey("SOFTWARE", "Duncan", "HKEY_LOCAL_MACHINE")
keys[[2]] = createRegistryKey(keys[[1]], "Temple")
keys[[3]] = createRegistryKey(keys[[2]], "Lang")
keys[[4]] = createRegistryKey(keys[[3]], "SWinRegistry")


#deleteRegistryKey(keys[[2]], recursive = TRUE)


