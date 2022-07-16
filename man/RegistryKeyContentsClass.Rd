\name{RegistryKeyContents-class}
\docType{class}
\alias{RegistryKeyContents-class}
\title{Simple class for representing the contents of registry key}
\description{
 This is used to give type information to a container for a
 an object that holds both the values in a registry key
 and also the sub-folders it houses.
 We make this a class rather than a simple list so that we
 can define methods on it such as restoring the 
 structure in the registry, etc.
}
\section{Objects from the Class}{
Objects can be created by calls of the form 
\code{\link{getRegistry}}
}
\section{Slots}{
  \describe{
    \item{\code{values}:}{Object of class \code{"list"}
     a named list giving the value entries in this key.}
    \item{\code{folders}:}{Object of class \code{"list"} 
    a named list giving the sub-keys and their contents. }
  }
}

\section{Methods}{
No methods defined with class "RegistryKeyContents" in the signature.
}
\references{
 \url{http://www.omegahat.org/SWinRegistry}
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}

\seealso{
 \code{\link{getRegistry}}
}

%\examples{}
\keyword{classes}
