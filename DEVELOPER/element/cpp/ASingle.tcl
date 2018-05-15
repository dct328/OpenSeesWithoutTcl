model BasicBuilder -ndm 3 -ndf 6
geomTransf Linear 1 1 0 0
geomTransf Linear 2 0 1 0
geomTransf Linear 3 0 0 1
geomTransf Linear 4 1 1 0
geomTransf Corotational 5 0 1 0

# ========================================= nDmaterials ===================================

# ========================================= uniaxial materials ===================================
uniaxialMaterial Steel02 22 995000000 206000000000 0.012 15 0.925 0.15 0 1 0 1

# Steel EndPlate
uniaxialMaterial Steel01 203 2850000000 205000000000 0.02

# =========================================== Sections =======================================

section Fiber 126 {
#patch circ $matTag $numSubdivCirc $numSubdivRad $yCenter $zCenter $intRad $extRad $startAng $endAng
patch circ 22 24 5 0 0 0 0.01 0 360
}

node 1 0 0 0
node 2 0 0 1

fix 1 1 1 1 1 1 1
fix 2 0 1 1 1 1 1

# ========== The Column ============================================================

puts "ProblemType"

#element forceBeamColumn 1 1 2 5 "Lobatto 126 10" -lenfactor 1.5
element ElasticTimoshenkoBeam 1 1 2 206000000000 79231000000 3.1415926e-4 1.570796e-8 7.85398e-9 7.85398e-9 2.82743e-4 2.82743e-4 5 -lenfactor 1.5

timeSeries Trig 8 0 800 800 -factor 0.003

pattern MultipleSupport 9 {
groundMotion 9 Plain -disp 8 -fact 1
imposedMotion 2 1 9
}

recorder Node -file SNodeReaction.out -time -dT 0.5 -node 1 2 -dof 1 2 3 4 5 6 reaction
recorder Node -file SNodeDisp.out -time -dT 0.5 -node 2 -dof 1 2 3 4 5 6 disp
recorder Element -file SElement.out -time -dT 0.5 -ele 1 force

constraints Transformation
numberer  RCM
system UmfPack
test EnergyIncr 1e-11 300 0 2
algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
#algorithm BFGS -count 100
#integrator TRBDF2
integrator Newmark 0.5 0.25
analysis Transient

set ok 0;
set Nsteps 10000;
set step 1;

