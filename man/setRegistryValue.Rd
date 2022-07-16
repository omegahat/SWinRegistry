\name{setRegistryValue}
\alias{setRegistryValue}
\title{Set Registry Value}
\description{
 This allows the caller to set the value of a key in the registry.
}
\usage{
setRegistryValue(path, key, value, type = .RegistryTypes["none"], top = .BuiltinKeys[1])
}
\arguments{
  \item{path}{the path to the folder in the registry in which to set the key.
   This is combined with top to identify the particular path in the
   registry.}
  \item{key}{the key within the folder specified by
   \code{path} and \code{top}.
   If this is either \code{NULL} or \code{""}, the value is used
   as the default value for the specified key.}
  \item{value}{the S object to which to set the registry key. This is converted
   to an appropriate value in C according to \code{type} and/or the
   default conversion mechanism }
  \item{type}{type for the value that is to be put into the registry.
    This controls how the S value is converted to a value in the registry.}
  \item{top}{the top-level key in the registry for this path}
}
\value{
 \code{NULL}, always!
}
\references{
 \url{http://www.omegahat.net/SWinRegistry}
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}

\seealso{
 \code{\link{getRegistryValue}}

 \code{\link{.resolveToplevelRegistryKey}}
}

\examples{

setRegistryValue("HKEY_CURRENT_USER\\\\Volatile Environment\\\\duncan", value = "foobar", type = .RegistryTypes["sz"] )

 setRegistryValue("HKEY_CURRENT_USER\\\\Volatile Environment\\\\duncan", value = "foobar")

}
\keyword{utilities}

