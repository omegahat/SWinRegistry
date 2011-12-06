
 registryKeyExists(c("SOFTWARE\\Duncan\\Temple\\Lang"), top = "HKEY_LOC")
# [1] TRUE
 registryKeyExists(c("SOFTWARE\\Duncan\\Temple\\sLang"), top = "HKEY_LOC")
# [1] FALSE
 registryKeyExists(c("SOFTWARE", "Duncan", "Temple", "Lang"), top = "HKEY_LOC")
# [1] TRUE
 registryKeyExists(c("SOFTWARE", "Duncan", "Temple", "Langs"), top = "HKEY_LOC")
# [1] FALSE
 registryKeyExists(c("SOFTWARE", "Duncan", "Temple\\Lang"), top = "HKEY_LOC")
# [1] TRUE
 
 registryKeyExists(c("SOFTWARE"), top = "HKEY_LOC")
 registryKeyExists(top = "HKEY_LOC")
 registryKeyExists()
