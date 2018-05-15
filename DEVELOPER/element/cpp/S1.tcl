model BasicBuilder -ndm 3 -ndf 6
geomTransf Linear 1 1 0 0
geomTransf Linear 2 0 1 0
geomTransf Linear 3 0 0 1
geomTransf Linear 4 1 1 0
geomTransf PDelta 5 0 1 0

set pi 3.1415926
set dhole 21.5
set dbolt 20.0
set nbolt 1.0
set EBolt 206000.0
set PossionsRatio 0.3

set EPlate 205000.0
set FyPlate 235.0
set FrictionCoeff 0.242
set dcoreplate 16.0
set dcoverplate 7.2
set PlateWidth 80.0

set PreLoad 155000.0

set ABolt [expr $pi*$dbolt*$dbolt/4*$nbolt]
set ABoltShear [expr $ABolt*0.9]
set IBolt [expr $pi*pow($dbolt*0.5,4)/4*$nbolt]
set JBolt [expr $IBolt*10]
set GBolt [expr $EBolt/(2*($PossionsRatio+1))]

set l1 145.0
set l2 65.0
set l3 47.5

# ========================================= uniaxial materials ===================================

## Rigid Material
uniaxialMaterial Elastic 102 2.1e9

## Flexible Material
uniaxialMaterial Elastic 103 2.1e-6

## Pretension Material
uniaxialMaterial Steel02 22 995000000 1 0.012 15 0.925 0.15 0 1 0 1 [expr $PreLoad/($ABolt/$nbolt)]

# End Plate Material
uniaxialMaterial Steel01 203 $FyPlate $EPlate 0.02

uniaxialMaterial ElasticMultiLinear 1 -strain -5 [expr $dbolt-$dhole] 0 [expr -$dbolt+$dhole] 5 -stress -1056489.74958 -0.1 0 0.1 1056489.74958

# =========================================== Sections ========================================

# section of core plate with normal width
section Fiber 11 {
patch rect 203 10 10 [expr -$dcoreplate/2] [expr -$PlateWidth/2] [expr $dcoreplate/2] [expr $PlateWidth/2]
}

# section of core plate with width 255.12
set tempw 255.12
section Fiber 12 {
patch rect 203 10 10 [expr -$dcoreplate/2] [expr -$tempw/2] [expr $dcoreplate/2] [expr $tempw/2]
}

# section of core plate with width 204.034
set tempw 204.034
section Fiber 13 {
patch rect 203 10 10 [expr -$dcoreplate/2] [expr -$tempw/2] [expr $dcoreplate/2] [expr $tempw/2]
}

# section of core plate with width 152.948
set tempw 152.948
section Fiber 14 {
patch rect 203 10 10 [expr -$dcoreplate/2] [expr -$tempw/2] [expr $dcoreplate/2] [expr $tempw/2]
}

# section of core plate with width 152.948
set tempw 99.973
section Fiber 15 {
patch rect 203 10 10 [expr -$dcoreplate/2] [expr -$tempw/2] [expr $dcoreplate/2] [expr $tempw/2]
}

# section of cover plate with normal width
section Fiber 21 {
#patch quad $matTag $numSubdivIJ $numSubdivJK $yI $zI $yJ $zJ $yK $zK $yL $zL
patch rect 203 10 10 [expr -$dcoverplate/2] [expr -$PlateWidth/2] [expr $dcoverplate/2] [expr $PlateWidth/2]
}

# section of cover plate with width 253.54
set tempw 253.54
section Fiber 22 {
#patch quad $matTag $numSubdivIJ $numSubdivJK $yI $zI $yJ $zJ $yK $zK $yL $zL
patch rect 203 10 10 [expr -$dcoverplate/2] [expr -$tempw/2] [expr $dcoverplate/2] [expr $tempw/2]
}

# section of cover plate with width 202.352
set tempw 202.352
section Fiber 23 {
#patch quad $matTag $numSubdivIJ $numSubdivJK $yI $zI $yJ $zJ $yK $zK $yL $zL
patch rect 203 10 10 [expr -$dcoverplate/2] [expr -$tempw/2] [expr $dcoverplate/2] [expr $tempw/2]
}

# section of cover plate with width 151.162
set tempw 151.162
section Fiber 24 {
#patch quad $matTag $numSubdivIJ $numSubdivJK $yI $zI $yJ $zJ $yK $zK $yL $zL
patch rect 203 10 10 [expr -$dcoverplate/2] [expr -$tempw/2] [expr $dcoverplate/2] [expr $tempw/2]
}

# section of cover plate with width 99.973
set tempw 99.973
section Fiber 25 {
#patch quad $matTag $numSubdivIJ $numSubdivJK $yI $zI $yJ $zJ $yK $zK $yL $zL
patch rect 203 10 10 [expr -$dcoverplate/2] [expr -$tempw/2] [expr $dcoverplate/2] [expr $tempw/2]
}

# Friction
frictionModel Coulomb 2 $FrictionCoeff

