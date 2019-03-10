set   autoscale                        # scale axes automatically
unset log                              # remove any log-scaling
unset label                            # remove any previous labels
set   xtic auto font "Times-Roman,18"  # set xtics automatically
set   ytic auto font "Times-Roman,18"  # set ytics automatically
set   key font "Times-Roman,14"
set   title   "Image 720p"          font "Times-Roman,24"
set   xlabel  "Threads"              font "Times-Roman,24"
set   ylabel  "SpeedUp" offset -2.5  font "Times-Roman,24"
set   bmargin 5
set   lmargin 12
set   rmargin 5
set   tmargin 5
show  margin
plot  "speedup720k3.txt"  using 1:2 title 'k3'  with linespoints,\
      "speedup720k5.txt"  using 1:2 title 'k5'  with linespoints,\
      "speedup720k7.txt"  using 1:2 title 'k7'  with linespoints,\
      "speedup720k9.txt"  using 1:2 title 'k9'  with linespoints,\
      "speedup720k11.txt" using 1:2 title 'k11' with linespoints,\
      "speedup720k13.txt" using 1:2 title 'k13' with linespoints,\
      "speedup720k15.txt" using 1:2 title 'k15' with linespoints
