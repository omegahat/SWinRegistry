\name{getRegistrySubKeyNames}
\alias{getRegistrySubKeyNames}
\title{Names of sub-keys in Windows Registry Folder}
\description{
This gets the names of the sub-keys, i.e. the folders
within a registry key. It does not return
the names of the value entries within the key.
}
\usage{
getRegistrySubKeyNames(path = "", top = .BuiltinKeys[1])
}
\arguments{
  \item{path}{identifier for the key of interest}
  \item{top}{the top-level key in the registry  in which to resolve the path.
   This effectively identifies the branch in the registry tree.}
}
\value{
 A character vector giving the names of the subkeys
 within this key that are themselves keys,  and not 
 simply values.
}
\references{
 \url{http://www.omegahat.org/SWinRegistry}
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}


\seealso{
 \code{\link{getRegistryKeyValues}}

 \code{\link{.resolveToplevelRegistryKey}}
}

\examples{
  # Names of all the applications registered in HKEY_LOCAL_MACHINE\SOFTWARE.
 getRegistrySubKeyNames("SOFTWARE", top = "HKEY_LOCAL_MACHINE")

  # Find all class UUIDs for the COM definitions in HKEY_CLASSES_ROOT\CLSID
 getRegistrySubKeyNames("CLSID")
}
\keyword{utilities}
