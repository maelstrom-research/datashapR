% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/01-dictionaries_functions.R
\name{data_dict_apply}
\alias{data_dict_apply}
\title{Apply a data dictionary to any dataset}
\usage{
data_dict_apply(data, data_dict = NULL)
}
\arguments{
\item{data}{A tibble identifying the input data observations associated to
its data dictionary.}

\item{data_dict}{A list of tibble(s) representing meta data of an
associated dataset.
Automatically generated if not provided.}
}
\value{
A tibble identifying the dataset with the data dictionary applied to each
variable as attributes.
}
\description{
Applies a data dictionary to a data structure, creating a labelled dataset.
All previous attributes will be preserved, in particular factors (and its
associated attribute 'levels' which will be transform into attributes
'labels' and its values recasted into their proper datatype.
}
\details{
A data dictionary-like structure must be a list of at least one or two
data frame or data frame extension (e.g. a tibble) named 'Variables'
and 'Categories' (if any), representing meta data of an associated dataset.
The 'Variables' component must contain at least 'name' column and the
'Categories' component must at least contain 'variable' and 'name'
columns to be usable in any function of the package.
To be considered as a minimum (workable) data dictionary, it must also
have unique and non-null entries in 'name' column and the combination
'name'/'variable' must also be unique in 'Categories'.
In addition, the data dictionary may follow Maelstrom research standards,
and its content can be evaluated accordingly, such as naming convention
restriction, columns like 'valueType', 'missing' and 'label(:xx)',
and/or any taxonomy provided.

A dataset must be a data frame or data frame extension (e.g. a tibble) and
can be associated to a data dictionary. If not, a minimum workable data
dictionary can always be generated, when any column will be reported, and
any factor column will be analysed as categorical variable (the column
'levels' will be created for that. In addition, the dataset may follow
Maelstrom research standards, and its content can be evaluated accordingly,
such as naming convention restriction, or id columns declaration (which
full completeness is mandatory.
}
\examples{
\dontrun{
# Example 1: yyy yyy yyy.
}

}
\seealso{
\code{\link[base:attributes]{base::attributes()}}
}
