\name{registryKeyExists}
\alias{registryKeyExists}
\title{Query for existence of key in registry}
\description{
 This function is used to query whether a particular
 key exists within the registry. It allows one to
 check before accessing the key and potentially
 generating an error. This is useful so that
 we don't have to use numerous \code{\link{try}}-\code{catch}
 blocks to handle errors, and it also avoids  displaying
 error messages.
}
\usage{
registryKeyExists(path = "", top = .BuiltinKeys[1])
}
%- maybe also `usage' for other objects documented here.
\arguments{
  \item{path}{the path within the registry, relative to the 
   top-level key identified by \code{top}, or 
  the entire path.}
  \item{top}{an identifier for one of the built-in  top-level keys
   in which to resolve the path components.}
}
\details{
 This merely tries to open the key
 and returns whether this was successful or not. 
}
\value{
A logical value indicating whether the key
exists and can be read.
}
\references{
 \url{http://www.omegahat.org/SWinRegistry}
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}

\seealso{
\code{\link{createRegistryKey}}
\code{\link{getRegistrySubKeyNames}}
\code{\link{getRegistry}}
\code{\link{getRegistryKeyValues}}
}

\examples{
  # See if R has been registered.
 registryKeyExists("HKEY_LOCAL_MACHINE\\\\Software\\\\R-core")

  # See if SNormal is registerd.
  registryKeyExists("SNormal")

  # Check the top-level key HKEY_CLASSES_ROOT exists
  registryKeyExists()

  # This fails on my machine as the Performance information
  # is not registered.
  try(registryKeyExists(top = .BuiltinKeys[8]))
}
\keyword{utilities}


