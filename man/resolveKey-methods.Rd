\name{resolveKey-methods}
\docType{methods}
\alias{resolveKey-methods}
\alias{resolveKey,RegistryKeyPath-method}
\alias{resolveKey,character-method}
\title{Verify key is in registry}
\description{
These methods organize the key specification into
a \code{RegistryKeyPath} and verify that
it exists within the registry.
The methods differ in the form the key is specified.
}
\section{Methods}{
\describe{

\item{path = "character"}{the simple interactive version for specifying the key
 as a single string or collection of strings.}
\item{path = "RegistryKeyPath"}{
 the more formal version that provides the key as a structured
object of class \code{RegistryKeyPath}.  
}
}}
\keyword{methods}
\keyword{utilities}
