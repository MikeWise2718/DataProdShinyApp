library(UsingR,quiet=T)
library(ggplot2,quiet=T)
# 
# A rather silly app (server.R) to fulfill the Data Products shiny app requirement
# Mike Wise - 25 Aug 2014 - dataprod-004
#
#
# To run ensure that a ui.r and a server.r are in the directory
# and the shiny library is installed and loaded into the session
# with "library(shiny)"
# then change to that directory in R-studio 
# and invoke the function "runApp()" or
# runGitHub("DataProdProject","MikeWise2718")
#
# Globals
ngen <<- 0
oguide <<- c("pop","mean","med")

shinyServer(
  
  function(input, output) {
  
    # Read data and do std plot
    output$stdplot <- renderPlot(
          { 

            # Get our input variables
            niter <- {input$niter}
            nsamp <- {input$nsamp}
            mu <- {input$mu}
            std <- {input$std}
            guide <- {input$guides}

            doPopGuide <- length(guide[guide=="pop"])
            doMuGuide <- length(guide[guide=="mean"])
            doMedGuide <- length(guide[guide=="med"])

            #print(sprintf("nsamp:%d",nsamp))
            eststd <<- std*(nsamp-1)/nsamp
                  
            sdvec <<- c()
            muvec <<- c()
            mdvec <<- c()
            
            # this block ensures we don't regen the data when we just change a guide
            newdata <- length(oguide)==length(guide)
            if (newdata)
            {
              ngen <<- ngen+1
            }
            set.seed(ngen)
            oguide <<- guide
            
            # Generate the data
            for (i in 1:niter)
            {
              smp <- rnorm( nsamp, mu, std )
              sdsmp <- sd(smp)
              musmp <- mean(smp)
              mdsmp <- median(smp)
              sdvec <<- c( sdvec,sdsmp )
              muvec <<- c( muvec, musmp )
              mdvec <<- c( mdvec, mdsmp )
            }
            df <<- data.frame(stdev=sdvec,mu=muvec,med=mdvec)
            
            # Some local calculations
            mustd <- mean(sdvec)
            medstd <- median(sdvec)
            sdratio <- mustd/std
             
            # Now plot the std histogram
            mtitsd <- sprintf("Histogram of %d Std.Devs for Sample Size:%d  mu:%5.1f  std:%5.1f",niter,nsamp,mu,std)
            xlabsd <- sprintf("Popstd:%5.1f MeanStd:%5.1f MedStd:%5.1f Ratio:%6.4f",std,mustd,medstd,sdratio)

            plt <- {
              hist(df$stdev,main=mtitsd,xlab=xlabsd,ylab="Count",col="pink",breaks=30)
              if (doPopGuide) abline(v=std,col="red")
              if (doMuGuide) abline(v=mustd,col="blue")
              if (doMedGuide) abline(v=medstd,col="green")
            }
          }
    )
    # do mean plot
    output$muplot <- renderPlot(
          { 
            # If we don't reread these variables, we will not generate a new plot
            niter <- {input$niter}
            nsamp <- {input$nsamp}
            mu <- {input$mu}
            std <- {input$std}
            guide <- {input$guides}

            doPopGuide <- length(guide[guide=="pop"])
            doMuGuide <- length(guide[guide=="mean"])
            doMedGuide <- length(guide[guide=="med"])

            # Some local calculations            
            mumu <- mean(muvec)
            medmu <- median(muvec)
            muratio <- mumu/mu
            
            # Now plot the mean histogram            
            mtitmu <- sprintf("Histogram of %d Means for Sample Size:%d  mu:%5.1f  std:%5.1f",niter,nsamp,mu,std)       
            xlabmu <- sprintf("Popmu:%5.1f MeanMu:%5.1f MedMu:%5.1f Ratio:%6.4f",mu,mumu,medmu,muratio)

            plt <- {
              hist(df$mu,main=mtitmu,xlab=xlabmu,ylab="Count",col="lightblue",breaks=30)
              if (doPopGuide) abline(v=mu,col="red")
              if (doMuGuide) abline(v=mumu,col="blue")
              if (doMedGuide) abline(v=medmu,col="green")
            }
          }
      )
  }
)