# ====================================== Nodes ==============================================
# Nodes of core plate
node 1 [expr -$l1-$l2-$l3] 0 0
node 2 [expr -$l3-$l2] 0 0
node 102 [expr -$l3-$l2] 0 0
node 3 [expr -$l3] 0 0
node 103 [expr -$l3] 0 0
node 4 [expr $l3] 0 0
node 104 [expr $l3] 0 0
node 5 [expr $l3+$l2] 0 0
node 105 [expr $l3+$l2] 0 0
node 6 [expr $l1+$l2+$l3] 0 0

# Nodes of upper cover plate
node 7 [expr -$l3-$l2] 0 [expr $dcoreplate/2+$dcoverplate/2]
node 8 [expr -$l3] 0 [expr $dcoreplate/2+$dcoverplate/2]
node 9 [expr $l3] 0 [expr $dcoreplate/2+$dcoverplate/2]
node 10 [expr $l3+$l2] 0 [expr $dcoreplate/2+$dcoverplate/2]

# Nodes of lower cover plate
node 11 [expr -$l3-$l2] 0 [expr -$dcoreplate/2-$dcoverplate/2]
node 12 [expr -$l3] 0 [expr -$dcoreplate/2-$dcoverplate/2]
node 13 [expr $l3] 0 [expr -$dcoreplate/2-$dcoverplate/2]
node 14 [expr $l3+$l2] 0 [expr -$dcoreplate/2-$dcoverplate/2]

fix 1 1 1 1 1 1 1
fix 6 0 1 1 1 1 1
puts "fee"
# ====================================== Elements ==============================================
# ========== Elements of Core Plate ==
set integration "Lobatto 11 10"
element forceBeamColumn 1 1 2 2 $integration

set locations "0 0.11111 0.22222 0.33333 0.44444 0.55555 0.66667 0.77778 0.88889 1"
set secTags "11 11 11 11 11 11 12 13 14 15"
set integration "FixedLocation 10 $secTags $locations"
element forceBeamColumn 2 2 3 2 $integration

set locations "0 0.11111 0.22222 0.33333 0.44444 0.55555 0.66667 0.77778 0.88889 1"
set secTags "15 14 13 12 11 11 11 11 11 11"
set integration "FixedLocation 10 $secTags $locations"
element forceBeamColumn 3 4 5 2 $integration

set integration "Lobatto 11 10"
element forceBeamColumn 4 5 6 2 $integration

# ========== Elements of upper Cover Plate ==
set locations "0 0.11111 0.22222 0.33333 0.44444 0.55555 0.66667 0.77778 0.88889 1"
set secTags "25 24 23 22 21 21 21 21 21 21"
set integration "FixedLocation 10 $secTags $locations"
element forceBeamColumn 5 7 8 2 $integration

set integration "Lobatto 11 10"
element forceBeamColumn 6 8 9 2 $integration

set locations "0 0.11111 0.22222 0.33333 0.44444 0.55555 0.66667 0.77778 0.88889 1"
set secTags "21 21 21 21 21 21 22 23 24 25"
set integration "FixedLocation 10 $secTags $locations"
element forceBeamColumn 7 9 10 2 $integration

# ========== Elements of lower Cover Plate ==
set locations "0 0.11111 0.22222 0.33333 0.44444 0.55555 0.66667 0.77778 0.88889 1"
set secTags "25 24 23 22 21 21 21 21 21 21"
set integration "FixedLocation 10 $secTags $locations"
element forceBeamColumn 8 11 12 2 $integration

set integration "Lobatto 11 10"
element forceBeamColumn 9 12 13 2 $integration

set locations "0 0.11111 0.22222 0.33333 0.44444 0.55555 0.66667 0.77778 0.88889 1"
set secTags "21 21 21 21 21 21 22 23 24 25"
set integration "FixedLocation 10 $secTags $locations"
element forceBeamColumn 10 13 14 2 $integration

# ========== Elements of Friction Bearings ==
set ShearRatio [expr $dcoreplate/($dcoreplate+$dcoverplate)]
element singleFPBearing 201 2 7 2 100 170000000 -P 102 -T 102 -My 103 -Mz 102 -shearDist $ShearRatio -iter 500 1e-8
element singleFPBearing 202 2 11 2 100 170000000 -P 102 -T 102 -My 103 -Mz 102 -shearDist $ShearRatio -iter 500 1e-8
element singleFPBearing 203 3 8 2 100 170000000 -P 102 -T 102 -My 103 -Mz 102 -shearDist $ShearRatio -iter 500 1e-8
element singleFPBearing 204 3 12 2 100 170000000 -P 102 -T 102 -My 103 -Mz 102 -shearDist $ShearRatio -iter 500 1e-8

element singleFPBearing 205 4 9 2 100 170000000 -P 102 -T 102 -My 103 -Mz 102 -shearDist $ShearRatio -iter 500 1e-8
element singleFPBearing 206 4 13 2 100 170000000 -P 102 -T 102 -My 103 -Mz 102 -shearDist $ShearRatio -iter 500 1e-8
element singleFPBearing 207 5 10 2 100 170000000 -P 102 -T 102 -My 103 -Mz 102 -shearDist $ShearRatio -iter 500 1e-8
element singleFPBearing 208 5 14 2 100 170000000 -P 102 -T 102 -My 103 -Mz 102 -shearDist $ShearRatio -iter 500 1e-8

