\name{setRegistryValue-methods}
\docType{methods}
\alias{setRegistryValue-methods}
\alias{setRegistryValue,character,character-method}
\alias{setRegistryValue,character,missing-method}
\alias{setRegistryValue,RegistryKeyPath,character-method}
\alias{setRegistryValue,RegistryValuePath-method}
\alias{setRegistryValue,RegistryValuePath,ANY-method}
\title{Set Registry Value}
\description{
 These methods allows the caller to set the value of a key in the registry.
 The methods differ in how the key is identified. 
}
\section{Methods}{
\describe{

\item{path = "character", key = "character"}{
 specify the key as a folder and key/name within
 the folder where the folder is given as a single
 string  or an ordered vector of nested folder names.
}

\item{path = "character", key = "missing"}{
This is similar to the method above, but the
key/name is given as the final element of the \code{path}
argument.
}
\item{path = "RegistryKeyPath", key = "character"}{
 This is the version that uses a structured object
of class \code{RegistryKeyPath} to specify the path
of the folder in which the key is to be set.
The name of the new value is given by \code{key}.
}

\item{path = "RegistryValuePath"}{
 And this version of the method 
allows the caller to specify the entire key identifier
in a single \code{RegistryValuePath} object,
including the path to the folder containing
the key and the name of the key itself.
}
}}
\keyword{methods}
\keyword{utilities}

