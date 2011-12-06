\name{getRegistrySubKeyNames-methods}
\docType{methods}
\alias{getRegistrySubKeyNames-methods}
\alias{getRegistrySubKeyNames,character-method}
\alias{getRegistrySubKeyNames,RegistryKeyPath-method}
\title{Names of sub-keys in Windows Registry Folder}
\description{
 These methods provide different ways to specify the 
 key of interest, either as a single string
 or as a more formal, pre-computed \code{RegistryKeyPath}.
}
\section{Methods}{
\describe{

\item{path = "character"}{the simpler specification
 of the key as either a single string or an ordered character vector
 identifying the nested folders within the registry.}

\item{path = "RegistryKeyPath"}{
 the \code{RegistryKeyPath} identifying the path
 in the registry to the key of interest.
}
}}
\keyword{methods}
\keyword{utilities}