while {$ok == 0 & $step < [expr $Nsteps +1]} {
  test EnergyIncr 1e-11 300 0 2
  set ok [analyze 1 0.01]
  if {$ok == 0} {
    puts "Running Time History Step: $step out of $Nsteps"
    set step [expr $step+1]
  } else {
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.005 and BFGS"
      test EnergyIncr 1e-11 300 1 2
      algorithm BFGS -count 100
      set ok [analyze 1 0.01]
      algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
      test EnergyIncr 1e-10 300 0 2
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.005 and BFGS"
      test EnergyIncr 1e-11 300 1 2
      set ok [analyze 2 0.005]
      test EnergyIncr 1e-10 300 0 2
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.0025 and BFGS"
      test EnergyIncr 1e-11 300 1 2
      set ok [analyze 4 0.0025]
      test EnergyIncr 1e-10 300 0 2
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.01 and Lower Tol 1e-9"
      test EnergyIncr 1e-11 300 0 2
      algorithm Broyden -count 50
      set ok [analyze 1 0.01]
      #algorithm BFGS -count 100
      algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
      test EnergyIncr 1e-10 300 0 2
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.001 and KrylovNewton "
      algorithm KrylovNewton
      set ok [analyze 10 0.001]
      #algorithm BFGS -count 100
      algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.0005 and KrylovNewton"
      algorithm NewtonLineSearch
      test EnergyIncr 1e-11 300 1 2
      set iter 0
      while {$iter < 10} {
        set ok [analyze 1 0.001 ]
        if {$ok == 0} {
          set iter [expr $iter + 1]
        }
        if {$ok != 0 && $iter < 9} {
          set ok [analyze 1 0.002]
          if {$ok == 0} {
            set iter [expr $iter + 2]
          }
        }
        if {$ok != 0 && $iter < 8} {
          set ok [analyze 1 0.003]
          if {$ok == 0} {
            set iter [expr $iter + 3]
          }
        }
        if {$ok != 0 && $iter < 7} {
          set ok [analyze 1 0.004]
          if {$ok == 0} {
            set iter [expr $iter + 4]
          }
        }
        if {$ok != 0 && $iter < 9} {
          set ok [analyze 2 0.0005]
          if {$ok == 0} {
            set iter [expr $iter + 1]
          }
        }
        if {$ok != 0} {
          break
        }
      }
      #algorithm BFGS -count 100
      algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
      test EnergyIncr 1e-11 300 0 2
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.0005 and BFGS and Tol 1e-8 "
      algorithm BFGS -count 100
      test EnergyIncr 1e-10 300 0 2
      set ok [analyze 20 0.0005 ]
      test EnergyIncr 1e-11 300 0 2
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.0005 and NewtonLineSearch(Secant) "
      #algorithm KrylovNewton -maxDim 2
      algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
      test EnergyIncr 1e-11 300 1 2
      set iter 0
      while {$iter < 20} {
        set ok [analyze 1 0.0005 ]
        if {$ok == 0} {
          set iter [expr $iter + 1]
        }
        if {$ok != 0 && $iter < 19} {
          set ok [analyze 1 0.001]
          if {$ok == 0} {
            set iter [expr $iter + 2]
          }
        }
        if {$ok != 0 && $iter < 18} {
          set ok [analyze 1 0.0015]
          if {$ok == 0} {
            set iter [expr $iter + 3]
          }
        }
        if {$ok != 0 && $iter < 17} {
          set ok [analyze 1 0.002]
          if {$ok == 0} {
            set iter [expr $iter + 4]
          }
        }
        if {$ok != 0} {
          break
        }
      }
      #algorithm BFGS -count 100
      algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
      test EnergyIncr 1e-11 300 0 2
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.0005 and NewtonLineSearch(interpo)"
      #algorithm KrylovNewton -maxDim 2
      algorithm NewtonLineSearch -tol 0.00000001 -maxIter 1000
      test EnergyIncr 1e-11 300 1 2
      set iter 0
      while {$iter < 20} {
        set ok [analyze 1 0.0005 ]
        if {$ok == 0} {
          set iter [expr $iter + 1]
        }
        if {$ok != 0 && $iter < 19} {
          set ok [analyze 1 0.001]
          if {$ok == 0} {
            set iter [expr $iter + 2]
          }
        }
        if {$ok != 0 && $iter < 18} {
          set ok [analyze 1 0.0015]
          if {$ok == 0} {
            set iter [expr $iter + 3]
          }
        }
        if {$ok != 0 && $iter < 17} {
          set ok [analyze 1 0.002]
          if {$ok == 0} {
            set iter [expr $iter + 4]
          }
        }
        if {$ok != 0} {
          break
        }
      }
      #algorithm BFGS -count 100
      algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
      test EnergyIncr 1e-11 300 0 2
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.0005 and KrylovNewton"
      algorithm NewtonLineSearch
      test EnergyIncr 1e-11 300 1 2
      set iter 0
      while {$iter < 20} {
        set ok [analyze 1 0.0005 ]
        if {$ok == 0} {
          set iter [expr $iter + 1]
        }
        if {$ok != 0 && $iter < 19} {
          set ok [analyze 1 0.001]
          if {$ok == 0} {
            set iter [expr $iter + 2]
          }
        }
        if {$ok != 0 && $iter < 18} {
          set ok [analyze 1 0.0015]
          if {$ok == 0} {
            set iter [expr $iter + 3]
          }
        }
        if {$ok != 0 && $iter < 17} {
          set ok [analyze 1 0.002]
          if {$ok == 0} {
            set iter [expr $iter + 4]
          }
        }
        if {$ok != 0} {
          break
        }
      }
      #algorithm BFGS -count 100
      algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
      test EnergyIncr 1e-11 300 0 2
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
  }
}

