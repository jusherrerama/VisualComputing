      # This file is called   force.p
      set   autoscale                        # scale axes automatically
      unset log                              # remove any log-scaling
      unset label                            # remove any previous labels
      set xtic auto                          # set xtics automatically
      set ytic auto                          # set ytics automatically
      set title "Image 4k"
      set xlabel "Threads"
      set ylabel "Time(ms)"
      plot    "4kk3.txt" using 1:2 title 'k3' with linespoints , \
            "4kk5.txt" using 1:2 title 'k5' with linespoints, \
            "4kk7.txt" using 1:2 title 'k7' with linespoints, \
            "4kk9.txt" using 1:2 title 'k9' with linespoints, \
            "4kk11.txt" using 1:2 title 'k11' with linespoints, \
            "4kk13.txt" using 1:2 title 'k13' with linespoints, \
            "4kk15.txt" using 1:2 title 'k15' with linespoints
