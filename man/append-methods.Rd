\name{append-methods}
\docType{methods}
\alias{append-methods}
\alias{append,RegistryKeyPath,character-method}
\title{Method for appending an entry to a registry path.}
\description{
 This is a convenience method for adding a path entry
 to an existing  registry key identifier.
 This allows one to cumulate nested folders to a path identifier.
 
}
\section{Methods}{
\describe{
\item{x = "RegistryKeyPath", values = "character"}{
 append the specified strings to an existing \code{RegistryKeyPath}.
 \code{x} should identify  a folder and not a terminal key.
}
}}
\keyword{methods}
\keyword{utilities}