# ========== Elements of Bolt Shank ==
set lenf [expr ($dcoreplate + $dcoverplate*2)/($dcoreplate + $dcoverplate)]
element ElasticTimoshenkoBeam 301 102 7 $EBolt $GBolt $ABolt $JBolt $IBolt $IBolt $ABoltShear $ABoltShear 5 -lenfactor $lenf
element ElasticTimoshenkoBeam 302 102 11 $EBolt $GBolt $ABolt $JBolt $IBolt $IBolt $ABoltShear $ABoltShear 5 -lenfactor $lenf
element ElasticTimoshenkoBeam 303 103 8 $EBolt $GBolt $ABolt $JBolt $IBolt $IBolt $ABoltShear $ABoltShear 5 -lenfactor $lenf
element ElasticTimoshenkoBeam 304 103 12 $EBolt $GBolt $ABolt $JBolt $IBolt $IBolt $ABoltShear $ABoltShear 5 -lenfactor $lenf

element ElasticTimoshenkoBeam 305 104 9 $EBolt $GBolt $ABolt $JBolt $IBolt $IBolt $ABoltShear $ABoltShear 5 -lenfactor $lenf
element ElasticTimoshenkoBeam 306 104 13 $EBolt $GBolt $ABolt $JBolt $IBolt $IBolt $ABoltShear $ABoltShear 5 -lenfactor $lenf
element ElasticTimoshenkoBeam 307 105 10 $EBolt $GBolt $ABolt $JBolt $IBolt $IBolt $ABoltShear $ABoltShear 5 -lenfactor $lenf
element ElasticTimoshenkoBeam 308 105 14 $EBolt $GBolt $ABolt $JBolt $IBolt $IBolt $ABoltShear $ABoltShear 5 -lenfactor $lenf

# ========== Elements of Applying Pretension ==
element truss 401 11 7 $ABolt 22
element truss 402 12 8 $ABolt 22
element truss 403 13 9 $ABolt 22
element truss 404 14 10 $ABolt 22

# ========== Elements of Local Bearing ==
element zeroLength 501 2 102 -mat 1 -dir 1 -orient 1 0 0 0 1 0
element zeroLength 502 3 103 -mat 1 -dir 1 -orient 1 0 0 0 1 0
element zeroLength 503 4 104 -mat 1 -dir 1 -orient 1 0 0 0 1 0
element zeroLength 504 5 105 -mat 1 -dir 1 -orient 1 0 0 0 1 0

timeSeries Trig 8 0 250 1000 -factor 6

pattern MultipleSupport 9 {
groundMotion 9 Plain -disp 8 -fact 1
imposedMotion 6 1 9
}

recorder Node -file HBS2NodeDisp6.out -time -dT 0.5 -node 6 -dof 1 2 3 4 5 6 disp
recorder Node -file HBS2NodeDisp123456.out -time -dT 0.5 -node 1 2 3 4 5 6 -dof 1 disp
recorder Element -file HBS2Elements.out -time -dT 0.5 -ele 1 4 globalForce

constraints Transformation
numberer  RCM
system UmfPack
test EnergyIncr 1e-7 300 0 2
#algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
algorithm KrylovNewton
integrator TRBDF2
#integrator Newmark 0.5 0.25
analysis Transient

#parameter 1 element 401 material sigini
#parameter 2 element 402 material sigini

set ok 0;
set Nsteps 25000;
set step 1;

while {$ok == 0 & $step < [expr $Nsteps +1]} {
  test EnergyIncr 1e-7 300 1 2
  set ok [analyze 1 0.01]
  if {$ok == 0} {
    #set ps [expr 493380323.6*(pow(2,-$step*1.0/$Nsteps))]
    #puts $ps
    #updateParameter 1 $ps
    #updateParameter 2 $ps
    puts "Running Time History Step: $step out of $Nsteps"
    set step [expr $step+1]
  } else {
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.005 and BFGS"
      test EnergyIncr 1e-7 300 1 2
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
      test EnergyIncr 1e-7 300 1 2
      set ok [analyze 2 0.005]
      test EnergyIncr 1e-6 300 0 2
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.0025 and BFGS"
      test EnergyIncr 1e-7 300 1 2
      set ok [analyze 4 0.0025]
      test EnergyIncr 1e-6 300 0 2
      if {$ok == 0} {
        puts "Running Time History Step: $step out of $Nsteps"
        set step [expr $step+1]
      }
    }
    if {$ok != 0} {
      puts "Trying Lower Dt: 0.01 and Lower Tol 1e-9"
      test EnergyIncr 1e-7 300 0 2
      algorithm Broyden -count 50
      set ok [analyze 1 0.01]
      #algorithm BFGS -count 100
      algorithm NewtonLineSearch -type Secant -tol 0.00000001 -maxIter 1000
      test EnergyIncr 1e-6 300 0 2
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
      test EnergyIncr 1e-7 300 1 2
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
