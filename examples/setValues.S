 # as.integer(1))
for(i in 1:length(keys)) {
# setRegistryValue(keys[[i]], "Version", as.integer(1))
# setRegistryValue(keys[[i]], "VersionNumber", 1)
 setRegistryValue(keys[[i]], "Level", as.character(i))
 setRegistryValue(keys[[i]], "Name", "Dummy")
}


	