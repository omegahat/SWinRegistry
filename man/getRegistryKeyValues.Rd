\name{getRegistryKeyValues}
\alias{getRegistryKeyValues}
\title{Contents of Registry Folder}
\description{
 This retrieves all the key-value pairs in the specified
 registry folder.
}
\usage{
getRegistryKeyValues(path = "", top = .BuiltinKeys[1])
}

\arguments{
  \item{path}{}
  \item{top}{}
}

\value{
A named list containing the key-value pairs of the elements in that
node of the registry.  The names of the list are the keys.  The
elements in the list are the corresponding values in the registry
converted to their S equivalents.  The rule for mapping these types to
S is:


}
\references{
 \url{http://www.omegahat.org/SWinRegistry}
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}


\seealso{
 \code{\link{getRegistrySubKeyNames}}

 \code{\link{.resolveToplevelRegistryKey}}
}

\examples{
 getRegistryKeyValues("HKEY_CURRENT_USER\\\\Environment")
 getRegistryKeyValues(c("HKEY_CURRENT_USER", "Environment"))
 getRegistryKeyValues("Environment", top = "HKEY_CURRENT_USER")
 getRegistryKeyValues("Environment", top = "HKEY_CURRENT_USER")


 names(getRegistryKeyValues("HKEY_CURRENT_USER\\\\Control Panel\\\\Colors"))
 names(getRegistryKeyValues(c("HKEY_CURRENT_USER", "Control Panel", "Colors")))
 names(getRegistryKeyValues(c("Control Panel", "Colors"), top = "HKEY_CURRENT_USER"))
 names(getRegistryKeyValues("Control Panel\\\\Colors", top = "HKEY_CURRENT_USER"))
}
\keyword{utilities}

