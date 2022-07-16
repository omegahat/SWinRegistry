\name{RegistryKeyPath-class}
\docType{class}
\alias{RegistryKeyPath-class}
\alias{RegistryValuePath-class}
\title{Representation of an entry in the registry}
\description{
 This is used to represent the full path to an entry
 in the Windows registry. 
 It consists of the top-level key in which the entry 
  is resolved, and then a vector giving the names
  of the sub-keys that identify the path in the
  hierarchy to the specified key.
  This forms the basis of most of the 
  functins in this \code{SWinRegistry} package.
}
\section{Objects from the Class}{
The constructor function is \code{\link{createRegistryPath}}.
}
\section{Slots}{
  \describe{
    \item{\code{top}:}{Object of class \code{"character"}
       the name of the top-level key in the registry in which
       the path is to be resolved. This comes from 
       \code{.BuiltinKeys}.}
    \item{\code{path}:}{Object of class \code{"character"}
     giving the names of the subkeys that lead to the
     specified entry and the entry's name itself.}
  }
}

\section{Methods}{
  \describe{
    \item{coerce}{\code{signature(from = "RegistryKeyPath", to = "character")}: ... }
    \item{createRegistryKey}{\code{signature(path = "RegistryKeyPath", key = "missing")}: ... }
    \item{createRegistryKey}{\code{signature(path = "RegistryKeyPath", key = "character")}: ... }
    \item{deleteRegistryKey}{\code{signature(path = "RegistryKeyPath", key = "character")}: ... }
    \item{deleteRegistryKey}{\code{signature(path = "RegistryKeyPath", key = "missing")}: ... }
    \item{getRegistryKeyValues}{\code{signature(path = "RegistryKeyPath", top = "missing")}: ... }
    \item{getRegistrySubKeyNames}{\code{signature(path = "RegistryKeyPath")}: ... }
    \item{resolveKey}{\code{signature(path = "RegistryKeyPath")}: ... }
    \item{setRegistryValue}{\code{signature(path = "RegistryKeyPath", key = "character")}: ... }
  }
}

\references{
 \url{http://www.omegahat.org/SWinRegistry}
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}

%\examples{}
\keyword{classes}
