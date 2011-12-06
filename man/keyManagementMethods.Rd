\name{createRegistryKey-methods}
\docType{methods}
\alias{createRegistryKey-methods}
\alias{createRegistryKey,character,ANY-method}
\alias{createRegistryKey,RegistryKeyPath,missing-method}
\alias{createRegistryKey,RegistryKeyPath,character-method}
\alias{deleteRegistryKey-methods}
\alias{deleteRegistryKey,character,ANY-method}
\alias{deleteRegistryKey,RegistryValuePath,missing-method}
\alias{deleteRegistryKey,RegistryKeyPath,character-method}
\alias{deleteRegistryKey,RegistryKeyPath,missing-method}
\title{Manage Registry Keys}
\description{
 These methods provide facilities to manage
(create and destroy) keys within the Windows registry.
The methods provide different ways to specify
the key, using either a collection of strings
or a previously resolved registry path
(\code{RegistryKeyPath}).
The latter are typically used internally within the package
and are available for users who apply operations
repeatedly to the same key.
The simple string form is more convenient for interactive use.

\code{flushRegistryKey} can be used
to force any changes to be immediately reflected
in the registry.
}
\section{Methods}{
\describe{

\item{path = "character", key = "ANY"}{
  specifies the path to the new key
  as either a string or a character vector of strings.
}

\item{path = "RegistryKeyPath", key = "missing"}{
specifies the path and name of the new key as  
a \code{RegistryKeyPath} object.
 }

\item{path = "RegistryKeyPath", key = "character"}{
 identifies the folder in which the new key is to be created
 via a \code{RegistryKeyPath} and the name of the new
 key as a simple string.
}
}}
\keyword{methods}
\keyword{utilities}
