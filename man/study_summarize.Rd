% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/07-data_summarise.R
\name{study_summarize}
\alias{study_summarize}
\title{Generate an Excel spreadsheet report of a study-specific datasets list}
\usage{
study_summarize(study, taxonomy = NULL, valueType_guess = TRUE)
}
\arguments{
\item{study}{List of tibble, each of them being study specific datasets.}

\item{taxonomy}{A data frame or data frame extension (e.g. a tibble),
identifying the scheme used for variables classification as a tibble.}

\item{valueType_guess}{Whether the output should include a more accurate
valueType that could be applied to the dataset. TRUE by default.}
}
\value{
A list of tibbles of report for each study-specific dataset.
}
\description{
Generates an Excel spreadsheet report for a study-specific dataset
list (or study) showing descriptive statistics for each variable to
facilitate the assessment of input data. Statistics are generated according
to their valueType.
This report can be used to assist the user in the assessment of the data
structure, fields investigation (mandatory or not), coherence across elements
and taxonomy, or standard evaluation. The summary associated provides
dataset composition, with observation distribution and descriptive statistics.
}
\details{
A study must be a named list containing at least one data frame or
data frame extension (e.g. a tibble), each of them being datasets.
The name of each tibble will be use as the reference name of the dataset.

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
dataset <- study_TOKYO \%>\% mutate(
           dob = fabR::as_any_date(dob, format = ""mdy""))
data_dict <- dd_TOKYO_format_maelstrom_tagged
study_assessment_report(dataset, data_dict)
}

}
