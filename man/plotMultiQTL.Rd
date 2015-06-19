\name{plotMultiQTL}
\title{
Plot QTL point estimates and confidence intervals as horizontal lines
}
\description{
plotMultiQTL provides a system to visualize QTL distributions for many traits. This function integrates directly with R/qtl and the stepwiseStats functions.
}
\usage{
plotMultiQTL(cross, stats = NULL, phes = NULL, chrs = NULL, peak = NULL, right = NULL, left = NULL, col = NULL, chr.subset = NULL, ylabelcex = NULL, rugsize = NULL, cex = NULL, pch = 19, lty = 1, lwd = 1, plotQTLdensity = TRUE, binwidth = 1, adj.ylabsize = TRUE, colbychr = TRUE, palette = rainbow, showConfidenceInterval = TRUE, showPointEstimate = TRUE, outline = FALSE, background = TRUE, plotNullPheno = FALSE, setmargin = NULL, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{cross}{
R/qtl cross object, required
}
  \item{stats}{
Output from stepwiseStats, or a dataframe with column names that match: "phenotype","chromosome","position","lowCIpos","hiCIpos"
}
  \item{phes}{
If stats is NULL, required. A character vector of phenotype names. 
}
  \item{chrs}{
If stats is NULL, required. A character vector of chromosome names/numbers.
}
  \item{peak}{
If stats is NULL and showPointEstimate=TRUE, required. A numeric vector of QTL peak positions.
}
  \item{right}{
     If stats is NULL and showConfidenceInterval=TRUE, required. A numeric vector of right confidence interval bounds names.
}
  \item{left}{
     If stats is NULL and showConfidenceInterval=TRUE, required. A numeric vector of right confidence interval bounds names.
}
  \item{col}{
   A vector of line and point color, indexed by the line in stats, or position in vectors. Can be a single value or a vector with a length identical to the number of rows in stats, or the length of the data Overridden by colbychr
}
  \item{chr.subset}{
Optional. Numeric/character vector of chromosomes by which to subset
}
  \item{ylabelcex}{
     the y axis label size. Can be a single value or a vector with a length identical to the number of rows in stats, or the length of the data
}
  \item{rugsize}{
The height of the genetic map segments. If rugsize=0, suppress the genetic map.
}
  \item{cex}{
     The size of the points representing the point estimates. Can be a single value or a vector with a length identical to the number of rows in stats, or the length of the data
}
  \item{pch}{
    The shape of the points representing the point estimates. Can be a single value or a vector with a length identical to the number of rows in stats, or the length of the data.
}
  \item{lty}{
The line style for lines representing the confidence intervals. Can be a single value or a vector with a length identical to the number of rows in stats, or the length of the data
}
  \item{lwd}{
The linewidth for the lines representing the confidence intervals. Can be a single value or a vector with a length identical to the number of rows in stats, or the length of the data
}
  \item{plotQTLdensity}{
Logical. Should the function plot a density distribution of QTLs at the top of the figure. See details.
}
  \item{binwidth}{
Numeric. If plotQTLdensity=T, this specifies the binwidth (bw) argument in density in terms of cM. See details.
}
  \item{adj.ylabsize}{
Logical. Should the function choose the best y axis label cex
}
  \item{colbychr}{
Logical. Should the QTL be colored by chromosomes
}
  \item{palette}{
If colbychr=T, specifies the palette to use to color chromosomes and points
}
  \item{showConfidenceInterval}{
Logical. Should the confidence intervals be plotted?
}
  \item{showPointEstimate}{
Logical. Should the point estimates be plotted?
}
  \item{outline}{
Logical. Should a box be placed around the plotting area?
}
  \item{background}{
Logical, should a transparent background be placed that helps to visually separate the chromosomes?
}
  \item{plotNullPheno}{
Logical. Should phenotypes without QTL on the subsetted chromosomes be retained? If false, only phenotypes with QTL are plotted
}
  \item{setmargin}{
Optional. The par margin vector of 4 margin sizes. 
}
  \item{\dots}{
Additional arguments passed on to plot. Specify xlab to "chromosome" to reproduce R/qtl - style scanone x axes. 
}
}
\details{
Plots points and segments using R base functions. The plotQTLdensity argument invokes the R base function density which calculates kernal density of QTL from the lowest cM position of a QTL on the first chromosome to the highest cM position on the last chromosome. Specifying binwidth changes the "bw" argument within density. Higher numbers cause greater smoothing of the profile. 
}
\value{
A plot of QTL positions.
}
\references{
Lovell et al. (2015) Exploiting differential gene expression and epistasis to discover candidate genes for drought-associated QTLs in Arabidopsis thaliana. The Plant Cell: Vol. 27: 969–983
}
\author{
John T. Lovell
}

\examples{
library(qtl)
library(plyr)
#use the multitrait dataset first
data(multitrait)
cross <- multitrait
qtlphes<-phenames(cross)[1:8]
cross <- calc.genoprob(cross, step=2.5)
modelList<-lapply(qtlphes, function(x) {
  stepwiseqtl(cross, penalties=c(3,4,3),max.qtl=3, pheno.col=x, method="hk", keeptrace=TRUE, verbose=FALSE, keeplodprofile=TRUE)
})
names(modelList)<-qtlphes

stepParsed<-lapply(qtlphes, function(x){
  stepwiseStats(cross, model.in= modelList[[x]], phe=x, covar=NULL, ci.method="drop", drop=1.5, plot=FALSE, printout=TRUE)
})
statsDF<-ldply(stepParsed, data.frame)
plotMultiQTL(cross=cross, stats=statsDF, ylabelcex=.4, binwidth=5)
}