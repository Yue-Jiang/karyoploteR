


kpBars <- function(karyoplot, data=NULL, chr=NULL, x0=NULL, x1=x0, y1=NULL, y0=NULL, ymin=NULL, ymax=NULL, data.panel=1, r0=NULL, r1=NULL, bar.width=NULL, ...) {
  if(!is(karyoplot, "KaryoPlot")) stop("'karyoplot' must be a valid 'KaryoPlot' object")
  
  #if null, get the r0 and r1
  if(is.null(r0)) r0 <- kp$plot.params[[paste0("data", data.panel, "min")]]
  if(is.null(r1)) r1 <- kp$plot.params[[paste0("data", data.panel, "max")]]
  
  
  ccf <- karyoplot$coord.change.function
  

  
  if(!is.null(data)) {
    chr <- as.character(seqnames(data))
    x0 <- start(data)
    x1 <- end(data)
        
    if(is.null(y1)) {
      if("value" %in% names(mcols(data))) {
        y1 <- data$value
      } else {
        if("y1" %in% names(mcols(data))) {
          y1 <- data$y1
        } else {
          stop("No y1 value specified. It is needed to provide y1 or a column named 'value' or 'y1' in data")
        }
      }
    }
    if(is.null(y0)) {
      if("y0" %in% names(mcols(data))) {
        y0 <- data$y0
      } else {
        if(is.null(y0)) y0 <- rep(karyoplot$plot.params[[paste0("data", data.panel, "min")]], length(y1))
      }
    }
  } 
  
  if(is.null(ymin)) ymin <- min(c(y0, y1))
  if(is.null(ymax)) ymax <- max(c(y0, y1))
  
  #Recicle any values as needed
    chr <- recycle.first(chr, x0, x1, y0, y1)
    x0 <- recycle.first(x0, chr, x1, y0, y1)
    x1 <- recycle.first(x1, chr, x0, y0, y1)
    y0 <- recycle.first(y0, chr, x0, x1, y1)
    y1 <- recycle.first(y1, chr, x0, x1, y0)
  
  #Scale it with ymin and ymax
    y0 <- (y0 - ymin)/(ymax - ymin)
    y1 <- (y1 - ymin)/(ymax - ymin)
    
  #scale y to fit in the [r0, r1] range
    y0 <- (y0*(r1-r0))+r0
    y1 <- (y1*(r1-r0))+r0
    
  

  x0plot <- ccf(chr=chr, x=x0, data.panel=data.panel)$x
  x1plot <- ccf(chr=chr, x=x1, data.panel=data.panel)$x
  y0plot <- ccf(chr=chr, y=y0, data.panel=data.panel)$y
  y1plot <- ccf(chr=chr, y=y1, data.panel=data.panel)$y
  
  
  rect(xleft=x0plot, xright=x1plot, ytop=y1plot, ybottom=y0plot, ...)
  
}